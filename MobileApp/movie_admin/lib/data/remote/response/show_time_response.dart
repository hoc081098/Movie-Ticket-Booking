// ignore_for_file: prefer_single_quotes

class ShowTimeResponse {
  ShowTimeResponse({
    this.isActive,
    this.id,
    this.movie,
    this.theatre,
    this.room,
    this.endTime,
    this.startTime,
    this.createdAt,
    this.updatedAt,
  });

  final bool isActive;
  final String id;
  final ShowTimeResponse_MovieResponse movie;
  final String theatre;
  final String room;
  final DateTime endTime;
  final DateTime startTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ShowTimeResponse.fromJson(Map<String, dynamic> json) =>
      ShowTimeResponse(
        isActive: json["is_active"],
        id: json["_id"],
        movie: ShowTimeResponse_MovieResponse.fromJson(json["movie"]),
        theatre: json["theatre"],
        room: json["room"],
        endTime: DateTime.parse(json["end_time"]).toLocal(),
        startTime: DateTime.parse(json["start_time"]).toLocal(),
        createdAt: DateTime.parse(json["createdAt"]).toLocal(),
        updatedAt: DateTime.parse(json["updatedAt"]).toLocal(),
      );
}

class ShowTimeResponse_MovieResponse {
  ShowTimeResponse_MovieResponse({
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
  });

  final bool isActive;
  final String ageType;
  final List<String> actors;
  final List<String> directors;
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

  factory ShowTimeResponse_MovieResponse.fromJson(Map<String, dynamic> json) =>
      ShowTimeResponse_MovieResponse(
        isActive: json["is_active"],
        ageType: json["age_type"],
        actors: List<String>.from(json["actors"].map((x) => x)),
        directors: List<String>.from(json["directors"].map((x) => x)),
        id: json["_id"],
        rateStar: (json["rate_star"] as num).toDouble(),
        totalRate: json["total_rate"],
        totalFavorite: json["total_favorite"],
        title: json["title"],
        trailerVideoUrl: json["trailer_video_url"],
        posterUrl: json["poster_url"],
        overview: json["overview"],
        releasedDate: DateTime.parse(json["released_date"]).toLocal(),
        duration: json["duration"],
        originalLanguage: json["original_language"],
        createdAt: DateTime.parse(json["createdAt"]).toLocal(),
        updatedAt: DateTime.parse(json["updatedAt"]).toLocal(),
      );
}
