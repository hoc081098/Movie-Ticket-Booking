import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';

part 'seat_response.g.dart';

abstract class SeatResponse
    implements Built<SeatResponse, SeatResponseBuilder> {
  @nullable
  bool get is_active;

  BuiltList<int> get coordinates;

  @BuiltValueField(wireName: '_id')
  String get id;

  String get room;

  String get theatre;

  int get column;

  String get row;

  int get count;

  DateTime get createdAt;

  DateTime get updatedAt;

  SeatResponse._();

  factory SeatResponse([void Function(SeatResponseBuilder) updates]) =
      _$SeatResponse;

  static Serializer<SeatResponse> get serializer => _$seatResponseSerializer;

  factory SeatResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<SeatResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}
