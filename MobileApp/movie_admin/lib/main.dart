import 'package:disposebag/disposebag.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import './data/repository/movie_repository_impl.dart';
import './data/repository/show_times_repository_impl.dart';
import './data/repository/theatres_repository_impl.dart';
import './data/repository/ticket_repository_impl.dart';
import './domain/repository/movie_repository.dart';
import './domain/repository/show_times_repository.dart';
import './domain/repository/theatres_repository.dart';
import './domain/repository/ticket_repo.dart';
import 'data/local/user_local_source_impl.dart';
import 'data/mappers.dart' as mappers;
import 'data/remote/auth_client.dart';
import 'data/repository/mannager_repository_impl.dart';
import 'data/repository/movie_repository_impl.dart';
import 'data/repository/theatres_repository_impl.dart';
import 'data/repository/user_repository_impl.dart';
import 'domain/repository/manager_repository.dart';
import 'domain/repository/movie_repository.dart';
import 'domain/repository/theatres_repository.dart';
import 'domain/repository/user_repository.dart';
import 'env_manager.dart';
import 'my_app.dart';
import 'utils/type_defs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DisposeBagConfigs.logger = kReleaseMode ? null : disposeBagDefaultLogger;

  //
  // Env
  //
  await EnvManager.shared.config();

  //
  // Firebase, Google, Facebook
  //
  await Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final googleSignIn = GoogleSignIn();

  //
  // Local and remote
  //
  RxSharedPreferencesConfigs.logger =
      kReleaseMode ? null : const RxSharedPreferencesDefaultLogger();
  final preferences = RxSharedPreferences.getInstance();
  final userLocalSource = UserLocalSourceImpl(preferences);

  final client = http.Client();
  const httpTimeout = Duration(seconds: 30);

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
  );
  final managerUsersRepository = ManagerRepositoryImpl(authClient);
  final movieRepository = MovieRepositoryImpl(authClient);
  final theatresRepository = TheatresRepositoryImpl(authClient);

  _onSignOut = userRepository.logout;

  runApp(
    Providers(
      providers: [
        Provider<AuthClient>.value(authClient),
        Provider<UserRepository>.value(userRepository),
        Provider<ManagerRepository>.value(managerUsersRepository),
        Provider<MovieRepository>.value(movieRepository),
        Provider<TheatresRepository>.value(theatresRepository),
        Provider<ShowTimesRepository>.value(
            ShowTimesRepositoryImpl(authClient)),
        Provider<TicketRepository>.value(TicketRepositoryImpl(authClient)),
      ],
      child: MyApp(),
    ),
  );
}

// BASE_URL=datn-081098.herokuapp.com
// WS_URL=datn-081098.herokuapp.com
