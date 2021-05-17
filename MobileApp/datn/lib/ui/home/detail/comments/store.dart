import 'package:rx_redux/rx_redux.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/model/comments.dart';
import 'action.dart';
import 'state.dart';

typedef GetComments = Stream<Comments> Function({
  required int page,
  required int perPage,
});

typedef RemoveCommentById = Stream<void> Function(String);

const perPage = 32;

RxReduxStore<Action, State> createStore(
  GetComments getComments,
  RemoveCommentById removeCommentById,
) =>
    RxReduxStore(
      initialState: State.initial(),
      sideEffects: HomeSideEffects(getComments, removeCommentById)(),
      reducer: (state, action) => action.reduce(state),
      // logger: rxReduxDefaultLogger,
    );

class HomeSideEffects {
  final GetComments getComments;
  final RemoveCommentById removeCommentById;

  HomeSideEffects(this.getComments, this.removeCommentById);

  List<SideEffect<Action, State>> call() => [
        firstPage,
        nextPage,
        retry,
        remove,
      ];

  Stream<Action> remove(
    Stream<Action> actions,
    GetState<State> getState,
  ) {
    return actions
        .whereType<RemoveCommentAction>()
        .map((action) => action.item)
        .flatMap(
          (comment) => removeCommentById(comment.id)
              .map<Action>((_) => RemoveCommentSuccess(comment))
              .onErrorReturnWith(
                  (error, s) => RemoveCommentFailure(error, comment)),
        );
  }

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
        .onErrorReturnWith((error, s) => FailureAction(error));
  }
}
