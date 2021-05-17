import 'package:built_collection/built_collection.dart';
import 'package:rx_redux/rx_redux.dart';
import 'package:rxdart/rxdart.dart' hide Notification;

import '../../domain/model/notification.dart';
import 'action.dart';
import 'state.dart';

typedef GetNotifications = Stream<BuiltList<Notification>> Function({
  required int page,
  required int perPage,
});

const perPage = 16;

RxReduxStore<Action, State> createStore(
  GetNotifications getNotifications,
) =>
    RxReduxStore(
      initialState: State.initial(),
      sideEffects: SideEffects(getNotifications)(),
      reducer: (state, action) => action.reduce(state),
      // logger: rxReduxDefaultLogger,
    );

class SideEffects {
  final GetNotifications getNotifications;

  SideEffects(this.getNotifications);

  List<SideEffect<Action, State>> call() => [
        firstPage,
        nextPage,
        retry,
        refresh,
      ];

  Stream<Action> refresh(
    Stream<Action> actions,
    GetState<State> getState,
  ) =>
      actions.whereType<RefreshAction>().exhaustMap((value) => _refresh(value));

  Stream<Action> firstPage(
    Stream<Action> actions,
    GetState<State> getState,
  ) =>
      actions
          .whereType<LoadFirstPageAction>()
          .take(1)
          .exhaustMap((_) => _nextPage(1));

  Stream<Action> nextPage(
    Stream<Action> actions,
    GetState<State> getState,
  ) {
    return actions
        .whereType<LoadNextPageAction>()
        .map((_) => getState())
        .where((state) => state.canLoadNextPage)
        .exhaustMap((state) => _nextPage(state.page + 1));
  }

  Stream<Action> retry(
    Stream<Action> actions,
    GetState<State> getState,
  ) {
    return actions
        .whereType<RetryAction>()
        .map((_) => getState())
        .where((state) => state.canRetry)
        .exhaustMap((state) => _nextPage(state.page + 1));
  }

  Stream<Action> _nextPage(int nextPage) {
    final loadingAction = LoadingAction(nextPage);

    return getNotifications(page: nextPage, perPage: perPage)
        .map<Action>((items) => SuccessAction(items))
        .startWith(loadingAction)
        .onErrorReturnWith((error, s) => FailureAction(error));
  }

  Stream<Action> _refresh(RefreshAction action) =>
      getNotifications(page: 1, perPage: perPage)
          .map<Action>((items) => RefreshSuccessAction(items))
          .onErrorReturnWith((error, s) => RefreshFailureAction(error))
          .doOnCancel(action.complete);
}
