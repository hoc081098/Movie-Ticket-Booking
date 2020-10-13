import 'dart:html';

import '../../domain/model/exception.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/manager_repository.dart';
import '../mappers.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/error_response.dart';
import '../remote/response/user_response.dart';

class ManagerRepositoryImpl implements ManagerRepository {
  final AuthClient _authClient;

  ManagerRepositoryImpl(this._authClient);

  @override
  Future<List<User>> getAllUser() async {
    try {
      final usersRes = await _authClient.getBody(buildUrl('users')) as List;
      return usersRes
          .map((json) => userResponseToUserDomain(UserResponse.fromJson(json)));
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedLoginException();
      }
      rethrow;
    }
  }
}
