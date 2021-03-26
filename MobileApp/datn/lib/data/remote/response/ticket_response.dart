import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';
import 'seat_response.dart';

part 'ticket_response.g.dart';

abstract class TicketResponse
    implements Built<TicketResponse, TicketResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  bool? get is_active;

  int get price;

  String? get reservation;

  SeatResponse get seat;

  String get show_time;

  DateTime get createdAt;

  DateTime get updatedAt;

  TicketResponse._();

  factory TicketResponse([void Function(TicketResponseBuilder) updates]) =
      _$TicketResponse;

  static Serializer<TicketResponse> get serializer =>
      _$ticketResponseSerializer;

  factory TicketResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<TicketResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
