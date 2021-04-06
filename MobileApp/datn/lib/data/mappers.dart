import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:tuple/tuple.dart';

import '../domain/model/card.dart';
import '../domain/model/category.dart';
import '../domain/model/comment.dart';
import '../domain/model/comments.dart';
import '../domain/model/location.dart';
import '../domain/model/movie.dart';
import '../domain/model/movie_and_showtimes.dart';
import '../domain/model/notification.dart';
import '../domain/model/person.dart';
import '../domain/model/product.dart';
import '../domain/model/promotion.dart';
import '../domain/model/reservation.dart';
import '../domain/model/seat.dart';
import '../domain/model/show_time.dart';
import '../domain/model/theatre.dart';
import '../domain/model/theatre_and_show_times.dart';
import '../domain/model/ticket.dart';
import '../domain/model/user.dart';
import '../utils/utils.dart';
import 'local/user_local.dart';
import 'remote/response/card_response.dart';
import 'remote/response/category_response.dart';
import 'remote/response/comment_response.dart';
import 'remote/response/comments_response.dart';
import 'remote/response/full_reservation_response.dart';
import 'remote/response/movie_and_show_time_response.dart';
import 'remote/response/movie_detail_response.dart';
import 'remote/response/movie_response.dart';
import 'remote/response/notification_response.dart';
import 'remote/response/person_response.dart';
import 'remote/response/product_response.dart';
import 'remote/response/promotion_response.dart';
import 'remote/response/reservation_response.dart';
import 'remote/response/show_time_and_theatre_response.dart';
import 'remote/response/show_time_response.dart';
import 'remote/response/theatre_response.dart';
import 'remote/response/ticket_response.dart';
import 'remote/response/user_response.dart';

UserLocal userResponseToUserLocal(UserResponse response) {
  return UserLocal((b) {
    final latitude = response.location?.latitude;
    final longitude = response.location?.longitude;

    final locationLocalBuilder = latitude != null && longitude != null
        ? (LocationLocalBuilder()
          ..latitude = latitude
          ..longitude = longitude)
        : null;

    b
      ..uid = response.uid
      ..email = response.email
      ..phoneNumber = response.phoneNumber
      ..fullName = response.fullName
      ..gender = response.gender
      ..avatar = response.avatar
      ..address = response.address
      ..birthday = response.birthday
      ..location = locationLocalBuilder
      ..isCompleted = response.isCompleted
      ..isActive = response.isActive ?? true;
  });
}

Gender stringToGender(String s) {
  if (s == 'MALE') {
    return Gender.MALE;
  }
  if (s == 'FEMALE') {
    return Gender.FEMALE;
  }
  throw Exception("Cannot convert string '$s' to gender");
}

User userLocalToUserDomain(UserLocal local) {
  return User((b) {
    final location = local.location;

    b
      ..uid = local.uid
      ..email = local.email
      ..phoneNumber = local.phoneNumber
      ..fullName = local.fullName
      ..gender = stringToGender(local.gender)
      ..avatar = local.avatar
      ..address = local.address
      ..birthday = local.birthday
      ..location = location != null
          ? (LocationBuilder()
            ..latitude = location.latitude
            ..longitude = location.longitude)
          : null
      ..isCompleted = local.isCompleted
      ..isActive = local.isActive;
  });
}

Movie movieResponseToMovie(MovieResponse res) {
  return Movie(
    (b) => b
      ..id = res.id
      ..isActive = res.is_active ?? true
      ..actorIds = (b.actorIds..safeReplace(res.actors))
      ..directorIds = (b.directorIds..safeReplace(res.directors))
      ..title = res.title
      ..trailerVideoUrl = res.trailer_video_url
      ..posterUrl = res.poster_url
      ..overview = res.overview
      ..releasedDate = res.released_date
      ..duration = res.duration
      ..originalLanguage = res.original_language
      ..createdAt = res.createdAt
      ..updatedAt = res.updatedAt
      ..ageType = stringToAgeType(res.age_type)
      ..rateStar = res.rate_star
      ..totalRate = res.total_rate
      ..totalFavorite = res.total_favorite,
  );
}

AgeType stringToAgeType(String s) {
  return AgeType.values.firstWhere(
    (v) => describeEnum(v) == s,
    orElse: () => throw Exception("Cannot convert string '$s' to AgeType"),
  );
}

Location locationResponseToLocation(LocationResponse response) {
  return Location((b) => b
    ..longitude = response.longitude
    ..latitude = response.latitude);
}

Theatre theatreResponseToTheatre(TheatreResponse response) {
  return Theatre((b) {
    final locationBuilder = b.location
      ..replace(locationResponseToLocation(response.location));
    final roomsBuilder = b.rooms..safeReplace(response.rooms);

    b
      ..id = response.id
      ..location = locationBuilder
      ..is_active = response.is_active ?? true
      ..rooms = roomsBuilder
      ..name = response.name
      ..address = response.address
      ..phone_number = response.phone_number
      ..description = response.description
      ..email = response.email
      ..opening_hours = response.opening_hours
      ..room_summary = response.room_summary
      ..createdAt = response.createdAt
      ..updatedAt = response.updatedAt
      ..distance = response.distance
      ..thumbnail = response.thumbnail ?? ''
      ..cover = response.cover ?? '';
  });
}

ShowTime showTimeResponseToShowTime(ShowTimeResponse response) {
  return ShowTime((b) => b
    ..id = response.id
    ..is_active = response.is_active ?? true
    ..movieId = response.movie
    ..theatreId = response.theatre
    ..room = response.room
    ..end_time = response.end_time
    ..start_time = response.start_time
    ..createdAt = response.createdAt
    ..updatedAt = response.updatedAt);
}

BuiltMap<DateTime, BuiltList<TheatreAndShowTimes>>
    showTimeAndTheatreResponsesToTheatreAndShowTimes(
  BuiltList<ShowTimeAndTheatreResponse> responses,
) {
  final _showTimeAndTheatreResponseToTuple2 =
      (ShowTimeAndTheatreResponse response) => Tuple2(
            theatreResponseToTheatre(response.theatre),
            showTimeResponseToShowTime(response.show_time),
          );

  final _tuplesToMapEntry = (
    DateTime day,
    List<Tuple2<Theatre, ShowTime>> tuples,
  ) {
    final theatreAndShowTimes = tuples
        .groupBy(
          (tuple) => tuple.item1,
          (tuple) => tuple.item2,
        )
        .entries
        .map(
          (entry) => TheatreAndShowTimes(
            (b) {
              final showTimesBuilder = b.showTimes
                ..addAll(entry.value)
                ..sort((l, r) => l.start_time.compareTo(r.start_time));

              final theatreBuilder = b.theatre..replace(entry.key);

              b
                ..theatre = theatreBuilder
                ..showTimes = showTimesBuilder;
            },
          ),
        )
        .toBuiltList();
    return MapEntry(day, theatreAndShowTimes);
  };

  final showTimesByDate = responses
      .map(_showTimeAndTheatreResponseToTuple2)
      .groupListsBy((tuple) => startOfDay(tuple.item2.start_time))
      .map(_tuplesToMapEntry);

  return showTimesByDate.build();
}

Comments commentsResponseToComments(CommentsResponse response) {
  return Comments((b) {
    final listBuilder = b.comments
      ..update(
        (cb) => cb.addAll(
          response.comments.map(commentResponseToComment),
        ),
      );

    b
      ..total = response.total
      ..average = response.average
      ..comments = listBuilder;
  });
}

Comment commentResponseToComment(CommentResponse response) {
  return Comment((b) {
    final userBuilder = b.user..replace(userResponseToUser(response.user));

    b
      ..id = response.id
      ..is_active = response.is_active ?? true
      ..content = response.content
      ..rate_star = response.rate_star
      ..movie = response.movie
      ..user = userBuilder
      ..createdAt = response.createdAt
      ..updatedAt = response.updatedAt;
  });
}

User userResponseToUser(UserResponse response) {
  return User((b) {
    final location = response.location;
    final locationBuilder = location != null &&
            location.latitude != null &&
            location.longitude != null
        ? (b.location..replace(locationResponseToLocation(location)))
        : null;

    b
      ..uid = response.uid
      ..email = response.email
      ..phoneNumber = response.phoneNumber
      ..fullName = response.fullName
      ..gender = stringToGender(response.gender)
      ..avatar = response.avatar
      ..address = response.address
      ..birthday = response.birthday
      ..location = locationBuilder
      ..isCompleted = response.isCompleted
      ..isActive = response.isActive ?? true;
  });
}

Movie movieDetailResponseToMovie(MovieDetailResponse res) {
  return Movie(
    (b) {
      final actorIdsBuilder = b.actorIds
        ..safeReplace(res.actors.map((a) => a.id));
      final directorIdsBuilder = b.directorIds
        ..safeReplace(res.directors.map((a) => a.id));

      final actorsBuilder = b.actors
        ..safeReplace(res.actors.map(personResponseToPerson));
      final directorsBuilder = b.directors
        ..safeReplace(res.directors.map(personResponseToPerson));
      final categoriesBuilder = b.categories
        ..safeReplace(res.categories.map(categoryResponseToCategory));

      b
        ..id = res.id
        ..isActive = res.is_active ?? true
        ..actorIds = actorIdsBuilder
        ..directorIds = directorIdsBuilder
        ..title = res.title
        ..trailerVideoUrl = res.trailer_video_url
        ..posterUrl = res.poster_url
        ..overview = res.overview
        ..releasedDate = res.released_date
        ..duration = res.duration
        ..originalLanguage = res.original_language
        ..createdAt = res.createdAt
        ..updatedAt = res.updatedAt
        ..ageType = stringToAgeType(res.age_type)
        ..actors = actorsBuilder
        ..directors = directorsBuilder
        ..categories = categoriesBuilder
        ..rateStar = res.rate_star
        ..totalRate = res.total_rate
        ..totalFavorite = res.total_favorite;
    },
  );
}

Person personResponseToPerson(PersonResponse response) {
  return Person(
    (b) => b
      ..is_active = response.is_active ?? true
      ..id = response.id
      ..avatar = response.avatar
      ..full_name = response.full_name
      ..createdAt = response.createdAt
      ..updatedAt = response.updatedAt,
  );
}

Category categoryResponseToCategory(CategoryResponse response) {
  return Category(
    (b) => b
      ..id = response.id
      ..name = response.name
      ..createdAt = response.createdAt
      ..updatedAt = response.updatedAt
      ..is_active = response.is_active ?? true,
  );
}

Ticket ticketResponseToTicket(TicketResponse response) {
  final seat = response.seat;
  return Ticket.from(
    id: response.id,
    is_active: response.is_active ?? true,
    price: response.price,
    reservationId: response.reservation,
    seat: Seat.from(
      is_active: seat.is_active ?? true,
      coordinates: SeatCoordinates.from(
        x: seat.coordinates[0],
        y: seat.coordinates[1],
      ),
      id: seat.id,
      room: seat.room,
      theatre: seat.theatre,
      column: seat.column,
      row: seat.row,
      count: seat.count,
      createdAt: seat.createdAt,
      updatedAt: seat.updatedAt,
    ),
    show_time: response.show_time,
    createdAt: response.createdAt,
    updatedAt: response.updatedAt,
    reservation: null,
  );
}

Product productResponseToProduct(ProductResponse response) {
  return Product.from(
    id: response.id,
    description: response.description,
    image: response.image,
    is_active: response.is_active ?? true,
    name: response.name,
    price: response.price,
    createdAt: response.createdAt,
    updatedAt: response.updatedAt,
  );
}

Card cardResponseToCard(CardResponse response) {
  return Card(
    (b) => b
      ..brand = response.brand
      ..card_holder_name = response.card_holder_name
      ..country = response.country
      ..exp_month = response.exp_month
      ..exp_year = response.exp_year
      ..funding = response.funding
      ..id = response.id
      ..last4 = response.last4,
  );
}

Reservation reservationResponseToReservation(ReservationResponse response) {
  return Reservation((b) {
    final productIds = response.products.map((p) =>
        ProductAndQuantity.from(id: p.id, quantity: p.quantity, product: null));
    final productIdWithCountsBuilder = b.productIdWithCounts
      ..safeReplace(productIds);
    final user = userResponseToUser(response.user);
    final userBuilder = b.user..replace(user);

    b
      ..id = response.id
      ..createdAt = response.createdAt
      ..email = response.email
      ..isActive = response.is_active ?? true
      ..originalPrice = response.original_price
      ..paymentIntentId = response.payment_intent_id
      ..phoneNumber = response.phone_number
      ..productIdWithCounts = productIdWithCountsBuilder
      ..showTimeId = response.show_time.id
      ..totalPrice = response.total_price
      ..updatedAt = response.updatedAt
      ..user = userBuilder;
  });
}

Promotion promotionResponseToPromotion(PromotionResponse response) {
  return Promotion(
    (b) => b
      ..id = response.id
      ..code = response.code
      ..discount = response.discount
      ..endTime = response.end_time
      ..isActive = response.is_active ?? true
      ..name = response.name
      ..startTime = response.start_time
      ..creator = response.creator
      ..showTime = response.show_time
      ..createdAt = response.createdAt
      ..updatedAt = response.updatedAt,
  );
}

Notification notificationResponseToNotification(NotificationResponse res) {
  return Notification(
    (b) {
      final reservationBuilder = b.reservation
        ..replace(notificationResponse_ReservationResponseToReservation(
            res.reservation));

      b
        ..id = res.id
        ..title = res.title
        ..body = res.body
        ..to_user = res.to_user
        ..createdAt = res.createdAt
        ..updatedAt = res.updatedAt
        ..reservation = reservationBuilder;
    },
  );
}

ShowTime showTimeFullResponseToShowTime(ShowTimeFullResponse response) {
  final movie = movieResponseToMovie(response.movie);
  final theatre = theatreResponseToTheatre(response.theatre);

  return ShowTime((b) {
    final movieBuilder = b.movie..replace(movie);
    final theatreBuilder = b.theatre..replace(theatre);

    b
      ..id = response.id
      ..is_active = response.is_active ?? true
      ..movieId = movie.id
      ..theatreId = theatre.id
      ..room = response.room
      ..end_time = response.end_time
      ..start_time = response.start_time
      ..createdAt = response.createdAt
      ..updatedAt = response.updatedAt
      ..movie = movieBuilder
      ..theatre = theatreBuilder;
  });
}

Reservation notificationResponse_ReservationResponseToReservation(
    NotificationResponse_ReservationResponse response) {
  return Reservation((b) {
    final productIds = response.products.map((p) =>
        ProductAndQuantity.from(id: p.id, quantity: p.quantity, product: null));
    final productIdWithCountsBuilder = b.productIdWithCounts
      ..safeReplace(productIds);
    final showTimeBuilder = b.showTime
      ..replace(showTimeFullResponseToShowTime(response.show_time));

    b
      ..id = response.id
      ..createdAt = response.createdAt
      ..email = response.email
      ..isActive = response.is_active ?? true
      ..originalPrice = response.original_price
      ..paymentIntentId = response.payment_intent_id
      ..phoneNumber = response.phone_number
      ..productIdWithCounts = productIdWithCountsBuilder
      ..showTimeId = response.show_time.id
      ..showTime = showTimeBuilder
      ..totalPrice = response.total_price
      ..updatedAt = response.updatedAt;
  });
}

Reservation fullReservationResponseToReservation(
    FullReservationResponse response) {
  return Reservation((b) {
    final productIds = response.products.map(
      (p) => ProductAndQuantity.from(
        id: p.product.id,
        quantity: p.quantity,
        product: productResponseToProduct(p.product),
      ),
    );
    final productIdWithCountsBuilder = b.productIdWithCounts
      ..safeReplace(productIds);
    final showTimeBuilder = b.showTime
      ..replace(showTimeFullResponseToShowTime(response.show_time));
    final ticketsBuilder = b.tickets
      ..safeReplace(response.tickets.map((t) => ticketResponseToTicket(t)));

    final promotion = response.promotion_id;
    final promotionBuilder = promotion == null
        ? null
        : (b.promotion..replace(promotionResponseToPromotion(promotion)));

    b
      ..id = response.id
      ..createdAt = response.createdAt
      ..email = response.email
      ..isActive = response.is_active ?? true
      ..originalPrice = response.original_price
      ..paymentIntentId = response.payment_intent_id
      ..phoneNumber = response.phone_number
      ..productIdWithCounts = productIdWithCountsBuilder
      ..showTimeId = response.show_time.id
      ..showTime = showTimeBuilder
      ..totalPrice = response.total_price
      ..updatedAt = response.updatedAt
      ..tickets = ticketsBuilder
      ..promotionId = promotion?.id
      ..promotion = promotionBuilder;
  });
}

BuiltMap<DateTime, BuiltList<MovieAndShowTimes>>
    movieAndShowTimeResponsesToMovieAndShowTimes(
        BuiltList<MovieAndShowTimeResponse> res) {
  MapEntry<DateTime, BuiltList<MovieAndShowTimes>> toMovieAndShowTimes(
    DateTime day,
    List<MovieAndShowTimeResponse> response,
  ) {
    final movieAndShowTimeResponses = response
        .groupListsBy((v) => v.movie)
        .entries
        .map(
          (entry) => MovieAndShowTimes(
            (b) {
              final movieAndShowTimeResponses = entry.value;

              final showTimesBuilder = b.showTimes
                ..addAll(movieAndShowTimeResponses
                    .map((e) => showTimeResponseToShowTime(e.show_time)))
                ..sort((l, r) => l.start_time.compareTo(r.start_time));

              final movieBuilder = b.movie
                ..replace(movieResponseToMovie(
                    movieAndShowTimeResponses.first.movie));

              b
                ..movie = movieBuilder
                ..showTimes = showTimesBuilder;
            },
          ),
        )
        .toBuiltList();
    return MapEntry(day, movieAndShowTimeResponses);
  }

  return res
      .groupListsBy((v) => startOfDay(v.show_time.start_time))
      .map(toMovieAndShowTimes)
      .build();
}
