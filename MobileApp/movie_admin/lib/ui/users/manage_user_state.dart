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

class DeleteUserSuccess extends ManageUserState {
  final String idUserDelete;

  DeleteUserSuccess._(this.idUserDelete);

  factory DeleteUserSuccess({@required String idUserDelete}){
    return DeleteUserSuccess._(idUserDelete);
  }
}

class DeletingUserState extends ManageUserState {}
