import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/remote/response/error_response.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/manager_repository.dart';
import '../../utils/utils.dart';
import 'manage_user_state.dart';

class ManagerUsersBloc extends DisposeCallbackBaseBloc {
  /// Input functions
  final Function1<int, void> loadUsers;
  final Function1<MapEntry<User, DestroyUserType>, void> destroyUser;

  /// Streams
  final Stream<ManageUserState> renderListStream$;
  final Stream<Map<String, DestroyUserType>> renderItemRemove$;
  final Stream<String> showSnackBar$;

  ManagerUsersBloc._({
    @required Function0<void> dispose,
    @required this.loadUsers,
    @required this.destroyUser,
    @required this.renderListStream$,
    @required this.renderItemRemove$,
    @required this.showSnackBar$,
  }) : super(dispose);

  factory ManagerUsersBloc(final ManagerRepository managerRepository) {
    assert(managerRepository != null);
    final getUsersController = BehaviorSubject<int>();
    final removeUserController =
        PublishSubject<MapEntry<User, DestroyUserType>>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);
    final removingUserIds =
        BehaviorSubject<Map<String, DestroyUserType>>.seeded({});
    final showSnackBarController = PublishSubject<String>();

    final controllers = [
      getUsersController,
      removeUserController,
      isLoadingController,
      removingUserIds
    ];

    final removeUserStream = removeUserController.stream
        .where((entry) => !removingUserIds.value.containsKey(entry.key.uid))
        .flatMap(
          (entry) => Rx.defer(
            () async* {
              try {
                final user = entry.key;
                final type = entry.value;
                switch (type) {
                  case DestroyUserType.REMOVE:
                    {
                      removingUserIds.add(removingUserIds.value
                        ..addAll({user.uid: DestroyUserType.REMOVE}));
                      yield await managerRepository.deleteUser(user);
                      showSnackBarController
                          .add('Remove user id ${user.uid} success');
                      break;
                    }
                  case DestroyUserType.BLOCK:
                    {
                      removingUserIds.add(removingUserIds.value
                        ..addAll({user.uid: DestroyUserType.BLOCK}));
                      yield await managerRepository.blockUser(user);
                      showSnackBarController
                          .add('Block user id ${user.uid} success');
                      break;
                    }
                  case DestroyUserType.UNBLOCK:
                    {
                      removingUserIds.add(removingUserIds.value
                        ..addAll({user.uid: DestroyUserType.UNBLOCK}));
                      yield await managerRepository.unblockUser(user);
                      showSnackBarController
                          .add('Unblock user id ${user.uid} success');
                      break;
                    }
                  case DestroyUserType.CHANGE_ROLE:
                    {
                      removingUserIds.add(removingUserIds.value
                        ..addAll({user.uid: DestroyUserType.CHANGE_ROLE}));
                      yield await managerRepository.changeRoleUser(user);
                      showSnackBarController
                          .add('Change role user id ${user.uid} success');
                      break;
                    }
                }
              } on SingleMessageErrorResponse catch (e) {
                showSnackBarController.add(e.message);
                removingUserIds
                    .add(removingUserIds.value..remove(entry.key.uid));
              }
            },
          ).map((user) => MapEntry(user, entry.value)).doOnData((data) =>
              removingUserIds.add(removingUserIds.value..remove(data.key.uid))),
        );

    final renderListStream = Rx.merge<ManageUserState>([
      getUsersController.stream
          .where((_) => isLoadingController.value == false)
          .flatMap((currentLength) => Rx.defer(
                () async* {
                  isLoadingController.add(true);
                  final page = currentLength ~/ 10 + 1;
                  final result = await managerRepository.loadUser(page);
                  yield result;
                  isLoadingController.add(false);
                },
              ).doOnError((e, s) => isLoadingController.add(false)))
          .map((users) => LoadUserSuccess(users: users)),
      isLoadingController.stream
          .where((event) => event)
          .map((_) => LoadingUsersState()),
      removeUserStream.map((entry) => entry.value == DestroyUserType.REMOVE
          ? DeleteUserSuccess(idUserDelete: entry.key.uid)
          : entry.value == DestroyUserType.BLOCK
              ? BlockUserSuccess(user: entry.key)
              : entry.value == DestroyUserType.UNBLOCK
                  ? UnblockUserSuccess(user: entry.key)
                  : ChangeRoleSuccess(user: entry.key))
    ]).publish();

    final subscriptions = [renderListStream.connect()];

    return ManagerUsersBloc._(
        dispose: DisposeBag([...controllers, ...subscriptions]).dispose,
        loadUsers: getUsersController.add,
        destroyUser: removeUserController.add,
        renderListStream$: renderListStream,
        renderItemRemove$: removingUserIds,
        showSnackBar$: showSnackBarController.stream);
  }
}
