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

EnvKey _fromString(s) =>
    EnvKey.values.firstWhere((v) => v.toString().split('.')[1] == s);

class EnvManager {
  final _dotEnv = DotEnv();
  final _map = <EnvKey, String>{};

  Future<void> config(EnvPath path, Map<EnvKey, String> remote) async {
    await _dotEnv.load(path.fileName);
    final local =
        _dotEnv.env.map((key, value) => MapEntry(_fromString(key), value));
    _map.addAll({...local, ...remote});

    print('[ENV_LOCAL] $local');
    print('[FROM_REMOTE] $remote');
    print('[ENV] $_map');
  }

  String get(EnvKey key) => _map[key];

  //
  //

  static EnvManager shared = EnvManager._();

  EnvManager._();
}
