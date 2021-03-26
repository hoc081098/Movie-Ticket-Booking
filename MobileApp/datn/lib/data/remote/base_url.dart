import '../../env_manager.dart';

Uri buildUrl(String unencodedPath, [Map<String, String>? queryParameters]) =>
    Uri.http(
      EnvManager.shared.get(EnvKey.BASE_URL),
      unencodedPath,
      queryParameters,
    );
