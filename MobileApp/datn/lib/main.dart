import 'package:datn/data/local/user_local_source_impl.dart';
import 'package:datn/data/remote/auth_client.dart';
import 'package:datn/data/repository/user_repository_impl.dart';
import 'package:datn/domain/repository/user_repository.dart';
import 'package:datn/env_manager.dart';
import 'package:datn/utils/type_defs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import 'app.dart';
import 'data/mappers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //
  // Env
  //
  final envManager = EnvManager();
  await envManager.config();

  //
  // Firebase, Google
  //
  await Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final googleSignIn = GoogleSignIn();

  //
  // Local and remote
  //
  final preferences = RxSharedPreferences.getInstance();
  final userLocalSource = UserLocalSourceImpl(preferences);

  final client = http.Client();
  const httpTimeout = Duration(seconds: 15);

  final normalClient = NormalClient(client, httpTimeout);

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
    normalClient,
    userResponseToUserLocal,
    storage,
    userLocalToUserDomain,
    googleSignIn,
  );
  _onSignOut = userRepository.logout;

  runApp(
    Providers(
      providers: [
        Provider<UserRepository>(value: userRepository),
      ],
      child: MyApp(),
    ),
  );
}
