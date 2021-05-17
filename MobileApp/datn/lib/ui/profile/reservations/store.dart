import 'package:built_collection/built_collection.dart';
import 'package:rx_redux/rx_redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../../../domain/model/reservation.dart';
import '../../../utils/utils.dart';
import 'reservations_state.dart';

typedef GetReservations = Stream<BuiltList<Reservation>> Function({
  required int page,
  required int perPage,
});

const perPage = 6;

RxReduxStore<ReservationsAction, ReservationsState> createStore(
  GetReservations getReservations,
) =>
    RxReduxStore(
      initialState: ReservationsState.initial(),
      sideEffects: SideEffects(getReservations)(),
      reducer: (state, action) => action.reduce(state),
      // logger: rxReduxDefaultLogger,
    );

class SideEffects {
  final GetReservations getReservations;

  SideEffects(this.getReservations);

  List<SideEffect<ReservationsAction, ReservationsState>> call() => [
        firstPage,
        nextPage,
        retry,
        refresh,
      ];

  Stream<ReservationsAction> firstPage(
    Stream<ReservationsAction> actions,
    GetState<ReservationsState> getState,
  ) =>
      actions
          .whereType<LoadFirstPageAction>()
          .take(1)
          .exhaustMap((_) => _nextPage(1));

  Stream<ReservationsAction> nextPage(
    Stream<ReservationsAction> actions,
    GetState<ReservationsState> getState,
  ) {
    return actions
        .whereType<LoadNextPageAction>()
        .map((_) => getState())
        .where((state) => state.canLoadNextPage)
        .exhaustMap((state) => _nextPage(state.page + 1));
  }

  Stream<ReservationsAction> retry(
    Stream<ReservationsAction> actions,
    GetState<ReservationsState> getState,
  ) {
    return actions
        .whereType<RetryAction>()
        .map((_) => getState())
        .where((state) => state.canRetry)
        .exhaustMap((state) => _nextPage(state.page + 1));
  }

  Stream<ReservationsAction> refresh(
    Stream<ReservationsAction> actions,
    GetState<ReservationsState> getState,
  ) =>
      actions.whereType<RefreshAction>().exhaustMap(_refresh);

  Stream<ReservationsAction> _nextPage(int nextPage) {
    final loadingAction = LoadingAction(nextPage);

    return getReservations(page: nextPage, perPage: perPage)
        .map<ReservationsAction>((items) => SuccessAction(items))
        .startWith(loadingAction)
        .debug(identifier: toString(), log: streamDebugPrint)
        .onErrorReturnWith((error, s) => FailureAction(error));
  }

  Stream<ReservationsAction> _refresh(RefreshAction action) =>
      getReservations(page: 1, perPage: perPage)
          .map<ReservationsAction>((items) => RefreshSuccessAction(items))
          .onErrorReturnWith((error, s) => RefreshFailureAction(error))
          .debug(identifier: toString(), log: streamDebugPrint)
          .doOnCancel(() => action.completer.complete());
}
