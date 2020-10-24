import 'dart:io';

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
  Future<List<User>> loadUser(int page) async {
    try {
      final usersRes = await _authClient
          .getBody(buildUrl('users/', {'page': '$page', 'per_page': '10'})) as List;
      print('##### log' + usersRes.length.toString());
      return usersRes
          .map((json) => userResponseToUserDomain(UserResponse.fromJson(json)))
          .toList();
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedLoginException();
      }
      rethrow;
    }
  }

  @override
  Future<bool> deleteUser(User user) async {
    try {
      final url = buildUrl('users/', {'uid': user.uid});
      final userRes = await _authClient.delete(url);
      return userRes.body.isEmpty;
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedLoginException();
      }
      rethrow;
    }
  }
}
