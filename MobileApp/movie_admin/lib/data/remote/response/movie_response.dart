import 'package:meta/meta.dart';

class MovieResponse {
  final String id;

  final bool is_active;

  final List<String> actors;

  final List<String> directors;

  final String title;

  final String trailer_video_url;

  final String poster_url;

  final String overview;

  final DateTime released_date;

  final int duration;

  final String original_language;

  final DateTime createdAt;

  final DateTime updatedAt;

  final String age_type;

  final double rate_star;

  final int total_favorite;

  final int total_rate;

  MovieResponse({
    @required this.id,
    @required this.is_active,
    @required this.actors,
    @required this.directors,
    @required this.title,
    @required this.trailer_video_url,
    @required this.poster_url,
    @required this.overview,
    @required this.released_date,
    @required this.duration,
    @required this.original_language,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.age_type,
    @required this.rate_star,
    @required this.total_favorite,
    @required this.total_rate,
  });
}
