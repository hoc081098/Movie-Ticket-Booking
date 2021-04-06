import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import '../utils/utils.dart';
import 'local/user_local.dart';
import 'remote/response/category_response.dart';
import 'remote/response/comment_response.dart';
import 'remote/response/comments_response.dart';
import 'remote/response/error_response.dart';
import 'remote/response/favorite_response.dart';
import 'remote/response/full_reservation_response.dart';
import 'remote/response/movie_and_show_time_response.dart';
import 'remote/response/movie_detail_response.dart';
import 'remote/response/movie_response.dart';
import 'remote/response/notification_response.dart';
import 'remote/response/person_response.dart';
import 'remote/response/product_response.dart';
import 'remote/response/promotion_response.dart';
import 'remote/response/reservation_response.dart';
import 'remote/response/seat_response.dart';
import 'remote/response/show_time_and_theatre_response.dart';
import 'remote/response/show_time_response.dart';
import 'remote/response/theatre_response.dart';
import 'remote/response/ticket_response.dart';
import 'remote/response/user_response.dart';

part 'serializers.g.dart';

const builtListMovieResponse = FullType(
  BuiltList,
  [FullType(MovieResponse)],
);

const builtListShowTimeAndTheatreResponse = FullType(
  BuiltList,
  [FullType(ShowTimeAndTheatreResponse)],
);

const builtListTicketResponse = FullType(
  BuiltList,
  [FullType(TicketResponse)],
);

const builtListProductResponse = FullType(
  BuiltList,
  [FullType(ProductResponse)],
);

const builtMapStringReservationResponse = FullType(
  BuiltMap,
  [
    FullType(String),
    FullType(ReservationResponse),
  ],
);

const builtListPromotionResponses = FullType(
  BuiltList,
  [FullType(PromotionResponse)],
);

const builtListNotificationResponse = FullType(
  BuiltList,
  [FullType(NotificationResponse)],
);

const builtListFullReservationResponse = FullType(
  BuiltList,
  [FullType(FullReservationResponse)],
);

const builtListTheatreResponse = FullType(
  BuiltList,
  [FullType(TheatreResponse)],
);

const builtListMovieAndShowTimeResponse = FullType(
  BuiltList,
  [FullType(MovieAndShowTimeResponse)],
);

const builtListCategoryResponse = FullType(
  BuiltList,
  [FullType(CategoryResponse)],
);

@SerializersFor([
  UserLocal,
  LocationLocal,
  UserResponse,
  LocationResponse,
  SingleMessageErrorResponse,
  MultipleMessagesErrorResponse,
  MovieResponse,
  ShowTimeResponse,
  TheatreResponse,
  ShowTimeAndTheatreResponse,
  CommentResponse,
  CommentsResponse,
  MovieDetailResponse,
  PersonResponse,
  CategoryResponse,
  TicketResponse,
  SeatResponse,
  ProductResponse,
  ReservationResponse,
  ProductIdAndQuantity,
  FavoriteResponse,
  PromotionResponse,
  NotificationResponse,
  NotificationResponse_ReservationResponse,
  ShowTimeFullResponse,
  FullReservationResponse,
  ProductAndQuantityResponse,
  MovieAndShowTimeResponse,
])
final Serializers _serializers = _$_serializers;

final Serializers serializers = (_serializers.toBuilder()
      ..addBuilderFactory(
        builtListMovieResponse,
        () => ListBuilder<MovieResponse>(),
      )
      ..addBuilderFactory(
        builtListShowTimeAndTheatreResponse,
        () => ListBuilder<ShowTimeAndTheatreResponse>(),
      )
      ..addBuilderFactory(
        builtListTicketResponse,
        () => ListBuilder<TicketResponse>(),
      )
      ..addBuilderFactory(
        builtListProductResponse,
        () => ListBuilder<ProductResponse>(),
      )
      ..addBuilderFactory(
        builtMapStringReservationResponse,
        () => MapBuilder<String, ReservationResponse>(),
      )
      ..addBuilderFactory(
        builtListPromotionResponses,
        () => ListBuilder<PromotionResponse>(),
      )
      ..addBuilderFactory(
        builtListNotificationResponse,
        () => ListBuilder<NotificationResponse>(),
      )
      ..addBuilderFactory(
        builtListFullReservationResponse,
        () => ListBuilder<FullReservationResponse>(),
      )
      ..addBuilderFactory(
        builtListTheatreResponse,
        () => ListBuilder<TheatreResponse>(),
      )
      ..addBuilderFactory(
        builtListMovieAndShowTimeResponse,
        () => ListBuilder<MovieAndShowTimeResponse>(),
      )
      ..addBuilderFactory(
        builtListCategoryResponse,
        () => ListBuilder<CategoryResponse>(),
      )
      ..add(CustomIso8601DateTimeSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();
