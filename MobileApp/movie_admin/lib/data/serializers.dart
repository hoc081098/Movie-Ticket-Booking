import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import '../utils/custom_iso_8601_date_time_serializer.dart';
import 'local/user_local.dart';
import 'remote/response/category_response.dart';
import 'remote/response/error_response.dart';
import 'remote/response/movie_response.dart';
import 'remote/response/person_response.dart';
import 'remote/response/show_time_response.dart';
import 'remote/response/theatre_response.dart';
import 'remote/response/ticket_response.dart';
import 'remote/response/user_response.dart';

part 'serializers.g.dart';

const builtListTicketResponse = FullType(
  BuiltList,
  [FullType(TicketResponse)],
);

@SerializersFor([

])
final Serializers _serializers = _$_serializers;

final Serializers serializers = (_serializers.toBuilder()
      ..addBuilderFactory(
        builtListTicketResponse,
        () => ListBuilder<TicketResponse>(),
      )
      ..add(CustomIso8601DateTimeSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();
