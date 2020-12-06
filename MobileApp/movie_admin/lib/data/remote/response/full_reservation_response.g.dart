// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_reservation_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FullReservationResponse> _$fullReservationResponseSerializer =
    new _$FullReservationResponseSerializer();
Serializer<ProductAndQuantityResponse> _$productAndQuantityResponseSerializer =
    new _$ProductAndQuantityResponseSerializer();
Serializer<ShowTimeFullResponse> _$showTimeFullResponseSerializer =
    new _$ShowTimeFullResponseSerializer();
Serializer<Res_MovieResponse> _$resMovieResponseSerializer =
    new _$Res_MovieResponseSerializer();
Serializer<Res_TheatreResponse> _$resTheatreResponseSerializer =
    new _$Res_TheatreResponseSerializer();
Serializer<Res_LocationResponse> _$resLocationResponseSerializer =
    new _$Res_LocationResponseSerializer();

class _$FullReservationResponseSerializer
    implements StructuredSerializer<FullReservationResponse> {
  @override
  final Iterable<Type> types = const [
    FullReservationResponse,
    _$FullReservationResponse
  ];
  @override
  final String wireName = 'FullReservationResponse';

  @override
  Iterable<Object> serialize(
      Serializers serializers, FullReservationResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'original_price',
      serializers.serialize(object.original_price,
          specifiedType: const FullType(int)),
      'payment_intent_id',
      serializers.serialize(object.payment_intent_id,
          specifiedType: const FullType(String)),
      'phone_number',
      serializers.serialize(object.phone_number,
          specifiedType: const FullType(String)),
      'products',
      serializers.serialize(object.products,
          specifiedType: const FullType(
              BuiltList, const [const FullType(ProductAndQuantityResponse)])),
      'show_time',
      serializers.serialize(object.show_time,
          specifiedType: const FullType(ShowTimeFullResponse)),
      'total_price',
      serializers.serialize(object.total_price,
          specifiedType: const FullType(int)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(DateTime)),
      'user',
      serializers.serialize(object.user,
          specifiedType: const FullType(UserResponse)),
      'tickets',
      serializers.serialize(object.tickets,
          specifiedType: const FullType(
              BuiltList, const [const FullType(TicketResponse)])),
    ];
    if (object.is_active != null) {
      result
        ..add('is_active')
        ..add(serializers.serialize(object.is_active,
            specifiedType: const FullType(bool)));
    }
    if (object.promotion_id != null) {
      result
        ..add('promotion_id')
        ..add(serializers.serialize(object.promotion_id,
            specifiedType: const FullType(PromotionResponse)));
    }
    return result;
  }

  @override
  FullReservationResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FullReservationResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'is_active':
          result.is_active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'original_price':
          result.original_price = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'payment_intent_id':
          result.payment_intent_id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'phone_number':
          result.phone_number = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'products':
          result.products.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(ProductAndQuantityResponse)
              ])) as BuiltList<Object>);
          break;
        case 'show_time':
          result.show_time.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ShowTimeFullResponse))
              as ShowTimeFullResponse);
          break;
        case 'total_price':
          result.total_price = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'user':
          result.user = serializers.deserialize(value,
              specifiedType: const FullType(UserResponse)) as UserResponse;
          break;
        case 'tickets':
          result.tickets.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(TicketResponse)]))
              as BuiltList<Object>);
          break;
        case 'promotion_id':
          result.promotion_id.replace(serializers.deserialize(value,
                  specifiedType: const FullType(PromotionResponse))
              as PromotionResponse);
          break;
      }
    }

    return result.build();
  }
}

class _$ProductAndQuantityResponseSerializer
    implements StructuredSerializer<ProductAndQuantityResponse> {
  @override
  final Iterable<Type> types = const [
    ProductAndQuantityResponse,
    _$ProductAndQuantityResponse
  ];
  @override
  final String wireName = 'ProductAndQuantityResponse';

  @override
  Iterable<Object> serialize(
      Serializers serializers, ProductAndQuantityResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'product_id',
      serializers.serialize(object.product,
          specifiedType: const FullType(ProductResponse)),
      'quantity',
      serializers.serialize(object.quantity,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  ProductAndQuantityResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductAndQuantityResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'product_id':
          result.product.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ProductResponse))
              as ProductResponse);
          break;
        case 'quantity':
          result.quantity = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$ShowTimeFullResponseSerializer
    implements StructuredSerializer<ShowTimeFullResponse> {
  @override
  final Iterable<Type> types = const [
    ShowTimeFullResponse,
    _$ShowTimeFullResponse
  ];
  @override
  final String wireName = 'ShowTimeFullResponse';

  @override
  Iterable<Object> serialize(
      Serializers serializers, ShowTimeFullResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'movie',
      serializers.serialize(object.movie,
          specifiedType: const FullType(Res_MovieResponse)),
      'theatre',
      serializers.serialize(object.theatre,
          specifiedType: const FullType(Res_TheatreResponse)),
      'room',
      serializers.serialize(object.room, specifiedType: const FullType(String)),
      'end_time',
      serializers.serialize(object.end_time,
          specifiedType: const FullType(DateTime)),
      'start_time',
      serializers.serialize(object.start_time,
          specifiedType: const FullType(DateTime)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(DateTime)),
    ];
    if (object.is_active != null) {
      result
        ..add('is_active')
        ..add(serializers.serialize(object.is_active,
            specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  ShowTimeFullResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ShowTimeFullResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'is_active':
          result.is_active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'movie':
          result.movie.replace(serializers.deserialize(value,
                  specifiedType: const FullType(Res_MovieResponse))
              as Res_MovieResponse);
          break;
        case 'theatre':
          result.theatre.replace(serializers.deserialize(value,
                  specifiedType: const FullType(Res_TheatreResponse))
              as Res_TheatreResponse);
          break;
        case 'room':
          result.room = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'end_time':
          result.end_time = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'start_time':
          result.start_time = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$Res_MovieResponseSerializer
    implements StructuredSerializer<Res_MovieResponse> {
  @override
  final Iterable<Type> types = const [Res_MovieResponse, _$Res_MovieResponse];
  @override
  final String wireName = 'Res_MovieResponse';

  @override
  Iterable<Object> serialize(Serializers serializers, Res_MovieResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'actors',
      serializers.serialize(object.actors,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'directors',
      serializers.serialize(object.directors,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'released_date',
      serializers.serialize(object.released_date,
          specifiedType: const FullType(DateTime)),
      'duration',
      serializers.serialize(object.duration,
          specifiedType: const FullType(int)),
      'original_language',
      serializers.serialize(object.original_language,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(DateTime)),
      'age_type',
      serializers.serialize(object.age_type,
          specifiedType: const FullType(String)),
      'rate_star',
      serializers.serialize(object.rate_star,
          specifiedType: const FullType(double)),
      'total_favorite',
      serializers.serialize(object.total_favorite,
          specifiedType: const FullType(int)),
      'total_rate',
      serializers.serialize(object.total_rate,
          specifiedType: const FullType(int)),
    ];
    if (object.is_active != null) {
      result
        ..add('is_active')
        ..add(serializers.serialize(object.is_active,
            specifiedType: const FullType(bool)));
    }
    if (object.trailer_video_url != null) {
      result
        ..add('trailer_video_url')
        ..add(serializers.serialize(object.trailer_video_url,
            specifiedType: const FullType(String)));
    }
    if (object.poster_url != null) {
      result
        ..add('poster_url')
        ..add(serializers.serialize(object.poster_url,
            specifiedType: const FullType(String)));
    }
    if (object.overview != null) {
      result
        ..add('overview')
        ..add(serializers.serialize(object.overview,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Res_MovieResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new Res_MovieResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'is_active':
          result.is_active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'actors':
          result.actors.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'directors':
          result.directors.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'trailer_video_url':
          result.trailer_video_url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'poster_url':
          result.poster_url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'overview':
          result.overview = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'released_date':
          result.released_date = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'duration':
          result.duration = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'original_language':
          result.original_language = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'age_type':
          result.age_type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'rate_star':
          result.rate_star = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'total_favorite':
          result.total_favorite = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'total_rate':
          result.total_rate = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Res_TheatreResponseSerializer
    implements StructuredSerializer<Res_TheatreResponse> {
  @override
  final Iterable<Type> types = const [
    Res_TheatreResponse,
    _$Res_TheatreResponse
  ];
  @override
  final String wireName = 'Res_TheatreResponse';

  @override
  Iterable<Object> serialize(
      Serializers serializers, Res_TheatreResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'location',
      serializers.serialize(object.location,
          specifiedType: const FullType(Res_LocationResponse)),
      'rooms',
      serializers.serialize(object.rooms,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'address',
      serializers.serialize(object.address,
          specifiedType: const FullType(String)),
      'phone_number',
      serializers.serialize(object.phone_number,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'opening_hours',
      serializers.serialize(object.opening_hours,
          specifiedType: const FullType(String)),
      'room_summary',
      serializers.serialize(object.room_summary,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(DateTime)),
    ];
    if (object.is_active != null) {
      result
        ..add('is_active')
        ..add(serializers.serialize(object.is_active,
            specifiedType: const FullType(bool)));
    }
    if (object.email != null) {
      result
        ..add('email')
        ..add(serializers.serialize(object.email,
            specifiedType: const FullType(String)));
    }
    if (object.distance != null) {
      result
        ..add('distance')
        ..add(serializers.serialize(object.distance,
            specifiedType: const FullType(double)));
    }
    if (object.thumbnail != null) {
      result
        ..add('thumbnail')
        ..add(serializers.serialize(object.thumbnail,
            specifiedType: const FullType(String)));
    }
    if (object.cover != null) {
      result
        ..add('cover')
        ..add(serializers.serialize(object.cover,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Res_TheatreResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new Res_TheatreResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'location':
          result.location.replace(serializers.deserialize(value,
                  specifiedType: const FullType(Res_LocationResponse))
              as Res_LocationResponse);
          break;
        case 'is_active':
          result.is_active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'rooms':
          result.rooms.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'address':
          result.address = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'phone_number':
          result.phone_number = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'opening_hours':
          result.opening_hours = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'room_summary':
          result.room_summary = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'distance':
          result.distance = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'thumbnail':
          result.thumbnail = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'cover':
          result.cover = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Res_LocationResponseSerializer
    implements StructuredSerializer<Res_LocationResponse> {
  @override
  final Iterable<Type> types = const [
    Res_LocationResponse,
    _$Res_LocationResponse
  ];
  @override
  final String wireName = 'Res_LocationResponse';

  @override
  Iterable<Object> serialize(
      Serializers serializers, Res_LocationResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.coordinates != null) {
      result
        ..add('coordinates')
        ..add(serializers.serialize(object.coordinates,
            specifiedType:
                const FullType(BuiltList, const [const FullType(double)])));
    }
    return result;
  }

  @override
  Res_LocationResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new Res_LocationResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'coordinates':
          result.coordinates.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(double)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$FullReservationResponse extends FullReservationResponse {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final String email;
  @override
  final bool is_active;
  @override
  final int original_price;
  @override
  final String payment_intent_id;
  @override
  final String phone_number;
  @override
  final BuiltList<ProductAndQuantityResponse> products;
  @override
  final ShowTimeFullResponse show_time;
  @override
  final int total_price;
  @override
  final DateTime updatedAt;
  @override
  final UserResponse user;
  @override
  final BuiltList<TicketResponse> tickets;
  @override
  final PromotionResponse promotion_id;

  factory _$FullReservationResponse(
          [void Function(FullReservationResponseBuilder) updates]) =>
      (new FullReservationResponseBuilder()..update(updates)).build();

  _$FullReservationResponse._(
      {this.id,
      this.createdAt,
      this.email,
      this.is_active,
      this.original_price,
      this.payment_intent_id,
      this.phone_number,
      this.products,
      this.show_time,
      this.total_price,
      this.updatedAt,
      this.user,
      this.tickets,
      this.promotion_id})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('FullReservationResponse', 'id');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError(
          'FullReservationResponse', 'createdAt');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('FullReservationResponse', 'email');
    }
    if (original_price == null) {
      throw new BuiltValueNullFieldError(
          'FullReservationResponse', 'original_price');
    }
    if (payment_intent_id == null) {
      throw new BuiltValueNullFieldError(
          'FullReservationResponse', 'payment_intent_id');
    }
    if (phone_number == null) {
      throw new BuiltValueNullFieldError(
          'FullReservationResponse', 'phone_number');
    }
    if (products == null) {
      throw new BuiltValueNullFieldError('FullReservationResponse', 'products');
    }
    if (show_time == null) {
      throw new BuiltValueNullFieldError(
          'FullReservationResponse', 'show_time');
    }
    if (total_price == null) {
      throw new BuiltValueNullFieldError(
          'FullReservationResponse', 'total_price');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError(
          'FullReservationResponse', 'updatedAt');
    }
    if (user == null) {
      throw new BuiltValueNullFieldError('FullReservationResponse', 'user');
    }
    if (tickets == null) {
      throw new BuiltValueNullFieldError('FullReservationResponse', 'tickets');
    }
  }

  @override
  FullReservationResponse rebuild(
          void Function(FullReservationResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FullReservationResponseBuilder toBuilder() =>
      new FullReservationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FullReservationResponse &&
        id == other.id &&
        createdAt == other.createdAt &&
        email == other.email &&
        is_active == other.is_active &&
        original_price == other.original_price &&
        payment_intent_id == other.payment_intent_id &&
        phone_number == other.phone_number &&
        products == other.products &&
        show_time == other.show_time &&
        total_price == other.total_price &&
        updatedAt == other.updatedAt &&
        user == other.user &&
        tickets == other.tickets &&
        promotion_id == other.promotion_id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc($jc(0, id.hashCode),
                                                        createdAt.hashCode),
                                                    email.hashCode),
                                                is_active.hashCode),
                                            original_price.hashCode),
                                        payment_intent_id.hashCode),
                                    phone_number.hashCode),
                                products.hashCode),
                            show_time.hashCode),
                        total_price.hashCode),
                    updatedAt.hashCode),
                user.hashCode),
            tickets.hashCode),
        promotion_id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FullReservationResponse')
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('email', email)
          ..add('is_active', is_active)
          ..add('original_price', original_price)
          ..add('payment_intent_id', payment_intent_id)
          ..add('phone_number', phone_number)
          ..add('products', products)
          ..add('show_time', show_time)
          ..add('total_price', total_price)
          ..add('updatedAt', updatedAt)
          ..add('user', user)
          ..add('tickets', tickets)
          ..add('promotion_id', promotion_id))
        .toString();
  }
}

class FullReservationResponseBuilder
    implements
        Builder<FullReservationResponse, FullReservationResponseBuilder> {
  _$FullReservationResponse _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  bool _is_active;
  bool get is_active => _$this._is_active;
  set is_active(bool is_active) => _$this._is_active = is_active;

  int _original_price;
  int get original_price => _$this._original_price;
  set original_price(int original_price) =>
      _$this._original_price = original_price;

  String _payment_intent_id;
  String get payment_intent_id => _$this._payment_intent_id;
  set payment_intent_id(String payment_intent_id) =>
      _$this._payment_intent_id = payment_intent_id;

  String _phone_number;
  String get phone_number => _$this._phone_number;
  set phone_number(String phone_number) => _$this._phone_number = phone_number;

  ListBuilder<ProductAndQuantityResponse> _products;
  ListBuilder<ProductAndQuantityResponse> get products =>
      _$this._products ??= new ListBuilder<ProductAndQuantityResponse>();
  set products(ListBuilder<ProductAndQuantityResponse> products) =>
      _$this._products = products;

  ShowTimeFullResponseBuilder _show_time;
  ShowTimeFullResponseBuilder get show_time =>
      _$this._show_time ??= new ShowTimeFullResponseBuilder();
  set show_time(ShowTimeFullResponseBuilder show_time) =>
      _$this._show_time = show_time;

  int _total_price;
  int get total_price => _$this._total_price;
  set total_price(int total_price) => _$this._total_price = total_price;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  UserResponse _user;
  UserResponse get user => _$this._user;
  set user(UserResponse user) => _$this._user = user;

  ListBuilder<TicketResponse> _tickets;
  ListBuilder<TicketResponse> get tickets =>
      _$this._tickets ??= new ListBuilder<TicketResponse>();
  set tickets(ListBuilder<TicketResponse> tickets) => _$this._tickets = tickets;

  PromotionResponseBuilder _promotion_id;
  PromotionResponseBuilder get promotion_id =>
      _$this._promotion_id ??= new PromotionResponseBuilder();
  set promotion_id(PromotionResponseBuilder promotion_id) =>
      _$this._promotion_id = promotion_id;

  FullReservationResponseBuilder();

  FullReservationResponseBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _createdAt = _$v.createdAt;
      _email = _$v.email;
      _is_active = _$v.is_active;
      _original_price = _$v.original_price;
      _payment_intent_id = _$v.payment_intent_id;
      _phone_number = _$v.phone_number;
      _products = _$v.products?.toBuilder();
      _show_time = _$v.show_time?.toBuilder();
      _total_price = _$v.total_price;
      _updatedAt = _$v.updatedAt;
      _user = _$v.user;
      _tickets = _$v.tickets?.toBuilder();
      _promotion_id = _$v.promotion_id?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FullReservationResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FullReservationResponse;
  }

  @override
  void update(void Function(FullReservationResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FullReservationResponse build() {
    _$FullReservationResponse _$result;
    try {
      _$result = _$v ??
          new _$FullReservationResponse._(
              id: id,
              createdAt: createdAt,
              email: email,
              is_active: is_active,
              original_price: original_price,
              payment_intent_id: payment_intent_id,
              phone_number: phone_number,
              products: products.build(),
              show_time: show_time.build(),
              total_price: total_price,
              updatedAt: updatedAt,
              user: user,
              tickets: tickets.build(),
              promotion_id: _promotion_id?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'products';
        products.build();
        _$failedField = 'show_time';
        show_time.build();

        _$failedField = 'tickets';
        tickets.build();
        _$failedField = 'promotion_id';
        _promotion_id?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'FullReservationResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProductAndQuantityResponse extends ProductAndQuantityResponse {
  @override
  final ProductResponse product;
  @override
  final int quantity;

  factory _$ProductAndQuantityResponse(
          [void Function(ProductAndQuantityResponseBuilder) updates]) =>
      (new ProductAndQuantityResponseBuilder()..update(updates)).build();

  _$ProductAndQuantityResponse._({this.product, this.quantity}) : super._() {
    if (product == null) {
      throw new BuiltValueNullFieldError(
          'ProductAndQuantityResponse', 'product');
    }
    if (quantity == null) {
      throw new BuiltValueNullFieldError(
          'ProductAndQuantityResponse', 'quantity');
    }
  }

  @override
  ProductAndQuantityResponse rebuild(
          void Function(ProductAndQuantityResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductAndQuantityResponseBuilder toBuilder() =>
      new ProductAndQuantityResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductAndQuantityResponse &&
        product == other.product &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, product.hashCode), quantity.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ProductAndQuantityResponse')
          ..add('product', product)
          ..add('quantity', quantity))
        .toString();
  }
}

class ProductAndQuantityResponseBuilder
    implements
        Builder<ProductAndQuantityResponse, ProductAndQuantityResponseBuilder> {
  _$ProductAndQuantityResponse _$v;

  ProductResponseBuilder _product;
  ProductResponseBuilder get product =>
      _$this._product ??= new ProductResponseBuilder();
  set product(ProductResponseBuilder product) => _$this._product = product;

  int _quantity;
  int get quantity => _$this._quantity;
  set quantity(int quantity) => _$this._quantity = quantity;

  ProductAndQuantityResponseBuilder();

  ProductAndQuantityResponseBuilder get _$this {
    if (_$v != null) {
      _product = _$v.product?.toBuilder();
      _quantity = _$v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductAndQuantityResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ProductAndQuantityResponse;
  }

  @override
  void update(void Function(ProductAndQuantityResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ProductAndQuantityResponse build() {
    _$ProductAndQuantityResponse _$result;
    try {
      _$result = _$v ??
          new _$ProductAndQuantityResponse._(
              product: product.build(), quantity: quantity);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'product';
        product.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ProductAndQuantityResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ShowTimeFullResponse extends ShowTimeFullResponse {
  @override
  final String id;
  @override
  final bool is_active;
  @override
  final Res_MovieResponse movie;
  @override
  final Res_TheatreResponse theatre;
  @override
  final String room;
  @override
  final DateTime end_time;
  @override
  final DateTime start_time;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$ShowTimeFullResponse(
          [void Function(ShowTimeFullResponseBuilder) updates]) =>
      (new ShowTimeFullResponseBuilder()..update(updates)).build();

  _$ShowTimeFullResponse._(
      {this.id,
      this.is_active,
      this.movie,
      this.theatre,
      this.room,
      this.end_time,
      this.start_time,
      this.createdAt,
      this.updatedAt})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('ShowTimeFullResponse', 'id');
    }
    if (movie == null) {
      throw new BuiltValueNullFieldError('ShowTimeFullResponse', 'movie');
    }
    if (theatre == null) {
      throw new BuiltValueNullFieldError('ShowTimeFullResponse', 'theatre');
    }
    if (room == null) {
      throw new BuiltValueNullFieldError('ShowTimeFullResponse', 'room');
    }
    if (end_time == null) {
      throw new BuiltValueNullFieldError('ShowTimeFullResponse', 'end_time');
    }
    if (start_time == null) {
      throw new BuiltValueNullFieldError('ShowTimeFullResponse', 'start_time');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('ShowTimeFullResponse', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('ShowTimeFullResponse', 'updatedAt');
    }
  }

  @override
  ShowTimeFullResponse rebuild(
          void Function(ShowTimeFullResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ShowTimeFullResponseBuilder toBuilder() =>
      new ShowTimeFullResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShowTimeFullResponse &&
        id == other.id &&
        is_active == other.is_active &&
        movie == other.movie &&
        theatre == other.theatre &&
        room == other.room &&
        end_time == other.end_time &&
        start_time == other.start_time &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc($jc(0, id.hashCode), is_active.hashCode),
                                movie.hashCode),
                            theatre.hashCode),
                        room.hashCode),
                    end_time.hashCode),
                start_time.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ShowTimeFullResponse')
          ..add('id', id)
          ..add('is_active', is_active)
          ..add('movie', movie)
          ..add('theatre', theatre)
          ..add('room', room)
          ..add('end_time', end_time)
          ..add('start_time', start_time)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ShowTimeFullResponseBuilder
    implements Builder<ShowTimeFullResponse, ShowTimeFullResponseBuilder> {
  _$ShowTimeFullResponse _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  bool _is_active;
  bool get is_active => _$this._is_active;
  set is_active(bool is_active) => _$this._is_active = is_active;

  Res_MovieResponseBuilder _movie;
  Res_MovieResponseBuilder get movie =>
      _$this._movie ??= new Res_MovieResponseBuilder();
  set movie(Res_MovieResponseBuilder movie) => _$this._movie = movie;

  Res_TheatreResponseBuilder _theatre;
  Res_TheatreResponseBuilder get theatre =>
      _$this._theatre ??= new Res_TheatreResponseBuilder();
  set theatre(Res_TheatreResponseBuilder theatre) => _$this._theatre = theatre;

  String _room;
  String get room => _$this._room;
  set room(String room) => _$this._room = room;

  DateTime _end_time;
  DateTime get end_time => _$this._end_time;
  set end_time(DateTime end_time) => _$this._end_time = end_time;

  DateTime _start_time;
  DateTime get start_time => _$this._start_time;
  set start_time(DateTime start_time) => _$this._start_time = start_time;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  ShowTimeFullResponseBuilder();

  ShowTimeFullResponseBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _is_active = _$v.is_active;
      _movie = _$v.movie?.toBuilder();
      _theatre = _$v.theatre?.toBuilder();
      _room = _$v.room;
      _end_time = _$v.end_time;
      _start_time = _$v.start_time;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShowTimeFullResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ShowTimeFullResponse;
  }

  @override
  void update(void Function(ShowTimeFullResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ShowTimeFullResponse build() {
    _$ShowTimeFullResponse _$result;
    try {
      _$result = _$v ??
          new _$ShowTimeFullResponse._(
              id: id,
              is_active: is_active,
              movie: movie.build(),
              theatre: theatre.build(),
              room: room,
              end_time: end_time,
              start_time: start_time,
              createdAt: createdAt,
              updatedAt: updatedAt);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'movie';
        movie.build();
        _$failedField = 'theatre';
        theatre.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ShowTimeFullResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Res_MovieResponse extends Res_MovieResponse {
  @override
  final String id;
  @override
  final bool is_active;
  @override
  final BuiltList<String> actors;
  @override
  final BuiltList<String> directors;
  @override
  final String title;
  @override
  final String trailer_video_url;
  @override
  final String poster_url;
  @override
  final String overview;
  @override
  final DateTime released_date;
  @override
  final int duration;
  @override
  final String original_language;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String age_type;
  @override
  final double rate_star;
  @override
  final int total_favorite;
  @override
  final int total_rate;

  factory _$Res_MovieResponse(
          [void Function(Res_MovieResponseBuilder) updates]) =>
      (new Res_MovieResponseBuilder()..update(updates)).build();

  _$Res_MovieResponse._(
      {this.id,
      this.is_active,
      this.actors,
      this.directors,
      this.title,
      this.trailer_video_url,
      this.poster_url,
      this.overview,
      this.released_date,
      this.duration,
      this.original_language,
      this.createdAt,
      this.updatedAt,
      this.age_type,
      this.rate_star,
      this.total_favorite,
      this.total_rate})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Res_MovieResponse', 'id');
    }
    if (actors == null) {
      throw new BuiltValueNullFieldError('Res_MovieResponse', 'actors');
    }
    if (directors == null) {
      throw new BuiltValueNullFieldError('Res_MovieResponse', 'directors');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Res_MovieResponse', 'title');
    }
    if (released_date == null) {
      throw new BuiltValueNullFieldError('Res_MovieResponse', 'released_date');
    }
    if (duration == null) {
      throw new BuiltValueNullFieldError('Res_MovieResponse', 'duration');
    }
    if (original_language == null) {
      throw new BuiltValueNullFieldError(
          'Res_MovieResponse', 'original_language');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Res_MovieResponse', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('Res_MovieResponse', 'updatedAt');
    }
    if (age_type == null) {
      throw new BuiltValueNullFieldError('Res_MovieResponse', 'age_type');
    }
    if (rate_star == null) {
      throw new BuiltValueNullFieldError('Res_MovieResponse', 'rate_star');
    }
    if (total_favorite == null) {
      throw new BuiltValueNullFieldError('Res_MovieResponse', 'total_favorite');
    }
    if (total_rate == null) {
      throw new BuiltValueNullFieldError('Res_MovieResponse', 'total_rate');
    }
  }

  @override
  Res_MovieResponse rebuild(void Function(Res_MovieResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Res_MovieResponseBuilder toBuilder() =>
      new Res_MovieResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Res_MovieResponse &&
        id == other.id &&
        is_active == other.is_active &&
        actors == other.actors &&
        directors == other.directors &&
        title == other.title &&
        trailer_video_url == other.trailer_video_url &&
        poster_url == other.poster_url &&
        overview == other.overview &&
        released_date == other.released_date &&
        duration == other.duration &&
        original_language == other.original_language &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        age_type == other.age_type &&
        rate_star == other.rate_star &&
        total_favorite == other.total_favorite &&
        total_rate == other.total_rate;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        0,
                                                                        id
                                                                            .hashCode),
                                                                    is_active
                                                                        .hashCode),
                                                                actors
                                                                    .hashCode),
                                                            directors.hashCode),
                                                        title.hashCode),
                                                    trailer_video_url.hashCode),
                                                poster_url.hashCode),
                                            overview.hashCode),
                                        released_date.hashCode),
                                    duration.hashCode),
                                original_language.hashCode),
                            createdAt.hashCode),
                        updatedAt.hashCode),
                    age_type.hashCode),
                rate_star.hashCode),
            total_favorite.hashCode),
        total_rate.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Res_MovieResponse')
          ..add('id', id)
          ..add('is_active', is_active)
          ..add('actors', actors)
          ..add('directors', directors)
          ..add('title', title)
          ..add('trailer_video_url', trailer_video_url)
          ..add('poster_url', poster_url)
          ..add('overview', overview)
          ..add('released_date', released_date)
          ..add('duration', duration)
          ..add('original_language', original_language)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('age_type', age_type)
          ..add('rate_star', rate_star)
          ..add('total_favorite', total_favorite)
          ..add('total_rate', total_rate))
        .toString();
  }
}

class Res_MovieResponseBuilder
    implements Builder<Res_MovieResponse, Res_MovieResponseBuilder> {
  _$Res_MovieResponse _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  bool _is_active;
  bool get is_active => _$this._is_active;
  set is_active(bool is_active) => _$this._is_active = is_active;

  ListBuilder<String> _actors;
  ListBuilder<String> get actors =>
      _$this._actors ??= new ListBuilder<String>();
  set actors(ListBuilder<String> actors) => _$this._actors = actors;

  ListBuilder<String> _directors;
  ListBuilder<String> get directors =>
      _$this._directors ??= new ListBuilder<String>();
  set directors(ListBuilder<String> directors) => _$this._directors = directors;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _trailer_video_url;
  String get trailer_video_url => _$this._trailer_video_url;
  set trailer_video_url(String trailer_video_url) =>
      _$this._trailer_video_url = trailer_video_url;

  String _poster_url;
  String get poster_url => _$this._poster_url;
  set poster_url(String poster_url) => _$this._poster_url = poster_url;

  String _overview;
  String get overview => _$this._overview;
  set overview(String overview) => _$this._overview = overview;

  DateTime _released_date;
  DateTime get released_date => _$this._released_date;
  set released_date(DateTime released_date) =>
      _$this._released_date = released_date;

  int _duration;
  int get duration => _$this._duration;
  set duration(int duration) => _$this._duration = duration;

  String _original_language;
  String get original_language => _$this._original_language;
  set original_language(String original_language) =>
      _$this._original_language = original_language;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  String _age_type;
  String get age_type => _$this._age_type;
  set age_type(String age_type) => _$this._age_type = age_type;

  double _rate_star;
  double get rate_star => _$this._rate_star;
  set rate_star(double rate_star) => _$this._rate_star = rate_star;

  int _total_favorite;
  int get total_favorite => _$this._total_favorite;
  set total_favorite(int total_favorite) =>
      _$this._total_favorite = total_favorite;

  int _total_rate;
  int get total_rate => _$this._total_rate;
  set total_rate(int total_rate) => _$this._total_rate = total_rate;

  Res_MovieResponseBuilder();

  Res_MovieResponseBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _is_active = _$v.is_active;
      _actors = _$v.actors?.toBuilder();
      _directors = _$v.directors?.toBuilder();
      _title = _$v.title;
      _trailer_video_url = _$v.trailer_video_url;
      _poster_url = _$v.poster_url;
      _overview = _$v.overview;
      _released_date = _$v.released_date;
      _duration = _$v.duration;
      _original_language = _$v.original_language;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _age_type = _$v.age_type;
      _rate_star = _$v.rate_star;
      _total_favorite = _$v.total_favorite;
      _total_rate = _$v.total_rate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Res_MovieResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Res_MovieResponse;
  }

  @override
  void update(void Function(Res_MovieResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Res_MovieResponse build() {
    _$Res_MovieResponse _$result;
    try {
      _$result = _$v ??
          new _$Res_MovieResponse._(
              id: id,
              is_active: is_active,
              actors: actors.build(),
              directors: directors.build(),
              title: title,
              trailer_video_url: trailer_video_url,
              poster_url: poster_url,
              overview: overview,
              released_date: released_date,
              duration: duration,
              original_language: original_language,
              createdAt: createdAt,
              updatedAt: updatedAt,
              age_type: age_type,
              rate_star: rate_star,
              total_favorite: total_favorite,
              total_rate: total_rate);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'actors';
        actors.build();
        _$failedField = 'directors';
        directors.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Res_MovieResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Res_TheatreResponse extends Res_TheatreResponse {
  @override
  final String id;
  @override
  final Res_LocationResponse location;
  @override
  final bool is_active;
  @override
  final BuiltList<String> rooms;
  @override
  final String name;
  @override
  final String address;
  @override
  final String phone_number;
  @override
  final String description;
  @override
  final String email;
  @override
  final String opening_hours;
  @override
  final String room_summary;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final double distance;
  @override
  final String thumbnail;
  @override
  final String cover;

  factory _$Res_TheatreResponse(
          [void Function(Res_TheatreResponseBuilder) updates]) =>
      (new Res_TheatreResponseBuilder()..update(updates)).build();

  _$Res_TheatreResponse._(
      {this.id,
      this.location,
      this.is_active,
      this.rooms,
      this.name,
      this.address,
      this.phone_number,
      this.description,
      this.email,
      this.opening_hours,
      this.room_summary,
      this.createdAt,
      this.updatedAt,
      this.distance,
      this.thumbnail,
      this.cover})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Res_TheatreResponse', 'id');
    }
    if (location == null) {
      throw new BuiltValueNullFieldError('Res_TheatreResponse', 'location');
    }
    if (rooms == null) {
      throw new BuiltValueNullFieldError('Res_TheatreResponse', 'rooms');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Res_TheatreResponse', 'name');
    }
    if (address == null) {
      throw new BuiltValueNullFieldError('Res_TheatreResponse', 'address');
    }
    if (phone_number == null) {
      throw new BuiltValueNullFieldError('Res_TheatreResponse', 'phone_number');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('Res_TheatreResponse', 'description');
    }
    if (opening_hours == null) {
      throw new BuiltValueNullFieldError(
          'Res_TheatreResponse', 'opening_hours');
    }
    if (room_summary == null) {
      throw new BuiltValueNullFieldError('Res_TheatreResponse', 'room_summary');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Res_TheatreResponse', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('Res_TheatreResponse', 'updatedAt');
    }
  }

  @override
  Res_TheatreResponse rebuild(
          void Function(Res_TheatreResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Res_TheatreResponseBuilder toBuilder() =>
      new Res_TheatreResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Res_TheatreResponse &&
        id == other.id &&
        location == other.location &&
        is_active == other.is_active &&
        rooms == other.rooms &&
        name == other.name &&
        address == other.address &&
        phone_number == other.phone_number &&
        description == other.description &&
        email == other.email &&
        opening_hours == other.opening_hours &&
        room_summary == other.room_summary &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        distance == other.distance &&
        thumbnail == other.thumbnail &&
        cover == other.cover;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    0,
                                                                    id
                                                                        .hashCode),
                                                                location
                                                                    .hashCode),
                                                            is_active.hashCode),
                                                        rooms.hashCode),
                                                    name.hashCode),
                                                address.hashCode),
                                            phone_number.hashCode),
                                        description.hashCode),
                                    email.hashCode),
                                opening_hours.hashCode),
                            room_summary.hashCode),
                        createdAt.hashCode),
                    updatedAt.hashCode),
                distance.hashCode),
            thumbnail.hashCode),
        cover.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Res_TheatreResponse')
          ..add('id', id)
          ..add('location', location)
          ..add('is_active', is_active)
          ..add('rooms', rooms)
          ..add('name', name)
          ..add('address', address)
          ..add('phone_number', phone_number)
          ..add('description', description)
          ..add('email', email)
          ..add('opening_hours', opening_hours)
          ..add('room_summary', room_summary)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('distance', distance)
          ..add('thumbnail', thumbnail)
          ..add('cover', cover))
        .toString();
  }
}

class Res_TheatreResponseBuilder
    implements Builder<Res_TheatreResponse, Res_TheatreResponseBuilder> {
  _$Res_TheatreResponse _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  Res_LocationResponseBuilder _location;
  Res_LocationResponseBuilder get location =>
      _$this._location ??= new Res_LocationResponseBuilder();
  set location(Res_LocationResponseBuilder location) =>
      _$this._location = location;

  bool _is_active;
  bool get is_active => _$this._is_active;
  set is_active(bool is_active) => _$this._is_active = is_active;

  ListBuilder<String> _rooms;
  ListBuilder<String> get rooms => _$this._rooms ??= new ListBuilder<String>();
  set rooms(ListBuilder<String> rooms) => _$this._rooms = rooms;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _address;
  String get address => _$this._address;
  set address(String address) => _$this._address = address;

  String _phone_number;
  String get phone_number => _$this._phone_number;
  set phone_number(String phone_number) => _$this._phone_number = phone_number;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _opening_hours;
  String get opening_hours => _$this._opening_hours;
  set opening_hours(String opening_hours) =>
      _$this._opening_hours = opening_hours;

  String _room_summary;
  String get room_summary => _$this._room_summary;
  set room_summary(String room_summary) => _$this._room_summary = room_summary;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  double _distance;
  double get distance => _$this._distance;
  set distance(double distance) => _$this._distance = distance;

  String _thumbnail;
  String get thumbnail => _$this._thumbnail;
  set thumbnail(String thumbnail) => _$this._thumbnail = thumbnail;

  String _cover;
  String get cover => _$this._cover;
  set cover(String cover) => _$this._cover = cover;

  Res_TheatreResponseBuilder();

  Res_TheatreResponseBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _location = _$v.location?.toBuilder();
      _is_active = _$v.is_active;
      _rooms = _$v.rooms?.toBuilder();
      _name = _$v.name;
      _address = _$v.address;
      _phone_number = _$v.phone_number;
      _description = _$v.description;
      _email = _$v.email;
      _opening_hours = _$v.opening_hours;
      _room_summary = _$v.room_summary;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _distance = _$v.distance;
      _thumbnail = _$v.thumbnail;
      _cover = _$v.cover;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Res_TheatreResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Res_TheatreResponse;
  }

  @override
  void update(void Function(Res_TheatreResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Res_TheatreResponse build() {
    _$Res_TheatreResponse _$result;
    try {
      _$result = _$v ??
          new _$Res_TheatreResponse._(
              id: id,
              location: location.build(),
              is_active: is_active,
              rooms: rooms.build(),
              name: name,
              address: address,
              phone_number: phone_number,
              description: description,
              email: email,
              opening_hours: opening_hours,
              room_summary: room_summary,
              createdAt: createdAt,
              updatedAt: updatedAt,
              distance: distance,
              thumbnail: thumbnail,
              cover: cover);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'location';
        location.build();

        _$failedField = 'rooms';
        rooms.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Res_TheatreResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Res_LocationResponse extends Res_LocationResponse {
  @override
  final BuiltList<double> coordinates;

  factory _$Res_LocationResponse(
          [void Function(Res_LocationResponseBuilder) updates]) =>
      (new Res_LocationResponseBuilder()..update(updates)).build();

  _$Res_LocationResponse._({this.coordinates}) : super._();

  @override
  Res_LocationResponse rebuild(
          void Function(Res_LocationResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Res_LocationResponseBuilder toBuilder() =>
      new Res_LocationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Res_LocationResponse && coordinates == other.coordinates;
  }

  @override
  int get hashCode {
    return $jf($jc(0, coordinates.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Res_LocationResponse')
          ..add('coordinates', coordinates))
        .toString();
  }
}

class Res_LocationResponseBuilder
    implements Builder<Res_LocationResponse, Res_LocationResponseBuilder> {
  _$Res_LocationResponse _$v;

  ListBuilder<double> _coordinates;
  ListBuilder<double> get coordinates =>
      _$this._coordinates ??= new ListBuilder<double>();
  set coordinates(ListBuilder<double> coordinates) =>
      _$this._coordinates = coordinates;

  Res_LocationResponseBuilder();

  Res_LocationResponseBuilder get _$this {
    if (_$v != null) {
      _coordinates = _$v.coordinates?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Res_LocationResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Res_LocationResponse;
  }

  @override
  void update(void Function(Res_LocationResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Res_LocationResponse build() {
    _$Res_LocationResponse _$result;
    try {
      _$result = _$v ??
          new _$Res_LocationResponse._(coordinates: _coordinates?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'coordinates';
        _coordinates?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Res_LocationResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
