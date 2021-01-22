import 'package:built_value/built_value.dart' show newBuiltValueToStringHelper;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
import 'data/repository/city_repository_impl.dart';
import 'data/repository/favorites_repository_impl.dart';
import 'data/repository/movie_repository_impl.dart';
import 'data/repository/reservation_repository_impl.dart';
import 'data/repository/user_repository_impl.dart';
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
  // Env
  //
  await _envConfig();

  //
  // Firebase, Google, Facebook
  //
  await Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  FcmNotificationManager fcmNotificationManager;
  final firebaseMessaging = FirebaseMessaging();
  firebaseMessaging.configure(
    onMessage: (msg) => fcmNotificationManager.onMessage(msg),
    onBackgroundMessage: myBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch: $message');
      // _navigateToItemDetail(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print('onResume: $message');
      // _navigateToItemDetail(message);
    },
  );
  final googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();

  //
  // Local and remote
  //
  RxSharedPreferencesConfigs.logger = null;
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
  fcmNotificationManager = FcmNotificationManager(authClient);

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
        Provider.value(mappers.commentsResponseToComments),
        Provider.value(mappers.commentResponseToComment),
        Provider.value(mappers.ticketResponseToTicket),
        Provider.value(mappers.notificationResponseToNotification),
        Provider.value(mappers.theatreResponseToTheatre),
        Provider.value(mappers.productResponseToProduct),
        Provider.value(mappers.cardResponseToCard),
        Provider.value(mappers.promotionResponseToPromotion),
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
  await remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
  try {
    await remoteConfig.fetch(expiration: Duration.zero);
    await remoteConfig.activateFetched();

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
