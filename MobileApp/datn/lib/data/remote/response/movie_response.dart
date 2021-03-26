import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';

part 'movie_response.g.dart';

abstract class MovieResponse
    implements Built<MovieResponse, MovieResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  bool? get is_active;

  BuiltList<String> get actors;

  BuiltList<String> get directors;

  String get title;

  String? get trailer_video_url;

  String? get poster_url;

  String? get overview;

  DateTime get released_date;

  int get duration;

  String get original_language;

  DateTime get createdAt;

  DateTime get updatedAt;

  String get age_type;

  double get rate_star;

  int get total_favorite;

  int get total_rate;

  MovieResponse._();

  factory MovieResponse([void Function(MovieResponseBuilder) updates]) =
      _$MovieResponse;

  static Serializer<MovieResponse> get serializer => _$movieResponseSerializer;

  factory MovieResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<MovieResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
