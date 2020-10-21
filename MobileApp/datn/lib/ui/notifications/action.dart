import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

import '../../domain/model/notification.dart';
import 'state.dart';

@sealed
@immutable
abstract class Action {
  State reduce(State state);
}

//
// User's input actions
//

class LoadFirstPageAction implements Action {
  const LoadFirstPageAction();

  @override
  State reduce(State state) => state;
}

class LoadNextPageAction implements Action {
  const LoadNextPageAction();

  @override
  State reduce(State state) => state;
}

class RetryAction implements Action {
  const RetryAction();

  @override
  State reduce(State state) => state;
}

class AddedCommentAction implements Action {
  final Notification notification;

  AddedCommentAction(this.notification);

  @override
  State reduce(State state) =>
      state.rebuild((b) => b..items.insert(0, notification));
}

//
// Side effect actions
//

class LoadingAction implements Action {
  final int nextPage;

  LoadingAction(this.nextPage);

  @override
  State reduce(State state) {
    if (nextPage == 1) {
      return state.rebuild((b) => b
        ..page = 0
        ..isLoading = true
        ..error = null
        ..items = ListBuilder<Notification>());
    } else {
      return state.rebuild((b) => b
        ..isLoading = true
        ..error = null);
    }
  }
}

class SuccessAction implements Action {
  final BuiltList<Notification> notifications;

  SuccessAction(this.notifications);

  @override
  State reduce(State state) {
    return state.rebuild(
      (b) {
        final items = notifications;

        final listBuilder = b.items
          ..update((ib) {
            if (state.isFirstPage) {
              ib.replace(items);
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
}

class FailureAction implements Action {
  final Object error;

  FailureAction(this.error);

  @override
  State reduce(State state) {
    return state.rebuild(
      (b) => b
        ..error = error
        ..isLoading = false,
    );
  }
}
