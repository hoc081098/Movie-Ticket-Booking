import 'dart:convert';

import 'package:built_value/built_value.dart' show newBuiltValueToStringHelper;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import 'app.dart';
import 'data/local/user_local_source_impl.dart';
import 'data/mappers.dart' as mappers;
import 'data/remote/auth_client.dart';
import 'data/repository/city_repository_impl.dart';
import 'data/repository/comment_repository_impl.dart';
import 'data/repository/favorites_repository_impl.dart';
import 'data/repository/movie_repository_impl.dart';
import 'data/repository/reservation_repository_impl.dart';
import 'data/repository/ticket_repository_impl.dart';
import 'data/repository/user_repository_impl.dart';
import 'domain/repository/city_repository.dart';
import 'domain/repository/comment_repository.dart';
import 'domain/repository/favorites_repository.dart';
import 'domain/repository/movie_repository.dart';
import 'domain/repository/reservation_repository.dart';
import 'domain/repository/ticket_repository.dart';
import 'domain/repository/user_repository.dart';
import 'env_manager.dart';
import 'utils/custom_indenting_built_value_to_string_helper.dart';
import 'utils/type_defs.dart';

void main() async {
  newBuiltValueToStringHelper =
      (className) => CustomIndentingBuiltValueToStringHelper(className, true);

  WidgetsFlutterBinding.ensureInitialized();

  //
  // Env
  //
  await EnvManager.shared.config(EnvPath.DEV);

  //
  // Firebase, Google, Facebook
  //
  await Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final firebaseMessaging = FirebaseMessaging();
  firebaseMessaging.configure(
    onMessage: onMessage,
    onBackgroundMessage: myBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      // _navigateToItemDetail(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
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

  final client = http.Client();
  const httpTimeout = Duration(seconds: 15);

  final normalClient = NormalClient(client, httpTimeout);
  print(normalClient);

  Function0<Future<void>> _onSignOut;
  final authClient = AuthClient(
    client,
    httpTimeout,
    () => _onSignOut(),
    () => userLocalSource.token$.first,
  );

  //
  // Repositories
  //
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
  );
  _onSignOut = userRepository.logout;

  final movieRepository = MovieRepositoryImpl(
    authClient,
    mappers.movieResponseToMovie,
    mappers.showTimeAndTheatreResponsesToTheatreAndShowTimes,
    mappers.movieDetailResponseToMovie,
  );

  final cityRepository = CityRepositoryImpl(preferences, userLocalSource);

  final commentRepository = CommentRepositoryImpl(
    authClient,
    mappers.commentsResponseToComments,
    mappers.commentResponseToComment,
  );

  final ticketRepository = TicketRepositoryImpl(
    authClient,
    mappers.ticketResponseToTicket,
  );

  final reservationRepository = ReservationRepositoryImpl(
    authClient,
    userLocalSource,
    mappers.reservationResponseToReservation,
  );

  final favoritesRepository = FavoritesRepositoryImpl(
    authClient,
    mappers.movieResponseToMovie,
  );

  runApp(
    Providers(
      providers: [
        Provider<AuthClient>(value: authClient),
        Provider<UserRepository>(value: userRepository),
        Provider<MovieRepository>(value: movieRepository),
        Provider<CityRepository>(value: cityRepository),
        Provider<CommentRepository>(value: commentRepository),
        Provider<TicketRepository>(value: ticketRepository),
        Provider<ReservationRepository>(value: reservationRepository),
        Provider<FavoritesRepository>(value: favoritesRepository),
      ],
      child: MyApp(),
    ),
  );
}

class NotificationId {
  NotificationId._();

  var _id = 0;

  int get id => _id++;

  static final shared = NotificationId._();
}

Future<void> onMessage(Map<String, dynamic> message) async {
  try {
    print('>>>>>>>>>>> onMessage: $message');

    final notification = message['notification'] as Map;
    final data = message['data'] as Map;
    if (notification == null && data == null) {
      return;
    }

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'com.hoc.datn',
      'com.hoc.datn.channel',
      'Enjoy movie notification channel',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      autoCancel: true,
      enableVibration: true,
      playSound: true,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await FlutterLocalNotificationsPlugin().show(
      NotificationId.shared.id,
      notification['title'] ?? data['title'] ?? '',
      notification['body'] ?? data['body'] ?? '',
      platformChannelSpecifics,
      payload: jsonEncode(data),
    );
  } catch (e, s) {
    print(e);
    print(s);
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
