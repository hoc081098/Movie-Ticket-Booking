import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'manage_user_state.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/model/user.dart';
import '../../domain/repository/manager_repository.dart';
import '../../utils/utils.dart';

class ManagerUsersBloc extends DisposeCallbackBaseBloc {
  /// Input functions
  final Function1<int, void> loadUsers;
  final Function1<User, void> removeUser;

  /// Streams
  final Stream<ManageUserState> renderListStream$;
  final Stream<List<String>> renderItemRemove$;

  ManagerUsersBloc._({
    @required Function0<void> dispose,
    @required this.loadUsers,
    @required this.removeUser,
    @required this.renderListStream$,
    @required this.renderItemRemove$,
  }) : super(dispose);

  factory ManagerUsersBloc(final ManagerRepository managerRepository) {
    assert(managerRepository != null);
    final getUsersController = BehaviorSubject<int>();
    final removeUserController = PublishSubject<User>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);
    final removingUserIds = BehaviorSubject<List<String>>.seeded([]);

    final controllers = [
      getUsersController,
      removeUserController,
      isLoadingController,
      removingUserIds
    ];

    final removeUserStream = removeUserController.stream
        .where((user) => !removingUserIds.value.contains(user.uid))
        .flatMap((user) => Rx.defer(() async* {
              removingUserIds.add([...removingUserIds.value, user.uid]);
              final result = await managerRepository.deleteUser(user);
              yield result;
              removingUserIds.add(removingUserIds.value..remove(user.uid));
            }).doOnError(() =>
                removingUserIds.add(removingUserIds.value..remove(user.uid))))
        .share();

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
              ).doOnError(() => isLoadingController.add(false)))
          .map((users) => LoadUserSuccess(users: users)),
      isLoadingController.stream
          .where((event) => event)
          .map((_) => LoadingUsersState()),
      removeUserStream.map((_) => DeleteUserSuccess())
    ]).share();


    final subscriptions = [renderListStream, removeUserStream];

    return ManagerUsersBloc._(
      dispose: DisposeBag([...controllers, ...subscriptions]).dispose,
      loadUsers: getUsersController.add,
      removeUser: removeUserController.add,
      renderListStream$: renderListStream,
      renderItemRemove$: removingUserIds,
    );
  }
}
