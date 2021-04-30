import 'dart:async';
import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../../utils/utils.dart';
import '../serializers.dart';
import 'search_keyword_source.dart';

class SearchKeywordSourceImpl implements SearchKeywordSource {
  static const _queriesKey = 'com.hoc.datn.queries';
  static const _maxLength = 16;

  final RxSharedPreferences _prefs;

  SearchKeywordSourceImpl(this._prefs);

  static BuiltList<String> _appendQueryWithMaxLength(
    BuiltList<String>? current,
    String query,
  ) {
    final newList = [query, ...?current].distinct().toList();
    if (newList.length > _maxLength) {
      newList.removeAt(0);
    }
    return newList.build();
  }

  @override
  Future<void> saveSearchQuery(String query) =>
      _prefs.executeUpdate<BuiltList<String>>(
        _queriesKey,
        _decoder,
        (current) => _appendQueryWithMaxLength(current, query),
        _encoder,
      );

  @override
  Future<BuiltList<String>> getQueries() => _prefs
      .read<BuiltList<String>>(_queriesKey, _decoder)
      .then((v) => v ?? _empty);

  @override
  Future<void> clear() =>
      _prefs.write<BuiltList<String>>(_queriesKey, _empty, _encoder);
}

final _empty = const <String>[].build();
const _type = FullType(BuiltList, [FullType(String)]);

final Func1<Object?, BuiltList<String>?> _decoder = (s) => s is String
    ? serializers.deserialize(jsonDecode(s), specifiedType: _type)
        as BuiltList<String>
    : null;

final Func1<BuiltList<String>?, Object?> _encoder = (list) => list == null
    ? null
    : jsonEncode(serializers.serialize(list, specifiedType: _type));
