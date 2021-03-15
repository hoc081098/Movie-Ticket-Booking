import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;

enum EnvKey {
  BASE_URL,
  PLACES_API_KEY,
  WS_URL,
  WS_PATH,
}

enum EnvMode {
  DEV,
  PROD,
}

extension on EnvMode {
  String get fileName {
    switch (this) {
      case EnvMode.DEV:
        return '.env';
      case EnvMode.PROD:
        return '.prod.env';
    }
  }
}

EnvKey _fromString(s) => EnvKey.values.firstWhere((v) => describeEnum(v) == s);

class EnvManager {
  static final _shared = EnvManager._private();

  final _init = AsyncMemoizer<void>();
  Map<EnvKey, String>? _env;

  // Ensures end-users cannot initialize the class.
  EnvManager._private();

  static EnvManager get shared => _shared;

  static EnvMode mode = kReleaseMode ? EnvMode.PROD : EnvMode.DEV;

  Future<void> init(Map<EnvKey, String> remote) => _init.runOnce(() => dot_env
      .load(fileName: mode.fileName)
      .then((void _) => _mergeAndDebugCheckEnv(remote)));

  void _mergeAndDebugCheckEnv(Map<EnvKey, String> remote) {
    final local =
        dot_env.env.map((key, value) => MapEntry(_fromString(key), value));
    _env = {...local, ...remote};

    if (mode == EnvMode.PROD) {
      return;
    }

    final missingKeysInFile = [
      for (final key in EnvKey.values)
        if (_env![key] == null) key
    ];
    if (missingKeysInFile.isNotEmpty) {
      throw Exception('Missing file keys: $missingKeysInFile');
    }

    final missingKeyInEnum =
        _env!.keys.toSet().difference(EnvKey.values.toSet());
    if (missingKeyInEnum.isNotEmpty) {
      throw Exception('Missing enum keys: $missingKeyInEnum');
    }

    debugPrint('[ENV] Env: $_env');
    debugPrint('[ENV] Init successfully $mode');
  }

  String get(EnvKey key) {
    assert(_init.hasRun, 'Missing call init()');
    assert(_env != null, '_init() failed');

    final value = _env![key];
    assert(value != null, 'Missing key $key');

    return value!;
  }
}
