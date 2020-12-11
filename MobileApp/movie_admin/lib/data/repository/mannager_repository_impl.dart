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
      final usersRes = await _authClient.getBody(
              buildUrl('admin_users/', {'page': '$page', 'per_page': '10'}))
          as List;
      return usersRes
          .map((json) => userResponseToUserDomain(UserResponse.fromJson(json)))
          .toList();
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedManagerUserException();
      }
      rethrow;
    }
  }

  @override
  Future<User> deleteUser(User user) async {
    try {
      final url = buildUrl('admin_users/${user.uid}');
      final userRes = await _authClient.deleteBody(url);
      return userResponseToUserDomain(UserResponse.fromJson(userRes));
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedManagerUserException();
      }
      rethrow;
    }
  }

  @override
  Future<User> blockUser(User user) async {
    try {
      final url = buildUrl('admin_users/block/${user.uid}');
      final userRes = await _authClient.putBody(url);
      return userResponseToUserDomain(UserResponse.fromJson(userRes));
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedManagerUserException();
      }
      rethrow;
    }
  }

  @override
  Future<User> changeRoleUser(User user, String theatre_id) async {
    if (user.role == Role.USER) {
      ArgumentError.checkNotNull(theatre_id);
    }

    try {
      final path = user.role == Role.USER ? 'to_staff_role' : 'to_user_role';
      final url = buildUrl('admin_users/$path/${user.uid}');
      final userRes = await _authClient.putBody(
        url,
        body: user.role == Role.USER ? {'theatre_id': theatre_id} : null,
      );
      if (userRes == null) return Future.error(null);
      return userResponseToUserDomain(UserResponse.fromJson(userRes));
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedManagerUserException();
      }
      rethrow;
    }
  }

  @override
  Future<User> unblockUser(User user) async {
    try {
      final url = buildUrl('admin_users/unblock/${user.uid}');
      final userRes = await _authClient.putBody(url);
      return userResponseToUserDomain(UserResponse.fromJson(userRes));
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedManagerUserException();
      }
      rethrow;
    }
  }
}
