import 'package:built_collection/built_collection.dart';

import '../model/category.dart';
import '../model/person.dart';

import '../model/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getListMovie(int page, int perPage);

  Future<List<Category>> getListCategory();

  Future<List<Person>> getListSearchPerson(String name);

  Future<void> uploadMovie(Movie movie);

  Future<String> uploadUrl(String path, [bool isVideo]);

  Future<BuiltList<Movie>> search(String title);
}
