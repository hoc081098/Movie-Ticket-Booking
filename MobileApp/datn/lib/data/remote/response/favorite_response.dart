import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';
import 'movie_response.dart';

part 'favorite_response.g.dart';

abstract class FavoriteResponse
    implements Built<FavoriteResponse, FavoriteResponseBuilder> {
  MovieResponse get movie;

  bool get is_favorite;

  FavoriteResponse._();

  factory FavoriteResponse([void Function(FavoriteResponseBuilder) updates]) =
      _$FavoriteResponse;

  static Serializer<FavoriteResponse> get serializer =>
      _$favoriteResponseSerializer;

  factory FavoriteResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<FavoriteResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
