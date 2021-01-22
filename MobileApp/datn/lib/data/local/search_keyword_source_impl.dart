import 'dart:async';
import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:tuple/tuple.dart';

import '../../utils/iterable.dart';
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
      if (query != null) {
        final s = (await _prefs.getString(_queriesKey)) ?? '[]';
        final newList = [query, ...(jsonDecode(s) as List)].distinct().toList();

        if (newList.length > _maxLength) {
          newList.removeAt(0);
        }

        await _prefs.setString(_queriesKey, jsonEncode(newList));
        yield Tuple2(query, newList);
      } else {
        await _prefs.setString(_queriesKey, '[]');
        yield Tuple2(query, []);
      }

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
  Future<BuiltList<String>> getQueries() async {
    final s = (await _prefs.getString(_queriesKey)) ?? '[]';
    final queries = List<String>.from(jsonDecode(s) as List);
    return queries.build();
  }

  @override
  Future<void> clear() {
    final completer = Completer<void>();
    queryS.add(Tuple2(null, completer));
    return completer.future;
  }
}
