import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';
import 'category_response.dart';
import 'person_response.dart';

part 'movie_detail_response.g.dart';

abstract class MovieDetailResponse
    implements Built<MovieDetailResponse, MovieDetailResponseBuilder> {
  bool? get is_active;

  String get age_type;

  BuiltList<PersonResponse> get actors;

  BuiltList<PersonResponse> get directors;

  @BuiltValueField(wireName: '_id')
  String get id;

  String get title;

  String? get trailer_video_url;

  String? get poster_url;

  String? get overview;

  DateTime get released_date;

  int get duration;

  String get original_language;

  DateTime get createdAt;

  DateTime get updatedAt;

  BuiltList<CategoryResponse> get categories;

  double get rate_star;

  int get total_favorite;

  int get total_rate;

  MovieDetailResponse._();

  factory MovieDetailResponse(
          [void Function(MovieDetailResponseBuilder) updates]) =
      _$MovieDetailResponse;

  static Serializer<MovieDetailResponse> get serializer =>
      _$movieDetailResponseSerializer;

  factory MovieDetailResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<MovieDetailResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
