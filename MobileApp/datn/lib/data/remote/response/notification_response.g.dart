// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NotificationResponse> _$notificationResponseSerializer =
    new _$NotificationResponseSerializer();
Serializer<NotificationResponse_ReservationResponse>
    _$notificationResponseReservationResponseSerializer =
    new _$NotificationResponse_ReservationResponseSerializer();

class _$NotificationResponseSerializer
    implements StructuredSerializer<NotificationResponse> {
  @override
  final Iterable<Type> types = const [
    NotificationResponse,
    _$NotificationResponse
  ];
  @override
  final String wireName = 'NotificationResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, NotificationResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'body',
      serializers.serialize(object.body, specifiedType: const FullType(String)),
      'to_user',
      serializers.serialize(object.to_user,
          specifiedType: const FullType(String)),
      'reservation',
      serializers.serialize(object.reservation,
          specifiedType:
              const FullType(NotificationResponse_ReservationResponse)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(DateTime)),
    ];

    return result;
  }

  @override
  NotificationResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationResponseBuilder();

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
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'body':
          result.body = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'to_user':
          result.to_user = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'reservation':
          result.reservation.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(NotificationResponse_ReservationResponse))!
              as NotificationResponse_ReservationResponse);
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

class _$NotificationResponse_ReservationResponseSerializer
    implements StructuredSerializer<NotificationResponse_ReservationResponse> {
  @override
  final Iterable<Type> types = const [
    NotificationResponse_ReservationResponse,
    _$NotificationResponse_ReservationResponse
  ];
  @override
  final String wireName = 'NotificationResponse_ReservationResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, NotificationResponse_ReservationResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'original_price',
      serializers.serialize(object.original_price,
          specifiedType: const FullType(int)),
      'phone_number',
      serializers.serialize(object.phone_number,
          specifiedType: const FullType(String)),
      'products',
      serializers.serialize(object.products,
          specifiedType: const FullType(
              BuiltList, const [const FullType(ProductIdAndQuantity)])),
      'total_price',
      serializers.serialize(object.total_price,
          specifiedType: const FullType(int)),
      'show_time',
      serializers.serialize(object.show_time,
          specifiedType: const FullType(ShowTimeFullResponse)),
      'user',
      serializers.serialize(object.user, specifiedType: const FullType(String)),
      'payment_intent_id',
      serializers.serialize(object.payment_intent_id,
          specifiedType: const FullType(String)),
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
  NotificationResponse_ReservationResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationResponse_ReservationResponseBuilder();

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
        case 'total_price':
          result.total_price = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'show_time':
          result.show_time.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ShowTimeFullResponse))!
              as ShowTimeFullResponse);
          break;
        case 'user':
          result.user = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'payment_intent_id':
          result.payment_intent_id = serializers.deserialize(value,
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
      }
    }

    return result.build();
  }
}

class _$NotificationResponse extends NotificationResponse {
  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  final String to_user;
  @override
  final NotificationResponse_ReservationResponse reservation;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$NotificationResponse(
          [void Function(NotificationResponseBuilder)? updates]) =>
      (new NotificationResponseBuilder()..update(updates)).build();

  _$NotificationResponse._(
      {required this.id,
      required this.title,
      required this.body,
      required this.to_user,
      required this.reservation,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'NotificationResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        title, 'NotificationResponse', 'title');
    BuiltValueNullFieldError.checkNotNull(body, 'NotificationResponse', 'body');
    BuiltValueNullFieldError.checkNotNull(
        to_user, 'NotificationResponse', 'to_user');
    BuiltValueNullFieldError.checkNotNull(
        reservation, 'NotificationResponse', 'reservation');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'NotificationResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'NotificationResponse', 'updatedAt');
  }

  @override
  NotificationResponse rebuild(
          void Function(NotificationResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationResponseBuilder toBuilder() =>
      new NotificationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationResponse &&
        id == other.id &&
        title == other.title &&
        body == other.body &&
        to_user == other.to_user &&
        reservation == other.reservation &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, id.hashCode), title.hashCode),
                        body.hashCode),
                    to_user.hashCode),
                reservation.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('NotificationResponse')
          ..add('id', id)
          ..add('title', title)
          ..add('body', body)
          ..add('to_user', to_user)
          ..add('reservation', reservation)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class NotificationResponseBuilder
    implements Builder<NotificationResponse, NotificationResponseBuilder> {
  _$NotificationResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  String? _to_user;
  String? get to_user => _$this._to_user;
  set to_user(String? to_user) => _$this._to_user = to_user;

  NotificationResponse_ReservationResponseBuilder? _reservation;
  NotificationResponse_ReservationResponseBuilder get reservation =>
      _$this._reservation ??=
          new NotificationResponse_ReservationResponseBuilder();
  set reservation(
          NotificationResponse_ReservationResponseBuilder? reservation) =>
      _$this._reservation = reservation;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  NotificationResponseBuilder();

  NotificationResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _body = $v.body;
      _to_user = $v.to_user;
      _reservation = $v.reservation.toBuilder();
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationResponse;
  }

  @override
  void update(void Function(NotificationResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$NotificationResponse build() {
    _$NotificationResponse _$result;
    try {
      _$result = _$v ??
          new _$NotificationResponse._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, 'NotificationResponse', 'id'),
              title: BuiltValueNullFieldError.checkNotNull(
                  title, 'NotificationResponse', 'title'),
              body: BuiltValueNullFieldError.checkNotNull(
                  body, 'NotificationResponse', 'body'),
              to_user: BuiltValueNullFieldError.checkNotNull(
                  to_user, 'NotificationResponse', 'to_user'),
              reservation: reservation.build(),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, 'NotificationResponse', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, 'NotificationResponse', 'updatedAt'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reservation';
        reservation.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'NotificationResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$NotificationResponse_ReservationResponse
    extends NotificationResponse_ReservationResponse {
  @override
  final String id;
  @override
  final String email;
  @override
  final bool? is_active;
  @override
  final int original_price;
  @override
  final String phone_number;
  @override
  final BuiltList<ProductIdAndQuantity> products;
  @override
  final int total_price;
  @override
  final ShowTimeFullResponse show_time;
  @override
  final String user;
  @override
  final String payment_intent_id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$NotificationResponse_ReservationResponse(
          [void Function(NotificationResponse_ReservationResponseBuilder)?
              updates]) =>
      (new NotificationResponse_ReservationResponseBuilder()..update(updates))
          .build();

  _$NotificationResponse_ReservationResponse._(
      {required this.id,
      required this.email,
      this.is_active,
      required this.original_price,
      required this.phone_number,
      required this.products,
      required this.total_price,
      required this.show_time,
      required this.user,
      required this.payment_intent_id,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        id, 'NotificationResponse_ReservationResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        email, 'NotificationResponse_ReservationResponse', 'email');
    BuiltValueNullFieldError.checkNotNull(original_price,
        'NotificationResponse_ReservationResponse', 'original_price');
    BuiltValueNullFieldError.checkNotNull(phone_number,
        'NotificationResponse_ReservationResponse', 'phone_number');
    BuiltValueNullFieldError.checkNotNull(
        products, 'NotificationResponse_ReservationResponse', 'products');
    BuiltValueNullFieldError.checkNotNull(
        total_price, 'NotificationResponse_ReservationResponse', 'total_price');
    BuiltValueNullFieldError.checkNotNull(
        show_time, 'NotificationResponse_ReservationResponse', 'show_time');
    BuiltValueNullFieldError.checkNotNull(
        user, 'NotificationResponse_ReservationResponse', 'user');
    BuiltValueNullFieldError.checkNotNull(payment_intent_id,
        'NotificationResponse_ReservationResponse', 'payment_intent_id');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'NotificationResponse_ReservationResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'NotificationResponse_ReservationResponse', 'updatedAt');
  }

  @override
  NotificationResponse_ReservationResponse rebuild(
          void Function(NotificationResponse_ReservationResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationResponse_ReservationResponseBuilder toBuilder() =>
      new NotificationResponse_ReservationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationResponse_ReservationResponse &&
        id == other.id &&
        email == other.email &&
        is_active == other.is_active &&
        original_price == other.original_price &&
        phone_number == other.phone_number &&
        products == other.products &&
        total_price == other.total_price &&
        show_time == other.show_time &&
        user == other.user &&
        payment_intent_id == other.payment_intent_id &&
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
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc($jc(0, id.hashCode),
                                                email.hashCode),
                                            is_active.hashCode),
                                        original_price.hashCode),
                                    phone_number.hashCode),
                                products.hashCode),
                            total_price.hashCode),
                        show_time.hashCode),
                    user.hashCode),
                payment_intent_id.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            'NotificationResponse_ReservationResponse')
          ..add('id', id)
          ..add('email', email)
          ..add('is_active', is_active)
          ..add('original_price', original_price)
          ..add('phone_number', phone_number)
          ..add('products', products)
          ..add('total_price', total_price)
          ..add('show_time', show_time)
          ..add('user', user)
          ..add('payment_intent_id', payment_intent_id)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class NotificationResponse_ReservationResponseBuilder
    implements
        Builder<NotificationResponse_ReservationResponse,
            NotificationResponse_ReservationResponseBuilder> {
  _$NotificationResponse_ReservationResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  String? _phone_number;
  String? get phone_number => _$this._phone_number;
  set phone_number(String? phone_number) => _$this._phone_number = phone_number;

  ListBuilder<ProductIdAndQuantity>? _products;
  ListBuilder<ProductIdAndQuantity> get products =>
      _$this._products ??= new ListBuilder<ProductIdAndQuantity>();
  set products(ListBuilder<ProductIdAndQuantity>? products) =>
      _$this._products = products;

  int? _total_price;
  int? get total_price => _$this._total_price;
  set total_price(int? total_price) => _$this._total_price = total_price;

  ShowTimeFullResponseBuilder? _show_time;
  ShowTimeFullResponseBuilder get show_time =>
      _$this._show_time ??= new ShowTimeFullResponseBuilder();
  set show_time(ShowTimeFullResponseBuilder? show_time) =>
      _$this._show_time = show_time;

  String? _user;
  String? get user => _$this._user;
  set user(String? user) => _$this._user = user;

  String? _payment_intent_id;
  String? get payment_intent_id => _$this._payment_intent_id;
  set payment_intent_id(String? payment_intent_id) =>
      _$this._payment_intent_id = payment_intent_id;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  NotificationResponse_ReservationResponseBuilder();

  NotificationResponse_ReservationResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _email = $v.email;
      _is_active = $v.is_active;
      _original_price = $v.original_price;
      _phone_number = $v.phone_number;
      _products = $v.products.toBuilder();
      _total_price = $v.total_price;
      _show_time = $v.show_time.toBuilder();
      _user = $v.user;
      _payment_intent_id = $v.payment_intent_id;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationResponse_ReservationResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationResponse_ReservationResponse;
  }

  @override
  void update(
      void Function(NotificationResponse_ReservationResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$NotificationResponse_ReservationResponse build() {
    _$NotificationResponse_ReservationResponse _$result;
    try {
      _$result = _$v ??
          new _$NotificationResponse_ReservationResponse._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, 'NotificationResponse_ReservationResponse', 'id'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, 'NotificationResponse_ReservationResponse', 'email'),
              is_active: is_active,
              original_price: BuiltValueNullFieldError.checkNotNull(
                  original_price, 'NotificationResponse_ReservationResponse', 'original_price'),
              phone_number: BuiltValueNullFieldError.checkNotNull(
                  phone_number, 'NotificationResponse_ReservationResponse', 'phone_number'),
              products: products.build(),
              total_price: BuiltValueNullFieldError.checkNotNull(
                  total_price, 'NotificationResponse_ReservationResponse', 'total_price'),
              show_time: show_time.build(),
              user: BuiltValueNullFieldError.checkNotNull(
                  user, 'NotificationResponse_ReservationResponse', 'user'),
              payment_intent_id: BuiltValueNullFieldError.checkNotNull(
                  payment_intent_id, 'NotificationResponse_ReservationResponse', 'payment_intent_id'),
              createdAt: BuiltValueNullFieldError.checkNotNull(createdAt, 'NotificationResponse_ReservationResponse', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, 'NotificationResponse_ReservationResponse', 'updatedAt'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'products';
        products.build();

        _$failedField = 'show_time';
        show_time.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'NotificationResponse_ReservationResponse',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
