import 'package:meta/meta.dart';
import '../../domain/model/user.dart';

abstract class ManageUserState {}

class LoadUserSuccess extends ManageUserState {
  final List<User> users;

  LoadUserSuccess._({@required this.users});

  factory LoadUserSuccess({@required List<User> users}) {
    return LoadUserSuccess._(users: users);
  }
}

class LoadingUsersState extends ManageUserState {}

class DeleteUserSuccess extends ManageUserState {}

class DeletingUserState extends ManageUserState {}
