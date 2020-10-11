import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvKey { BASE_URL, PLACES_API_KEY }

class EnvManager {
  final _envKeyNames = Map.fromEntries(
    EnvKey.values.map(
      (e) => MapEntry(
        e,
        e.toString().split('.')[1],
      ),
    ),
  );

  final _dotEnv = DotEnv();

  Future<void> config() => _dotEnv.load();

  String get(EnvKey key) => _dotEnv.env[_envKeyNames[key]];

  //
  //

  static EnvManager shared = EnvManager._();

  EnvManager._();
}
