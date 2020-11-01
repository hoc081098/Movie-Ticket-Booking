import 'package:meta/meta.dart';

import 'age_type.dart';
import 'category.dart';
import 'person.dart';

class Movie {
  final String id;

  final bool isActive;

  final String title;

  final String trailerVideoUrl;

  final String posterUrl;

  final String overview;

  final DateTime releasedDate;

  final int duration;

  final String originalLanguage;

  final DateTime createdAt;

  final DateTime updatedAt;

  final AgeType ageType;

  final List<Person> actors;

  final List<Person> directors;

  final List<Category> categories;

  final double rateStar;

  final int totalFavorite;

  final int totalRate;

  Movie({
    @required this.id,
    @required this.isActive,
    @required this.title,
    @required this.trailerVideoUrl,
    @required this.posterUrl,
    @required this.overview,
    @required this.releasedDate,
    @required this.duration,
    @required this.originalLanguage,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.ageType,
    @required this.actors,
    @required this.directors,
    @required this.categories,
    @required this.rateStar,
    @required this.totalFavorite,
    @required this.totalRate,
  });
}
