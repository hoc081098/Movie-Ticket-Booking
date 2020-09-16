import 'package:datn/data/local/user_local_source_impl.dart';
import 'package:datn/data/remote/auth_client.dart';
import 'package:datn/data/repository/user_repository_impl.dart';
import 'package:datn/domain/repository/user_repository.dart';
import 'package:datn/env_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:http/http.dart' as http;
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final envManager = EnvManager();
  await envManager.config();

  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  final preferences = RxSharedPreferences.getInstance();
  final userLocalSource = UserLocalSourceImpl(preferences);
  final client = http.Client();

  const httpTimeout = Duration(seconds: 10);
  final normalClient = NormalClient(client, httpTimeout);
  final authClient = AuthClient(client, userLocalSource, auth, httpTimeout);

  final userRepository = UserRepositoryImpl(
    auth,
    userLocalSource,
    authClient,
    normalClient,
    userResponseToUserLocal,
    storage,
  );

  runApp(
    Providers(
      providers: [
        Provider<UserRepository>(value: userRepository),
      ],
      child: MyApp(),
    ),
  );
}
