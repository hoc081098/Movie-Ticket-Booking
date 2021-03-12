// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ReservationResponse> _$reservationResponseSerializer =
    new _$ReservationResponseSerializer();
Serializer<ProductIdAndQuantity> _$productIdAndQuantitySerializer =
    new _$ProductIdAndQuantitySerializer();
Serializer<ShowTimeFullResponse> _$showTimeFullResponseSerializer =
    new _$ShowTimeFullResponseSerializer();

class _$ReservationResponseSerializer
    implements StructuredSerializer<ReservationResponse> {
  @override
  final Iterable<Type> types = const [
    ReservationResponse,
    _$ReservationResponse
  ];
  @override
  final String wireName = 'ReservationResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ReservationResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
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
              BuiltList, const [const FullType(ProductIdAndQuantity)])),
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
    ];
    Object? value;
    value = object.is_active;
    if (value != null) {
      result
        ..add('is_active')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  ReservationResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ReservationResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
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
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ProductIdAndQuantity)]))!
              as BuiltList<Object>);
          break;
        case 'show_time':
          result.show_time.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ShowTimeFullResponse))!
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
          result.user.replace(serializers.deserialize(value,
              specifiedType: const FullType(UserResponse))! as UserResponse);
          break;
      }
    }

    return result.build();
  }
}

class _$ProductIdAndQuantitySerializer
    implements StructuredSerializer<ProductIdAndQuantity> {
  @override
  final Iterable<Type> types = const [
    ProductIdAndQuantity,
    _$ProductIdAndQuantity
  ];
  @override
  final String wireName = 'ProductIdAndQuantity';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProductIdAndQuantity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'quantity',
      serializers.serialize(object.quantity,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  ProductIdAndQuantity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductIdAndQuantityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
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
  Iterable<Object?> serialize(
      Serializers serializers, ShowTimeFullResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'movie',
      serializers.serialize(object.movie,
          specifiedType: const FullType(MovieResponse)),
      'theatre',
      serializers.serialize(object.theatre,
          specifiedType: const FullType(TheatreResponse)),
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
    Object? value;
    value = object.is_active;
    if (value != null) {
      result
        ..add('is_active')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  ShowTimeFullResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ShowTimeFullResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
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
              specifiedType: const FullType(MovieResponse))! as MovieResponse);
          break;
        case 'theatre':
          result.theatre.replace(serializers.deserialize(value,
                  specifiedType: const FullType(TheatreResponse))!
              as TheatreResponse);
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

class _$ReservationResponse extends ReservationResponse {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final String email;
  @override
  final bool? is_active;
  @override
  final int original_price;
  @override
  final String payment_intent_id;
  @override
  final String phone_number;
  @override
  final BuiltList<ProductIdAndQuantity> products;
  @override
  final ShowTimeFullResponse show_time;
  @override
  final int total_price;
  @override
  final DateTime updatedAt;
  @override
  final UserResponse user;

  factory _$ReservationResponse(
          [void Function(ReservationResponseBuilder)? updates]) =>
      (new ReservationResponseBuilder()..update(updates)).build();

  _$ReservationResponse._(
      {required this.id,
      required this.createdAt,
      required this.email,
      this.is_active,
      required this.original_price,
      required this.payment_intent_id,
      required this.phone_number,
      required this.products,
      required this.show_time,
      required this.total_price,
      required this.updatedAt,
      required this.user})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'ReservationResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'ReservationResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        email, 'ReservationResponse', 'email');
    BuiltValueNullFieldError.checkNotNull(
        original_price, 'ReservationResponse', 'original_price');
    BuiltValueNullFieldError.checkNotNull(
        payment_intent_id, 'ReservationResponse', 'payment_intent_id');
    BuiltValueNullFieldError.checkNotNull(
        phone_number, 'ReservationResponse', 'phone_number');
    BuiltValueNullFieldError.checkNotNull(
        products, 'ReservationResponse', 'products');
    BuiltValueNullFieldError.checkNotNull(
        show_time, 'ReservationResponse', 'show_time');
    BuiltValueNullFieldError.checkNotNull(
        total_price, 'ReservationResponse', 'total_price');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'ReservationResponse', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(user, 'ReservationResponse', 'user');
  }

  @override
  ReservationResponse rebuild(
          void Function(ReservationResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReservationResponseBuilder toBuilder() =>
      new ReservationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReservationResponse &&
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
        user == other.user;
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
        user.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ReservationResponse')
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
          ..add('user', user))
        .toString();
  }
}

class ReservationResponseBuilder
    implements Builder<ReservationResponse, ReservationResponseBuilder> {
  _$ReservationResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  bool? _is_active;
  bool? get is_active => _$this._is_active;
  set is_active(bool? is_active) => _$this._is_active = is_active;

  int? _original_price;
  int? get original_price => _$this._original_price;
  set original_price(int? original_price) =>
      _$this._original_price = original_price;

  String? _payment_intent_id;
  String? get payment_intent_id => _$this._payment_intent_id;
  set payment_intent_id(String? payment_intent_id) =>
      _$this._payment_intent_id = payment_intent_id;

  String? _phone_number;
  String? get phone_number => _$this._phone_number;
  set phone_number(String? phone_number) => _$this._phone_number = phone_number;

  ListBuilder<ProductIdAndQuantity>? _products;
  ListBuilder<ProductIdAndQuantity> get products =>
      _$this._products ??= new ListBuilder<ProductIdAndQuantity>();
  set products(ListBuilder<ProductIdAndQuantity>? products) =>
      _$this._products = products;

  ShowTimeFullResponseBuilder? _show_time;
  ShowTimeFullResponseBuilder get show_time =>
      _$this._show_time ??= new ShowTimeFullResponseBuilder();
  set show_time(ShowTimeFullResponseBuilder? show_time) =>
      _$this._show_time = show_time;

  int? _total_price;
  int? get total_price => _$this._total_price;
  set total_price(int? total_price) => _$this._total_price = total_price;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= new UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  ReservationResponseBuilder();

  ReservationResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _createdAt = $v.createdAt;
      _email = $v.email;
      _is_active = $v.is_active;
      _original_price = $v.original_price;
      _payment_intent_id = $v.payment_intent_id;
      _phone_number = $v.phone_number;
      _products = $v.products.toBuilder();
      _show_time = $v.show_time.toBuilder();
      _total_price = $v.total_price;
      _updatedAt = $v.updatedAt;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReservationResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ReservationResponse;
  }

  @override
  void update(void Function(ReservationResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ReservationResponse build() {
    _$ReservationResponse _$result;
    try {
      _$result = _$v ??
          new _$ReservationResponse._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, 'ReservationResponse', 'id'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, 'ReservationResponse', 'createdAt'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, 'ReservationResponse', 'email'),
              is_active: is_active,
              original_price: BuiltValueNullFieldError.checkNotNull(
                  original_price, 'ReservationResponse', 'original_price'),
              payment_intent_id: BuiltValueNullFieldError.checkNotNull(
                  payment_intent_id, 'ReservationResponse', 'payment_intent_id'),
              phone_number: BuiltValueNullFieldError.checkNotNull(
                  phone_number, 'ReservationResponse', 'phone_number'),
              products: products.build(),
              show_time: show_time.build(),
              total_price: BuiltValueNullFieldError.checkNotNull(
                  total_price, 'ReservationResponse', 'total_price'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, 'ReservationResponse', 'updatedAt'),
              user: user.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'products';
        products.build();
        _$failedField = 'show_time';
        show_time.build();

        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ReservationResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ProductIdAndQuantity extends ProductIdAndQuantity {
  @override
  final String id;
  @override
  final int quantity;

  factory _$ProductIdAndQuantity(
          [void Function(ProductIdAndQuantityBuilder)? updates]) =>
      (new ProductIdAndQuantityBuilder()..update(updates)).build();

  _$ProductIdAndQuantity._({required this.id, required this.quantity})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'ProductIdAndQuantity', 'id');
    BuiltValueNullFieldError.checkNotNull(
        quantity, 'ProductIdAndQuantity', 'quantity');
  }

  @override
  ProductIdAndQuantity rebuild(
          void Function(ProductIdAndQuantityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductIdAndQuantityBuilder toBuilder() =>
      new ProductIdAndQuantityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductIdAndQuantity &&
        id == other.id &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, id.hashCode), quantity.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ProductIdAndQuantity')
          ..add('id', id)
          ..add('quantity', quantity))
        .toString();
  }
}

class ProductIdAndQuantityBuilder
    implements Builder<ProductIdAndQuantity, ProductIdAndQuantityBuilder> {
  _$ProductIdAndQuantity? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  ProductIdAndQuantityBuilder();

  ProductIdAndQuantityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductIdAndQuantity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProductIdAndQuantity;
  }

  @override
  void update(void Function(ProductIdAndQuantityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ProductIdAndQuantity build() {
    final _$result = _$v ??
        new _$ProductIdAndQuantity._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, 'ProductIdAndQuantity', 'id'),
            quantity: BuiltValueNullFieldError.checkNotNull(
                quantity, 'ProductIdAndQuantity', 'quantity'));
    replace(_$result);
    return _$result;
  }
}

class _$ShowTimeFullResponse extends ShowTimeFullResponse {
  @override
  final String id;
  @override
  final bool? is_active;
  @override
  final MovieResponse movie;
  @override
  final TheatreResponse theatre;
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
          [void Function(ShowTimeFullResponseBuilder)? updates]) =>
      (new ShowTimeFullResponseBuilder()..update(updates)).build();

  _$ShowTimeFullResponse._(
      {required this.id,
      this.is_active,
      required this.movie,
      required this.theatre,
      required this.room,
      required this.end_time,
      required this.start_time,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'ShowTimeFullResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        movie, 'ShowTimeFullResponse', 'movie');
    BuiltValueNullFieldError.checkNotNull(
        theatre, 'ShowTimeFullResponse', 'theatre');
    BuiltValueNullFieldError.checkNotNull(room, 'ShowTimeFullResponse', 'room');
    BuiltValueNullFieldError.checkNotNull(
        end_time, 'ShowTimeFullResponse', 'end_time');
    BuiltValueNullFieldError.checkNotNull(
        start_time, 'ShowTimeFullResponse', 'start_time');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'ShowTimeFullResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'ShowTimeFullResponse', 'updatedAt');
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
  _$ShowTimeFullResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _is_active;
  bool? get is_active => _$this._is_active;
  set is_active(bool? is_active) => _$this._is_active = is_active;

  MovieResponseBuilder? _movie;
  MovieResponseBuilder get movie =>
      _$this._movie ??= new MovieResponseBuilder();
  set movie(MovieResponseBuilder? movie) => _$this._movie = movie;

  TheatreResponseBuilder? _theatre;
  TheatreResponseBuilder get theatre =>
      _$this._theatre ??= new TheatreResponseBuilder();
  set theatre(TheatreResponseBuilder? theatre) => _$this._theatre = theatre;

  String? _room;
  String? get room => _$this._room;
  set room(String? room) => _$this._room = room;

  DateTime? _end_time;
  DateTime? get end_time => _$this._end_time;
  set end_time(DateTime? end_time) => _$this._end_time = end_time;

  DateTime? _start_time;
  DateTime? get start_time => _$this._start_time;
  set start_time(DateTime? start_time) => _$this._start_time = start_time;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ShowTimeFullResponseBuilder();

  ShowTimeFullResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _is_active = $v.is_active;
      _movie = $v.movie.toBuilder();
      _theatre = $v.theatre.toBuilder();
      _room = $v.room;
      _end_time = $v.end_time;
      _start_time = $v.start_time;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShowTimeFullResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ShowTimeFullResponse;
  }

  @override
  void update(void Function(ShowTimeFullResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ShowTimeFullResponse build() {
    _$ShowTimeFullResponse _$result;
    try {
      _$result = _$v ??
          new _$ShowTimeFullResponse._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, 'ShowTimeFullResponse', 'id'),
              is_active: is_active,
              movie: movie.build(),
              theatre: theatre.build(),
              room: BuiltValueNullFieldError.checkNotNull(
                  room, 'ShowTimeFullResponse', 'room'),
              end_time: BuiltValueNullFieldError.checkNotNull(
                  end_time, 'ShowTimeFullResponse', 'end_time'),
              start_time: BuiltValueNullFieldError.checkNotNull(
                  start_time, 'ShowTimeFullResponse', 'start_time'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, 'ShowTimeFullResponse', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, 'ShowTimeFullResponse', 'updatedAt'));
    } catch (_) {
      late String _$failedField;
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

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
