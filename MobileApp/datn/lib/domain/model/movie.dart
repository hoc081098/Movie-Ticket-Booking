import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'category.dart';
import 'person.dart';

part 'movie.g.dart';

enum AgeType {
  P,
  C13,
  C16,
  C18,
}

abstract class Movie implements Built<Movie, MovieBuilder> {
  String get id;

  bool get isActive;

  BuiltList<String> get actorIds;

  BuiltList<String> get directorIds;

  String get title;

  String? get trailerVideoUrl;

  String? get posterUrl;

  String? get overview;

  DateTime get releasedDate;

  int get duration;

  String get originalLanguage;

  DateTime get createdAt;

  DateTime get updatedAt;

  AgeType get ageType;

  BuiltList<Person>? get actors;

  BuiltList<Person>? get directors;

  BuiltList<Category>? get categories;

  double get rateStar;

  int get totalFavorite;

  int get totalRate;

  Movie._();

  factory Movie([void Function(MovieBuilder) updates]) = _$Movie;
}
