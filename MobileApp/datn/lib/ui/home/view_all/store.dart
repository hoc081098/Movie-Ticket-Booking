import 'package:built_collection/built_collection.dart';
import 'package:rx_redux/rx_redux.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../../../domain/model/movie.dart';
import '../../../utils/utils.dart';
import 'view_all_state.dart';

typedef GetMovies = Stream<BuiltList<Movie>> Function({
  required int page,
  required int perPage,
});

const perPage = 32;

RxReduxStore<ViewAllAction, ViewAllState> createStore(
  GetMovies getMovies,
) =>
    RxReduxStore(
      initialState: ViewAllState.initial(),
      sideEffects: SideEffects(getMovies)(),
      reducer: (state, action) => action.reduce(state),
      // logger: rxReduxDefaultLogger,
    );

class SideEffects {
  final GetMovies getMovies;

  SideEffects(this.getMovies);

  List<SideEffect<ViewAllAction, ViewAllState>> call() => [
        firstPage,
        nextPage,
        retry,
        refresh,
      ];

  Stream<ViewAllAction> firstPage(
    Stream<ViewAllAction> actions,
    GetState<ViewAllState> getState,
  ) =>
      actions
          .whereType<LoadFirstPageAction>()
          .take(1)
          .exhaustMap((_) => _nextPage(1));

  Stream<ViewAllAction> nextPage(
    Stream<ViewAllAction> actions,
    GetState<ViewAllState> getState,
  ) {
    return actions
        .whereType<LoadNextPageAction>()
        .map((_) => getState())
        .where((state) => state.canLoadNextPage)
        .exhaustMap((state) => _nextPage(state.page + 1));
  }

  Stream<ViewAllAction> retry(
    Stream<ViewAllAction> actions,
    GetState<ViewAllState> getState,
  ) {
    return actions
        .whereType<RetryAction>()
        .map((_) => getState())
        .where((state) => state.canRetry)
        .exhaustMap((state) => _nextPage(state.page + 1));
  }

  Stream<ViewAllAction> refresh(
    Stream<ViewAllAction> actions,
    GetState<ViewAllState> getState,
  ) =>
      actions.whereType<RefreshAction>().exhaustMap(_refresh);

  Stream<ViewAllAction> _nextPage(int nextPage) {
    final loadingAction = LoadingAction(nextPage);

    return getMovies(page: nextPage, perPage: perPage)
        .map<ViewAllAction>((items) => SuccessAction(items))
        .startWith(loadingAction)
        .debug(identifier: toString(), log: streamDebugPrint)
        .onErrorReturnWith((error, s) => FailureAction(error));
  }

  Stream<ViewAllAction> _refresh(RefreshAction action) =>
      getMovies(page: 1, perPage: perPage)
          .map<ViewAllAction>((items) => RefreshSuccessAction(items))
          .onErrorReturnWith((error, s) => RefreshFailureAction(error))
          .debug(identifier: toString(), log: streamDebugPrint)
          .doOnCancel(action.complete);
}
