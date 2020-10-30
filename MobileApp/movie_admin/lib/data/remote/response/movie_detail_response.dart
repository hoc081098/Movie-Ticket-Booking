import 'package:meta/meta.dart';
import 'package:movie_admin/domain/model/age_type.dart';

class MovieDetailResponse {
  final bool is_active;

  final String age_type;

  final List<PersonResponse> actors;

  final List<PersonResponse> directors;

  final String id;

  final String title;

  final String trailer_video_url;

  final String poster_url;

  final String overview;

  final DateTime released_date;

  final int duration;

  final String original_language;

  final DateTime createdAt;

  final DateTime updatedAt;

  final List<CategoryResponse> categories;

  final double rate_star;

  final int total_favorite;

  final int total_rate;

  MovieDetailResponse({
    @required this.is_active,
    @required this.age_type,
    @required this.actors,
    @required this.directors,
    @required this.id,
    @required this.title,
    @required this.trailer_video_url,
    @required this.poster_url,
    @required this.overview,
    @required this.released_date,
    @required this.duration,
    @required this.original_language,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.categories,
    @required this.rate_star,
    @required this.total_favorite,
    @required this.total_rate,
  });

  factory MovieDetailResponse.fromJson(Map map) => MovieDetailResponse(
        is_active: map['is_active'],
        age_type:  map['age_type'],
        actors: map['actors'],
        directors: map['directors'],
        id: map['_id'],
        title: map['title'],
        trailer_video_url: map['trailer_video_url'],
        poster_url: map['poster_url'],
        overview: map['overview'],
        released_date: map['released_date'],
        duration: map['duration'],
        original_language: map['original_language'],
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt'],
        categories: map['categories'],
        rate_star: map['rate_star'],
        total_favorite: map['total_favorite'],
        total_rate: map['total_rate'],
      );
}

class CategoryResponse {
  final String id;

  final String name;

  final DateTime createdAt;

  final DateTime updatedAt;

  final bool is_active;

  CategoryResponse({
    @required this.id,
    @required this.name,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.is_active,
  });
}

class PersonResponse {
  final bool is_active;

  final String id;

  final String avatar;

  final String full_name;

  final DateTime createdAt;

  final DateTime updatedAt;

  PersonResponse({
    @required this.is_active,
    @required this.id,
    @required this.avatar,
    @required this.full_name,
    @required this.createdAt,
    @required this.updatedAt,
  });
}
