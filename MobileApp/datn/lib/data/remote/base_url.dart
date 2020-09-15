const baseUrl = '192.168.1.37:3000';

Uri buildUrl(String unencodedPath, [Map<String, String> queryParameters]) =>
    Uri.http(
      baseUrl,
      unencodedPath,
      queryParameters,
    );
