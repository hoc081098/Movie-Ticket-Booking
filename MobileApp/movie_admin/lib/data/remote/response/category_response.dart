import 'dart:convert';

class CategoryResponse {
  CategoryResponse({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String categoryId;

  factory CategoryResponse.fromRawJson(String str) =>
      CategoryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        id: json['_id'],
        name: json['name'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        categoryId: json['id'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'id': categoryId,
      };
}
