import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import '../../../domain/model/movie.dart';
import '../../../utils/utils.dart';

part 'view_all_state.g.dart';

abstract class ViewAllState
    implements Built<ViewAllState, ViewAllStateBuilder> {
  int get page;

  BuiltList<Movie> get items;

  bool get isLoading;

  Object? get error;

  bool get loadedAll;

  bool get isFirstPage => page == 0;

  bool get canLoadNextPage =>
      !isLoading && error == null && items.isNotEmpty && page > 0 && !loadedAll;

  bool get canRetry => !isLoading && error != null;

  factory ViewAllState.initial() => ViewAllState(
        (b) => b
          ..page = 0
          ..isLoading = false
          ..loadedAll = false,
      );

  ViewAllState._();

  factory ViewAllState([void Function(ViewAllStateBuilder) updates]) =
      _$ViewAllState;
}

abstract class ViewAllAction {
  ViewAllState reduce(ViewAllState state);
}

mixin _NotChangeStateAction implements ViewAllAction {
  @override
  ViewAllState reduce(ViewAllState state) => state;
}

//
// User's input actions
//

class LoadFirstPageAction with _NotChangeStateAction {
  const LoadFirstPageAction();
}

class LoadNextPageAction with _NotChangeStateAction {
  const LoadNextPageAction();
}

class RetryAction with _NotChangeStateAction {
  const RetryAction();
}

class RefreshAction with _NotChangeStateAction {
  final _completer = Completer<void>();

  Future<void> get completed => _completer.future;

  void complete() => _completer.complete();
}

//
// Side effect actions
//

class LoadingAction implements ViewAllAction {
  final int nextPage;

  LoadingAction(this.nextPage);

  @override
  ViewAllState reduce(ViewAllState state) {
    if (nextPage == 1) {
      return state.rebuild((b) => b
        ..page = 0
        ..isLoading = true
        ..error = null
        ..items = ListBuilder<Movie>());
    } else {
      return state.rebuild((b) => b
        ..isLoading = true
        ..error = null);
    }
  }
}

class SuccessAction implements ViewAllAction {
  final BuiltList<Movie> items;

  SuccessAction(this.items);

  @override
  ViewAllState reduce(ViewAllState state) {
    return state.rebuild(
      (b) {
        final listBuilder = b.items
          ..update((ib) {
            if (state.isFirstPage) {
              ib.safeReplace(items);
            } else {
              final urls = Set.of(state.items.map((item) => item.id));
              final distinctItems = items.where((item) => urls.add(item.id));
              ib.addAll(distinctItems);
            }
          });

        return b
          ..page = state.page + (items.isEmpty ? 0 : 1)
          ..items = listBuilder
          ..error = null
          ..isLoading = false
          ..loadedAll = items.isEmpty;
      },
    );
  }

  @override
  String toString() =>
      (newBuiltValueToStringHelper('SuccessAction')..add('items', items))
          .toString();
}

class FailureAction implements ViewAllAction {
  final Object error;

  FailureAction(this.error);

  @override
  ViewAllState reduce(ViewAllState state) {
    return state.rebuild(
      (b) => b
        ..error = error
        ..isLoading = false,
    );
  }
}

class RefreshSuccessAction implements ViewAllAction {
  final BuiltList<Movie> items;

  RefreshSuccessAction(this.items);

  @override
  ViewAllState reduce(ViewAllState state) {
    return state.rebuild(
      (b) {
        final listBuilder = b.items..safeReplace(items);

        return b
          ..page = 1
          ..items = listBuilder
          ..error = null
          ..isLoading = false
          ..loadedAll = items.isEmpty;
      },
    );
  }
}

class RefreshFailureAction with _NotChangeStateAction {
  final Object error;

  RefreshFailureAction(this.error);
}
