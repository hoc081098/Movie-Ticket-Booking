import 'dart:convert';

import '../data/remote/response/full_reservation_response.dart';
import '../data/remote/response/product_response.dart';
import '../data/remote/response/promotion_response.dart';
import '../domain/model/age_type.dart';
import '../domain/model/category.dart';
import '../domain/model/location.dart';
import '../domain/model/movie.dart';
import '../domain/model/person.dart';
import '../domain/model/product.dart';
import '../domain/model/promotion.dart';
import '../domain/model/reservation.dart';
import '../domain/model/seat.dart';
import '../domain/model/show_time.dart';
import '../domain/model/theatre.dart';
import '../domain/model/ticket.dart';
import '../domain/model/user.dart';
import '../utils/utils.dart';
import 'local/user_local.dart';
import 'remote/request/movie_request.dart';
import 'remote/response/category_response.dart';
import 'remote/response/movie_response.dart';
import 'remote/response/person_response.dart';
import 'remote/response/show_time_response.dart';
import 'remote/response/theatre_response.dart';
import 'remote/response/ticket_response.dart';
import 'remote/response/user_response.dart';

UserLocal userResponseToUserLocal(UserResponse response) {
  return UserLocal(
    uid: response.uid,
    email: response.email,
    phone_number: response.phone_number,
    full_name: response.full_name,
    gender: response.gender,
    avatar: response.avatar,
    address: response.address,
    birthday: response.birthday,
    location: response.location == null
        ? null
        : LocationLocal(
            latitude: response.location.latitude,
            longitude: response.location.longitude,
          ),
    is_completed: response.is_completed,
    is_active: response.is_active ?? true,
    role: response.role,
    theatreResponseString:
        response.theatre == null ? null : jsonEncode(response.theatre),
  );
}

User userLocalToUserDomain(UserLocal local) {
  return User(
    uid: local.uid,
    email: local.email,
    phoneNumber: local.phone_number,
    fullName: local.full_name,
    gender: stringToGender(local.gender),
    avatar: local.avatar,
    address: local.address,
    birthday: local.birthday,
    location: local.location == null
        ? null
        : Location(
            latitude: local.location.latitude,
            longitude: local.location.longitude,
          ),
    isCompleted: local.is_completed,
    isActive: local.is_active ?? true,
    role: local.role.parseToRole(),
    theatre: local.theatreResponseString == null
        ? null
        : theatreResponseToTheatre(
            TheatreResponse.fromRawJson(local.theatreResponseString)),
  );
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

extension RoleResponse on String {
  Role parseToRole() {
    return this == 'ADMIN'
        ? Role.ADMIN
        : this == 'STAFF'
            ? Role.STAFF
            : Role.USER;
  }
}

User userResponseToUserDomain(UserResponse response) {
  return User(
    uid: response.uid,
    email: response.email,
    phoneNumber: response.phone_number,
    fullName: response.full_name,
    gender: stringToGender(response.gender),
    avatar: response.avatar,
    address: response.address,
    birthday: response.birthday,
    location: response.location == null
        ? null
        : Location(
            latitude: response.location.latitude,
            longitude: response.location.longitude,
          ),
    isCompleted: response.is_completed,
    isActive: response.is_active ?? true,
    role: response.role.parseToRole(),
    theatre: response.theatre == null
        ? null
        : theatreResponseToTheatre(response.theatre),
  );
}

Movie movieRemoteToDomain(MovieResponse response) {
  return Movie(
    id: response.id,
    isActive: response.isActive,
    title: response.title,
    trailerVideoUrl: response.trailerVideoUrl,
    posterUrl: response.posterUrl,
    overview: response.overview,
    releasedDate: response.releasedDate,
    duration: response.duration,
    originalLanguage: response.originalLanguage,
    createdAt: response.createdAt,
    updatedAt: response.updatedAt,
    ageType: response.ageType.ageType(),
    actors: response.actors.map((e) => personResponseToPerson(e)).toList(),
    directors:
        response.directors.map((e) => personResponseToPerson(e)).toList(),
    categories:
        response.categories.map((e) => categoryResponseToCategory(e)).toList(),
    rateStar: response.rateStar,
    totalFavorite: response.totalFavorite,
    totalRate: response.totalRate,
  );
}

MovieRequest movieDomainToRemote(Movie movie) {
  return MovieRequest(
    title: movie.title,
    trailerVideoUrl: movie.trailerVideoUrl,
    posterUrl: movie.posterUrl,
    overview: movie.overview,
    releasedDate: movie.releasedDate.toIso8601String(),
    duration: movie.duration,
    directorIds: movie.directors.map((e) => e.id).toList(),
    actorIds: movie.actors.map((e) => e.id).toList(),
    originalLanguage: movie.originalLanguage,
    ageType: movie.ageType.toString().split('.')[1],
    categoryIds: movie.categories.map((e) => e.id).toList(),
  );
}

Category categoryResponseToCategory(CategoryResponse response) {
  return Category(
    id: response.id,
    name: response.name,
    createdAt: response.createdAt,
    updatedAt: response.updatedAt,
    is_active: true,
  );
}

Person personResponseToPerson(PersonResponse response) {
  return Person(
    is_active: response.isActive ?? true,
    id: response.id,
    avatar: response.avatar,
    full_name: response.fullName,
    createdAt: response.createdAt,
    updatedAt: response.updatedAt,
  );
}

extension AgeTypeExtension on String {
  AgeType ageType() => this == 'P'
      ? AgeType.P
      : this == 'C13'
          ? AgeType.C13
          : this == 'C16'
              ? AgeType.C16
              : AgeType.C18;
}

Location locationResponseToLocation(LocationResponse response) {
  return Location(
    latitude: response.latitude,
    longitude: response.longitude,
  );
}

Theatre theatreResponseToTheatre(TheatreResponse response) {
  return Theatre(
    id: response.id,
    location: locationResponseToLocation(response.location),
    isActive: response.isActive ?? true,
    rooms: response.rooms,
    name: response.name,
    address: response.address,
    phoneNumber: response.phoneNumber,
    description: response.description,
    email: response.email,
    openingHours: response.openingHours,
    roomSummary: response.roomSummary,
    createdAt: response.createdAt,
    updatedAt: response.updatedAt,
    thumbnail: response.thumbnail ?? '',
    cover: response.cover ?? '',
  );
}

ShowTime showTimeResponseToShowTime(ShowTimeResponse r) {
  final m = r.movie;
  return ShowTime(
    isActive: r.isActive ?? true,
    id: r.id,
    movie: Movie(
      id: m.id,
      isActive: m.isActive ?? true,
      title: m.title,
      trailerVideoUrl: m.trailerVideoUrl,
      posterUrl: m.posterUrl,
      overview: m.overview,
      releasedDate: m.releasedDate,
      duration: m.duration,
      originalLanguage: m.originalLanguage,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
      ageType: m.ageType.ageType(),
      actors: null,
      directors: null,
      categories: null,
      rateStar: m.rateStar,
      totalFavorite: m.totalFavorite,
      totalRate: m.totalRate,
    ),
    movieId: m.id,
    theatreId: r.theatre,
    room: r.room,
    endTime: r.endTime,
    startTime: r.startTime,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
    theatre: null,
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

ShowTime showTimeFullResponseToShowTime(ShowTimeFullResponse r) {
  final movie = res_movieResponseToMovie(r.movie);
  final theatre = res_theatreResponseToTheatre(r.theatre);

  return ShowTime(
    isActive: r.is_active ?? true,
    id: r.id,
    movie: movie,
    movieId: r.movie.id,
    theatreId: r.theatre.id,
    room: r.room,
    endTime: r.end_time,
    startTime: r.start_time,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
    theatre: theatre,
  );
}

Theatre res_theatreResponseToTheatre(Res_TheatreResponse r) {
  assert(r.location != null);

  return Theatre(
    location: Location(
      latitude: r.location.latitude,
      longitude: r.location.longitude,
    ),
    isActive: r.is_active ?? true,
    rooms: r.rooms.asList(),
    id: r.id,
    name: r.name,
    address: r.address,
    phoneNumber: r.phone_number,
    description: r.description,
    email: r.email,
    openingHours: r.opening_hours,
    roomSummary: r.room_summary,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
    cover: r.cover,
    thumbnail: r.thumbnail,
  );
}

Movie res_movieResponseToMovie(Res_MovieResponse r) {
  return Movie(
    id: r.id,
    isActive: r.is_active ?? true,
    title: r.title,
    trailerVideoUrl: r.trailer_video_url,
    posterUrl: r.poster_url,
    overview: r.overview,
    releasedDate: r.released_date,
    duration: r.duration,
    originalLanguage: r.original_language,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
    ageType: r.age_type.ageType(),
    actors: null,
    directors: null,
    categories: null,
    rateStar: r.rate_star,
    totalFavorite: r.total_favorite,
    totalRate: r.total_rate,
  );
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
    final ticketsBuilder = b.tickets
      ..safeReplace(response.tickets.map((t) => ticketResponseToTicket(t)));

    final promotion = response.promotion_id;
    final promotionBuilder = promotion == null
        ? null
        : (b.promotion..replace(promotionResponseToPromotion(promotion)));

    return b
      ..id = response.id
      ..createdAt = response.createdAt
      ..email = response.email
      ..isActive = response.is_active ?? true
      ..originalPrice = response.original_price
      ..paymentIntentId = response.payment_intent_id
      ..phoneNumber = response.phone_number
      ..productIdWithCounts = productIdWithCountsBuilder
      ..showTimeId = response.show_time.id
      ..showTime = showTimeFullResponseToShowTime(response.show_time)
      ..totalPrice = response.total_price
      ..updatedAt = response.updatedAt
      ..tickets = ticketsBuilder
      ..promotionId = promotion?.id
      ..promotion = promotionBuilder
      ..user = userResponseToUserDomain(response.user);
  });
}
