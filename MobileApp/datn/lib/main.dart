import 'package:built_value/built_value.dart' show newBuiltValueToStringHelper;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide Notification, Card;
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import 'app.dart';
import 'data/local/search_keyword_source_impl.dart';
import 'data/local/user_local_source_impl.dart';
import 'data/mappers.dart' as mappers;
import 'data/remote/auth_client.dart';
import 'data/remote/response/card_response.dart';
import 'data/remote/response/comment_response.dart';
import 'data/remote/response/comments_response.dart';
import 'data/remote/response/notification_response.dart';
import 'data/remote/response/product_response.dart';
import 'data/remote/response/promotion_response.dart';
import 'data/remote/response/theatre_response.dart';
import 'data/remote/response/ticket_response.dart';
import 'data/repository/city_repository_impl.dart';
import 'data/repository/favorites_repository_impl.dart';
import 'data/repository/movie_repository_impl.dart';
import 'data/repository/reservation_repository_impl.dart';
import 'data/repository/user_repository_impl.dart';
import 'domain/model/card.dart';
import 'domain/model/comment.dart';
import 'domain/model/comments.dart';
import 'domain/model/notification.dart';
import 'domain/model/product.dart';
import 'domain/model/promotion.dart';
import 'domain/model/theatre.dart';
import 'domain/model/ticket.dart';
import 'domain/repository/city_repository.dart';
import 'domain/repository/favorites_repository.dart';
import 'domain/repository/movie_repository.dart';
import 'domain/repository/reservation_repository.dart';
import 'domain/repository/user_repository.dart';
import 'env_manager.dart';
import 'fcm_notification.dart';
import 'locale_bloc.dart';
import 'utils/custom_indenting_built_value_to_string_helper.dart';
import 'utils/type_defs.dart';

void main() async {
  newBuiltValueToStringHelper =
      (className) => CustomIndentingBuiltValueToStringHelper(className, true);

  WidgetsFlutterBinding.ensureInitialized();

  //
  // Init Firebase
  //
  await Firebase.initializeApp();

  //
  // Env
  //
  await _envConfig();

  //
  // Firebase, Google, Facebook
  //

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final firebaseMessaging = FirebaseMessaging.instance;

  final googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();

  //
  // Local and remote
  //
  RxSharedPreferencesConfigs.logger = const RxSharedPreferencesDefaultLogger();
  final preferences = RxSharedPreferences.getInstance();
  final userLocalSource = UserLocalSourceImpl(preferences);
  final keywordSource = SearchKeywordSourceImpl(preferences);

  final client = http.Client();
  const httpTimeout = Duration(seconds: 20);

  final normalClient = NormalClient(client, httpTimeout);
  print(normalClient);

  Function0<Future<void>> _onSignOut;
  final authClient = AuthClient(
    client,
    httpTimeout,
    () => _onSignOut(),
    () => userLocalSource.token,
  );

  //
  // Repositories
  //
  final fcmNotificationManager = FcmNotificationManager(
    authClient,
    firebaseMessaging,
    preferences,
  );

  final userRepository = UserRepositoryImpl(
    auth,
    userLocalSource,
    authClient,
    mappers.userResponseToUserLocal,
    storage,
    mappers.userLocalToUserDomain,
    googleSignIn,
    facebookLogin,
    firebaseMessaging,
    keywordSource,
  );
  _onSignOut = userRepository.logout;

  final movieRepositoryFactory = (BuildContext _) {
    return MovieRepositoryImpl(
      authClient,
      mappers.movieResponseToMovie,
      mappers.showTimeAndTheatreResponsesToTheatreAndShowTimes,
      mappers.movieDetailResponseToMovie,
      mappers.movieAndShowTimeResponsesToMovieAndShowTimes,
      keywordSource,
      mappers.categoryResponseToCategory,
    );
  };

  final cityRepository = CityRepositoryImpl(preferences, userLocalSource);

  final reservationRepositoryFactory = (BuildContext context) {
    return ReservationRepositoryImpl(
      authClient,
      userLocalSource,
      mappers.reservationResponseToReservation,
      mappers.fullReservationResponseToReservation,
    );
  };

  final favoritesRepositoryFactory = (BuildContext context) {
    return FavoritesRepositoryImpl(
      authClient,
      mappers.movieResponseToMovie,
    );
  };

  final localeBloc = LocaleBloc(preferences);

  runApp(
    Providers(
      providers: [
        Provider<AuthClient>.value(authClient),
        // Mappers
        Provider<Function1<CommentsResponse, Comments>>.value(
            mappers.commentsResponseToComments),
        Provider<Function1<CommentResponse, Comment>>.value(
            mappers.commentResponseToComment),
        Provider<Function1<TicketResponse, Ticket>>.value(
            mappers.ticketResponseToTicket),
        Provider<Function1<NotificationResponse, Notification>>.value(
            mappers.notificationResponseToNotification),
        Provider<Function1<TheatreResponse, Theatre>>.value(
            mappers.theatreResponseToTheatre),
        Provider<Function1<ProductResponse, Product>>.value(
            mappers.productResponseToProduct),
        Provider<Function1<CardResponse, Card>>.value(
            mappers.cardResponseToCard),
        Provider<Function1<PromotionResponse, Promotion>>.value(
            mappers.promotionResponseToPromotion),
        // App scope repos
        Provider<UserRepository>.value(userRepository),
        Provider<CityRepository>.value(cityRepository),
        Provider<MovieRepository>.factory(movieRepositoryFactory),
        Provider<ReservationRepository>.factory(reservationRepositoryFactory),
        Provider<FavoritesRepository>.factory(favoritesRepositoryFactory),
        Provider<FcmNotificationManager>.value(fcmNotificationManager),
      ],
      child: BlocProvider(
        initBloc: (_) => localeBloc,
        child: MyApp(),
      ),
    ),
  );
}

Future<void> _envConfig() async {
  final fromRemote = <EnvKey, String>{};

  final remoteConfig = await RemoteConfig.instance;

  // Using zero duration to force fetching from remote server.
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ),
  );
  try {
    await remoteConfig.fetchAndActivate();

    final baseUrl =
        remoteConfig.getString(EnvKey.BASE_URL.toString().split('.')[1]);
    if (baseUrl != null && baseUrl.isNotEmpty) {
      fromRemote[EnvKey.BASE_URL] = baseUrl;
    }

    print('###### baseUrl=${baseUrl}');
  } catch (e) {
    print('###### error $e');
  }

  await EnvManager.shared.config(EnvPath.PROD, fromRemote);
}
