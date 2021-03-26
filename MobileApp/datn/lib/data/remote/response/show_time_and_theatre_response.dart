import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';
import 'show_time_response.dart';
import 'theatre_response.dart';

part 'show_time_and_theatre_response.g.dart';

abstract class ShowTimeAndTheatreResponse
    implements
        Built<ShowTimeAndTheatreResponse, ShowTimeAndTheatreResponseBuilder> {
  ShowTimeResponse get show_time;

  TheatreResponse get theatre;

  ShowTimeAndTheatreResponse._();

  factory ShowTimeAndTheatreResponse(
          [void Function(ShowTimeAndTheatreResponseBuilder) updates]) =
      _$ShowTimeAndTheatreResponse;

  static Serializer<ShowTimeAndTheatreResponse> get serializer =>
      _$showTimeAndTheatreResponseSerializer;

  factory ShowTimeAndTheatreResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<ShowTimeAndTheatreResponse>(
          serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
