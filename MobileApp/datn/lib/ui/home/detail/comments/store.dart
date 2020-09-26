import 'package:meta/meta.dart';
import 'package:rx_redux/rx_redux.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/model/comments.dart';
import 'action.dart';
import 'state.dart';

typedef GetComments = Stream<Comments> Function({
  @required int page,
  @required int perPage,
});

const perPage = 32;

RxReduxStore<Action, State> createStore(GetComments getComments) =>
    RxReduxStore(
      initialState: State.initial(),
      sideEffects: HomeSideEffects(getComments)(),
      reducer: (state, action) => action.reduce(state),
      // logger: rxReduxDefaultLogger,
    );

class HomeSideEffects {
  final GetComments getComments;

  HomeSideEffects(this.getComments);

  List<SideEffect<Action, State>> call() => [
        firstPage,
        nextPage,
        retry,
      ];

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

    return getComments(page: nextPage, perPage: perPage)
        .map<Action>((comments) => SuccessAction(comments))
        .startWith(loadingAction)
        .onErrorReturnWith((error) => FailureAction(error));
  }
}
