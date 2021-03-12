// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_reservation_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FullReservationResponse> _$fullReservationResponseSerializer =
    new _$FullReservationResponseSerializer();
Serializer<ProductAndQuantityResponse> _$productAndQuantityResponseSerializer =
    new _$ProductAndQuantityResponseSerializer();

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
  Iterable<Object?> serialize(
      Serializers serializers, FullReservationResponse object,
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
      serializers.serialize(object.user, specifiedType: const FullType(String)),
      'tickets',
      serializers.serialize(object.tickets,
          specifiedType: const FullType(
              BuiltList, const [const FullType(TicketResponse)])),
    ];
    Object? value;
    value = object.is_active;
    if (value != null) {
      result
        ..add('is_active')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.promotion_id;
    if (value != null) {
      result
        ..add('promotion_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(PromotionResponse)));
    }
    return result;
  }

  @override
  FullReservationResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FullReservationResponseBuilder();

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
              specifiedType: const FullType(BuiltList, const [
                const FullType(ProductAndQuantityResponse)
              ]))! as BuiltList<Object>);
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
          result.user = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'tickets':
          result.tickets.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(TicketResponse)]))!
              as BuiltList<Object>);
          break;
        case 'promotion_id':
          result.promotion_id.replace(serializers.deserialize(value,
                  specifiedType: const FullType(PromotionResponse))!
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
  Iterable<Object?> serialize(
      Serializers serializers, ProductAndQuantityResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
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
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductAndQuantityResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'product_id':
          result.product.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ProductResponse))!
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

class _$FullReservationResponse extends FullReservationResponse {
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
  final BuiltList<ProductAndQuantityResponse> products;
  @override
  final ShowTimeFullResponse show_time;
  @override
  final int total_price;
  @override
  final DateTime updatedAt;
  @override
  final String user;
  @override
  final BuiltList<TicketResponse> tickets;
  @override
  final PromotionResponse? promotion_id;

  factory _$FullReservationResponse(
          [void Function(FullReservationResponseBuilder)? updates]) =>
      (new FullReservationResponseBuilder()..update(updates)).build();

  _$FullReservationResponse._(
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
      required this.user,
      required this.tickets,
      this.promotion_id})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'FullReservationResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'FullReservationResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        email, 'FullReservationResponse', 'email');
    BuiltValueNullFieldError.checkNotNull(
        original_price, 'FullReservationResponse', 'original_price');
    BuiltValueNullFieldError.checkNotNull(
        payment_intent_id, 'FullReservationResponse', 'payment_intent_id');
    BuiltValueNullFieldError.checkNotNull(
        phone_number, 'FullReservationResponse', 'phone_number');
    BuiltValueNullFieldError.checkNotNull(
        products, 'FullReservationResponse', 'products');
    BuiltValueNullFieldError.checkNotNull(
        show_time, 'FullReservationResponse', 'show_time');
    BuiltValueNullFieldError.checkNotNull(
        total_price, 'FullReservationResponse', 'total_price');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'FullReservationResponse', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        user, 'FullReservationResponse', 'user');
    BuiltValueNullFieldError.checkNotNull(
        tickets, 'FullReservationResponse', 'tickets');
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
  _$FullReservationResponse? _$v;

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

  ListBuilder<ProductAndQuantityResponse>? _products;
  ListBuilder<ProductAndQuantityResponse> get products =>
      _$this._products ??= new ListBuilder<ProductAndQuantityResponse>();
  set products(ListBuilder<ProductAndQuantityResponse>? products) =>
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

  String? _user;
  String? get user => _$this._user;
  set user(String? user) => _$this._user = user;

  ListBuilder<TicketResponse>? _tickets;
  ListBuilder<TicketResponse> get tickets =>
      _$this._tickets ??= new ListBuilder<TicketResponse>();
  set tickets(ListBuilder<TicketResponse>? tickets) =>
      _$this._tickets = tickets;

  PromotionResponseBuilder? _promotion_id;
  PromotionResponseBuilder get promotion_id =>
      _$this._promotion_id ??= new PromotionResponseBuilder();
  set promotion_id(PromotionResponseBuilder? promotion_id) =>
      _$this._promotion_id = promotion_id;

  FullReservationResponseBuilder();

  FullReservationResponseBuilder get _$this {
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
      _user = $v.user;
      _tickets = $v.tickets.toBuilder();
      _promotion_id = $v.promotion_id?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FullReservationResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FullReservationResponse;
  }

  @override
  void update(void Function(FullReservationResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FullReservationResponse build() {
    _$FullReservationResponse _$result;
    try {
      _$result = _$v ??
          new _$FullReservationResponse._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, 'FullReservationResponse', 'id'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, 'FullReservationResponse', 'createdAt'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, 'FullReservationResponse', 'email'),
              is_active: is_active,
              original_price: BuiltValueNullFieldError.checkNotNull(
                  original_price, 'FullReservationResponse', 'original_price'),
              payment_intent_id: BuiltValueNullFieldError.checkNotNull(
                  payment_intent_id, 'FullReservationResponse', 'payment_intent_id'),
              phone_number: BuiltValueNullFieldError.checkNotNull(
                  phone_number, 'FullReservationResponse', 'phone_number'),
              products: products.build(),
              show_time: show_time.build(),
              total_price: BuiltValueNullFieldError.checkNotNull(
                  total_price, 'FullReservationResponse', 'total_price'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, 'FullReservationResponse', 'updatedAt'),
              user: BuiltValueNullFieldError.checkNotNull(user, 'FullReservationResponse', 'user'),
              tickets: tickets.build(),
              promotion_id: _promotion_id?.build());
    } catch (_) {
      late String _$failedField;
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
          [void Function(ProductAndQuantityResponseBuilder)? updates]) =>
      (new ProductAndQuantityResponseBuilder()..update(updates)).build();

  _$ProductAndQuantityResponse._(
      {required this.product, required this.quantity})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        product, 'ProductAndQuantityResponse', 'product');
    BuiltValueNullFieldError.checkNotNull(
        quantity, 'ProductAndQuantityResponse', 'quantity');
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
  _$ProductAndQuantityResponse? _$v;

  ProductResponseBuilder? _product;
  ProductResponseBuilder get product =>
      _$this._product ??= new ProductResponseBuilder();
  set product(ProductResponseBuilder? product) => _$this._product = product;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  ProductAndQuantityResponseBuilder();

  ProductAndQuantityResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _product = $v.product.toBuilder();
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductAndQuantityResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProductAndQuantityResponse;
  }

  @override
  void update(void Function(ProductAndQuantityResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ProductAndQuantityResponse build() {
    _$ProductAndQuantityResponse _$result;
    try {
      _$result = _$v ??
          new _$ProductAndQuantityResponse._(
              product: product.build(),
              quantity: BuiltValueNullFieldError.checkNotNull(
                  quantity, 'ProductAndQuantityResponse', 'quantity'));
    } catch (_) {
      late String _$failedField;
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

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
