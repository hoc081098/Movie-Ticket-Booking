import 'dart:convert';

import 'package:meta/meta.dart';

class MovieRequest {
  MovieRequest({
    @required this.title,
    @required this.trailerVideoUrl,
    @required this.posterUrl,
    @required this.overview,
    @required this.releasedDate,
    @required this.duration,
    @required this.directorIds,
    @required this.actorIds,
    @required this.originalLanguage,
    @required this.ageType,
    @required this.categoryIds,
  });

  final String title;
  final String trailerVideoUrl;
  final String posterUrl;
  final String overview;
  final String releasedDate;
  final int duration;
  final List<String> directorIds;
  final List<String> actorIds;
  final String originalLanguage;
  final String ageType;
  final List<String> categoryIds;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'title': title,
        'trailer_video_url': trailerVideoUrl,
        'poster_url': posterUrl,
        'overview': overview,
        'released_date': releasedDate,
        'duration': duration,
        'director_ids': directorIds,
        'actor_ids': actorIds,
        'original_language': originalLanguage,
        'age_type': ageType,
        'category_ids': categoryIds,
      };
}
