import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/model/user.dart';
import '../../domain/repository/manager_repository.dart';
import '../../utils/utils.dart';

class ManagerUsersBloc extends DisposeCallbackBaseBloc {
  /// Input functions
  final Function1<int, void> loadUsers;
  final Function1<bool, void> userRemoving;
  final Function1<User, bool> removeUser;

  /// Streams
  final Stream<List<User>> getUsersStream$;
  final Stream<User> removeUserStream$;
  final Stream<bool> isLoading$;
  final Stream<bool> isRemoving$;

  ManagerUsersBloc._(
      {@required Function0<void> dispose,
      @required this.loadUsers,
      @required this.userRemoving,
      @required this.removeUser,
      @required this.getUsersStream$,
      @required this.removeUserStream$,
      @required this.isLoading$,
      @required this.isRemoving$})
      : super(dispose);

  factory ManagerUsersBloc(final ManagerRepository managerRepository) {
    assert(managerRepository != null);
    final getUsersController = BehaviorSubject<int>();
    final removeUserController = PublishSubject<User>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);
    final isRemovingController = BehaviorSubject<bool>.seeded(false);

    final controllers = [
      getUsersController,
      removeUserController,
      isLoadingController,
      isRemovingController
    ];

    final getUsersStream = Rx.combineLatest2(
            getUsersController.stream,
            isLoadingController.stream.where((isLoad) => isLoad == false),
            (number, _) => number)
        .flatMap((numberUser) => Rx.defer(() async* {
              isLoadingController.add(true);
              final result = await managerRepository.getAllUser();
              yield result;
              isLoadingController.add(false);
            }).doOnError(() => isLoadingController.add(false)))
        .share();

    final subscriptions = [getUsersStream];

    return ManagerUsersBloc._(
        dispose: DisposeBag([...controllers, ...subscriptions]).dispose,
        loadUsers: getUsersController.add,
        userRemoving: isRemovingController.add,
        removeUser: null,
        getUsersStream$: getUsersStream,
        removeUserStream$: null,
        isLoading$: isLoadingController.stream,
        isRemoving$: isRemovingController.stream);
  }
}
