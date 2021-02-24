import 'dart:convert';

// ignore_for_file: prefer_single_quotes

class PersonResponse {
  PersonResponse({
    this.isActive,
    this.id,
    this.avatar,
    this.fullName,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final bool isActive;
  final String id;
  final String avatar;
  final String fullName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  factory PersonResponse.fromRawJson(String str) =>
      PersonResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonResponse.fromJson(Map<String, dynamic> json) => PersonResponse(
        isActive: json["is_active"],
        id: json["_id"],
        avatar: json["avatar"],
        fullName: json["full_name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "is_active": isActive,
        "_id": id,
        "avatar": avatar,
        "full_name": fullName,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
