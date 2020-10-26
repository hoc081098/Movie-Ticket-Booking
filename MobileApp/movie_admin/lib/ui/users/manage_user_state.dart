import 'package:meta/meta.dart';
import '../../domain/model/user.dart';

abstract class ManageUserState {}

enum DestroyUserType { REMOVE, BLOCK, UNBLOCK, CHANGE_ROLE }

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

  factory DeleteUserSuccess({@required String idUserDelete}) {
    return DeleteUserSuccess._(idUserDelete);
  }
}

class BlockUserSuccess extends ManageUserState {
  final User user;

  BlockUserSuccess._(this.user);

  factory BlockUserSuccess({@required User user}) {
    return BlockUserSuccess._(user);
  }
}

class UnblockUserSuccess extends ManageUserState {
  final User user;

  UnblockUserSuccess._(this.user);

  factory UnblockUserSuccess({@required User user}) {
    return UnblockUserSuccess._(user);
  }
}

class ChangeRoleSuccess extends ManageUserState {
  final User user;

  ChangeRoleSuccess._(this.user);

  factory ChangeRoleSuccess({@required User user}) {
    return ChangeRoleSuccess._(user);
  }
}

class DeletingUserState extends ManageUserState {}
