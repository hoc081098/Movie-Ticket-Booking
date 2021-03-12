import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import '../../../../domain/model/comment.dart';

part 'state.g.dart';

abstract class State implements Built<State, StateBuilder> {
  int get page;

  double get average;

  int get total;

  BuiltList<Comment> get items;

  bool get isLoading;

  Object? get error;

  bool get loadedAll;

  bool get isFirstPage => page == 0;

  bool get canLoadNextPage =>
      !isLoading && error == null && items.isNotEmpty && page > 0 && !loadedAll;

  bool get canRetry => !isLoading && error != null && !loadedAll;

  State._();

  factory State([void Function(StateBuilder) updates]) = _$State;

  factory State.initial() => State(
        (b) => b
          ..page = 0
          ..average = 0
          ..total = 0
          ..isLoading = false
          ..loadedAll = false,
      );
}
