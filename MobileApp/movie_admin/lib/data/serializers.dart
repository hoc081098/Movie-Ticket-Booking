import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import '../utils/custom_iso_8601_date_time_serializer.dart';
import 'remote/response/full_reservation_response.dart';
import 'remote/response/product_response.dart';
import 'remote/response/promotion_response.dart';
import 'remote/response/seat_response.dart';
import 'remote/response/ticket_response.dart';

part 'serializers.g.dart';

const builtListTicketResponse = FullType(
  BuiltList,
  [FullType(TicketResponse)],
);

const builtListFullReservationResponse = FullType(
  BuiltList,
  [FullType(FullReservationResponse)],
);

const builtListSeatResponse = FullType(
  BuiltList,
  [FullType(SeatResponse)],
);

@SerializersFor([
  TicketResponse,
  SeatResponse,
  FullReservationResponse,
  PromotionResponse,
  ProductResponse,
])
final Serializers _serializers = _$_serializers;

final Serializers serializers = (_serializers.toBuilder()
      ..add(UserResponseSerializer())
      ..addBuilderFactory(
        builtListTicketResponse,
        () => ListBuilder<TicketResponse>(),
      )
      ..addBuilderFactory(
        builtListFullReservationResponse,
        () => ListBuilder<FullReservationResponse>(),
      )
      ..addBuilderFactory(
        builtListSeatResponse,
        () => ListBuilder<SeatResponse>(),
      )
      ..add(CustomIso8601DateTimeSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();
