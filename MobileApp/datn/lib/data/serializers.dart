import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'local/user_local.dart';
import 'remote/response/error_response.dart';
import 'remote/response/movie_response.dart';
import 'remote/response/user_response.dart';

part 'serializers.g.dart';

final builtListMovieResponse = FullType(
  BuiltList,
  [FullType(MovieResponse)],
);

@SerializersFor([
  UserLocal,
  LocationLocal,
  UserResponse,
  LocationResponse,
  SingleMessageErrorResponse,
  MultipleMessagesErrorResponse,
  MovieResponse,
])
final Serializers _serializers = _$_serializers;

final Serializers serializers = (_serializers.toBuilder()
      ..addBuilderFactory(
        builtListMovieResponse,
        () => ListBuilder<MovieResponse>(),
      )
      ..add(Iso8601DateTimeSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();
