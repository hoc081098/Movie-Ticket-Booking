const baseUrl = 'localhost:3000';

Uri buildUrl(String unencodedPath, [Map<String, String> queryParameters]) =>
    Uri.http(
      baseUrl,
      unencodedPath,
      queryParameters,
    );
