import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import '../../../domain/model/reservation.dart';
import '../../../utils/utils.dart';

part 'reservations_state.g.dart';

abstract class ReservationsState
    implements Built<ReservationsState, ReservationsStateBuilder> {
  int get page;

  BuiltList<Reservation> get items;

  bool get isLoading;

  Object? get error;

  bool get loadedAll;

  bool get isFirstPage => page == 0;

  bool get canLoadNextPage =>
      !isLoading && error == null && items.isNotEmpty && page > 0;

  bool get canRetry => !isLoading && error != null;

  ReservationsState._();

  factory ReservationsState([void Function(ReservationsStateBuilder) updates]) =
      _$ReservationsState;

  factory ReservationsState.initial() => ReservationsState(
        (b) => b
          ..page = 0
          ..isLoading = false
          ..loadedAll = false,
      );
}

abstract class ReservationsAction {
  ReservationsState reduce(ReservationsState state);
}

//
// User's input actions
//

class LoadFirstPageAction implements ReservationsAction {
  const LoadFirstPageAction();

  @override
  ReservationsState reduce(ReservationsState state) => state;
}

class LoadNextPageAction implements ReservationsAction {
  const LoadNextPageAction();

  @override
  ReservationsState reduce(ReservationsState state) => state;
}

class RetryAction implements ReservationsAction {
  const RetryAction();

  @override
  ReservationsState reduce(ReservationsState state) => state;
}

class RefreshAction implements ReservationsAction {
  final Completer<void> completer;

  RefreshAction(this.completer);

  @override
  ReservationsState reduce(ReservationsState state) => state;
}

//
// Side effect actions
//

class LoadingAction implements ReservationsAction {
  final int nextPage;

  LoadingAction(this.nextPage);

  @override
  ReservationsState reduce(ReservationsState state) {
    if (nextPage == 1) {
      return state.rebuild((b) => b
        ..page = 0
        ..isLoading = true
        ..error = null
        ..items = ListBuilder<Reservation>());
    } else {
      return state.rebuild((b) => b
        ..isLoading = true
        ..error = null);
    }
  }
}

class SuccessAction implements ReservationsAction {
  final BuiltList<Reservation> reservations;

  SuccessAction(this.reservations);

  @override
  ReservationsState reduce(ReservationsState state) {
    return state.rebuild(
      (b) {
        final listBuilder = b.items
          ..update((ib) {
            if (state.isFirstPage) {
              ib.safeReplace(reservations);
            } else {
              final urls = Set.of(state.items.map((item) => item.id));
              final distinctItems =
                  reservations.where((item) => urls.add(item.id));
              ib.addAll(distinctItems);
            }
          });

        return b
          ..page = state.page + (reservations.isEmpty ? 0 : 1)
          ..items = listBuilder
          ..error = null
          ..isLoading = false
          ..loadedAll = reservations.isEmpty;
      },
    );
  }
}

class FailureAction implements ReservationsAction {
  final Object error;

  FailureAction(this.error);

  @override
  ReservationsState reduce(ReservationsState state) {
    return state.rebuild(
      (b) => b
        ..error = error
        ..isLoading = false,
    );
  }
}

class RefreshSuccessAction implements ReservationsAction {
  final BuiltList<Reservation> reservations;

  RefreshSuccessAction(this.reservations);

  @override
  ReservationsState reduce(ReservationsState state) {
    return state.rebuild(
      (b) {
        final listBuilder = b.items..safeReplace(reservations);

        return b
          ..page = 1
          ..items = listBuilder
          ..error = null
          ..isLoading = false
          ..loadedAll = reservations.isEmpty;
      },
    );
  }
}

class RefreshFailureAction implements ReservationsAction {
  final Object error;

  RefreshFailureAction(this.error);

  @override
  ReservationsState reduce(ReservationsState state) => state;
}
