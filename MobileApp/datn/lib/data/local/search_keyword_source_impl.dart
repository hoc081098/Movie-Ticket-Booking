import 'dart:async';
import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:tuple/tuple.dart';

import '../../utils/iterable.dart';
import '../serializers.dart';
import 'search_keyword_source.dart';

class SearchKeywordSourceImpl implements SearchKeywordSource {
  static const _queriesKey = 'com.hoc.datn.queries';
  static const _maxLength = 16;

  final RxSharedPreferences _prefs;
  final queryS = PublishSubject<Tuple2<String, Completer<void>>>(sync: true);

  SearchKeywordSourceImpl(this._prefs) {
    queryS.asyncExpand(_saveQuery).debug(identifier: toString()).collect();
  }

  Stream<dynamic> _saveQuery(Tuple2<String, Completer<void>> tuple2) async* {
    final query = tuple2.item1;
    final completer = tuple2.item2;

    try {
      BuiltList<String> list;
      if (query != null) {
        final current = await _prefs.getStringsBuildList(_queriesKey);

        final newList = [query, ...current].distinct().toList();
        if (newList.length > _maxLength) {
          newList.removeAt(0);
        }

        list = newList.build();
      } else {
        list = const <String>[].build();
      }

      await _prefs.setStringsBuildList(_queriesKey, list);
      yield Tuple2(query, list);

      completer.complete();
    } catch (e, s) {
      completer.completeError(e, s);
    }
  }

  @override
  Future<void> saveSearchQuery(String query) {
    final completer = Completer<void>();
    queryS.add(Tuple2(query, completer));
    return completer.future;
  }

  @override
  Future<BuiltList<String>> getQueries() =>
      _prefs.getStringsBuildList(_queriesKey);

  @override
  Future<void> clear() {
    final completer = Completer<void>();
    queryS.add(Tuple2(null, completer));
    return completer.future;
  }
}

extension on RxSharedPreferences {
  static const _type = FullType(BuiltList, [FullType(String)]);

  /// Returns empty list if does not exists.
  Future<BuiltList<String>> getStringsBuildList(String key) =>
      read<BuiltList<String>>(
        key,
        (s) => serializers.deserialize(
          jsonDecode(s ?? '[]'),
          specifiedType: _type,
        ) as BuiltList<String>,
      );

  /// [strings] is not null.
  Future<void> setStringsBuildList(String key, BuiltList<String> strings) {
    assert(strings != null);
    return write<BuiltList<String>>(
      key,
      strings,
      (l) => jsonEncode(
        serializers.serialize(
          l,
          specifiedType: _type,
        ),
      ),
    );
  }
}
