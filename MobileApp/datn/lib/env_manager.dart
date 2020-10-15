import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvKey {
  BASE_URL,
  PLACES_API_KEY,
  WS_URL,
  WS_PATH,
}

enum EnvPath {
  DEV,
  PROD,
}

extension on EnvPath {
  String get fileName {
    switch (this) {
      case EnvPath.DEV:
        return '.env';
      case EnvPath.PROD:
        return '.prod.env';
    }
    throw StateError('Wtf is this?');
  }
}

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

  Future<void> config(EnvPath path) =>
      _dotEnv.load(path.fileName).then((_) => print('[ENV] ${_dotEnv.env}'));

  String get(EnvKey key) => _dotEnv.env[_envKeyNames[key]];

  //
  //

  static EnvManager shared = EnvManager._();

  EnvManager._();
}
