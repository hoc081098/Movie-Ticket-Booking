// To parse this JSON data, do
//
//     final showTimeResponse = showTimeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:movie_admin/data/remote/response/movie_response.dart';

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
    this.v,
  });

  final bool isActive;
  final String id;
  final MovieResponse movie;
  final String theatre;
  final String room;
  final DateTime endTime;
  final DateTime startTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  factory ShowTimeResponse.fromRawJson(String str) => ShowTimeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShowTimeResponse.fromJson(Map<String, dynamic> json) => ShowTimeResponse(
    isActive: json["is_active"],
    id: json["_id"],
    movie: json["movie"],
    theatre: json["theatre"],
    room: json["room"],
    endTime: DateTime.parse(json["end_time"]),
    startTime: DateTime.parse(json["start_time"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "is_active": isActive,
    "_id": id,
    "movie": movie,
    "theatre": theatre,
    "room": room,
    "end_time": endTime.toIso8601String(),
    "start_time": startTime.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
