import 'package:built_value/built_value.dart' show newBuiltValueToStringHelper;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
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
import 'data/repository/movie_repository_impl.dart';
import 'data/repository/user_repository_impl.dart';
import 'domain/repository/city_repository.dart';
import 'domain/repository/comment_repository.dart';
import 'domain/repository/movie_repository.dart';
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
  await EnvManager.shared.config();

  //
  // Firebase, Google, Facebook
  //
  await Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();

  //
  // Local and remote
  //
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

  runApp(
    Providers(
      providers: [
        Provider<UserRepository>(value: userRepository),
        Provider<MovieRepository>(value: movieRepository),
        Provider<CityRepository>(value: cityRepository),
        Provider<CommentRepository>(value: commentRepository),
      ],
      child: MyApp(),
    ),
  );
}
