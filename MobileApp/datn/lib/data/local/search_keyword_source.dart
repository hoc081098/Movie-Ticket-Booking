import 'package:built_collection/built_collection.dart';

abstract class SearchKeywordSource {
  Future<void> saveSearchQuery(String query);

  Future<BuiltList<String>> getQueries();

  Future<void> clear();
}
