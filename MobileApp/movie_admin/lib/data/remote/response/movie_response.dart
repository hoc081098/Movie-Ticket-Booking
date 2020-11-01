import 'dart:convert';

import 'person_response.dart';

import 'category_response.dart';
// ignore_for_file: prefer_single_quotes

class MovieResponse {
  final bool isActive;
  final String ageType;
  final List<PersonResponse> actors;
  final List<PersonResponse> directors;
  final String id;
  final double rateStar;
  final int totalRate;
  final int totalFavorite;
  final String title;
  final String trailerVideoUrl;
  final String posterUrl;
  final String overview;
  final DateTime releasedDate;
  final int duration;
  final String originalLanguage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final List<CategoryResponse> categories;
  final String movieResponseId;

  MovieResponse({
    this.isActive,
    this.ageType,
    this.actors,
    this.directors,
    this.id,
    this.rateStar,
    this.totalRate,
    this.totalFavorite,
    this.title,
    this.trailerVideoUrl,
    this.posterUrl,
    this.overview,
    this.releasedDate,
    this.duration,
    this.originalLanguage,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.categories,
    this.movieResponseId,
  });

  factory MovieResponse.fromRawJson(String str) =>
      MovieResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
        isActive: json['is_active'],
        ageType: json['age_type'],
        actors: List<PersonResponse>.from(
            json["actors"].map((x) => PersonResponse.fromJson(x))),
        directors: List<PersonResponse>.from(
            json["directors"].map((x) => PersonResponse.fromJson(x))),
        id: json["_id"],
        rateStar: (json["rate_star"] as num).toDouble(),
        totalRate: json["total_rate"],
        totalFavorite: json["total_favorite"],
        title: json["title"],
        trailerVideoUrl: json["trailer_video_url"],
        posterUrl: json["poster_url"],
        overview: json["overview"],
        releasedDate: DateTime.parse(json["released_date"]),
        duration: json['duration'],
        originalLanguage: json['original_language'],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        categories: List<CategoryResponse>.from(
            json["categories"].map((x) => CategoryResponse.fromJson(x))),
        movieResponseId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "is_active": isActive,
        "age_type": ageType,
        "actors": List<dynamic>.from(actors.map((x) => x.toJson())),
        "directors": List<dynamic>.from(directors.map((x) => x.toJson())),
        "_id": id,
        "rate_star": rateStar,
        "total_rate": totalRate,
        "total_favorite": totalFavorite,
        "title": title,
        "trailer_video_url": trailerVideoUrl,
        "poster_url": posterUrl,
        "overview": overview,
        "released_date": releasedDate.toIso8601String(),
        "duration": duration,
        "original_language": originalLanguage,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "id": movieResponseId,
      };
}
