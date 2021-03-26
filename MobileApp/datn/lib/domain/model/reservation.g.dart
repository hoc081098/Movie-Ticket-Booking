// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductAndQuantity extends ProductAndQuantity {
  @override
  final String id;
  @override
  final Product? product;
  @override
  final int quantity;

  factory _$ProductAndQuantity(
          [void Function(ProductAndQuantityBuilder)? updates]) =>
      (new ProductAndQuantityBuilder()..update(updates)).build();

  _$ProductAndQuantity._(
      {required this.id, this.product, required this.quantity})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'ProductAndQuantity', 'id');
    BuiltValueNullFieldError.checkNotNull(
        quantity, 'ProductAndQuantity', 'quantity');
  }

  @override
  ProductAndQuantity rebuild(
          void Function(ProductAndQuantityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductAndQuantityBuilder toBuilder() =>
      new ProductAndQuantityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductAndQuantity &&
        id == other.id &&
        product == other.product &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, id.hashCode), product.hashCode), quantity.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ProductAndQuantity')
          ..add('id', id)
          ..add('product', product)
          ..add('quantity', quantity))
        .toString();
  }
}

class ProductAndQuantityBuilder
    implements Builder<ProductAndQuantity, ProductAndQuantityBuilder> {
  _$ProductAndQuantity? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ProductBuilder? _product;
  ProductBuilder get product => _$this._product ??= new ProductBuilder();
  set product(ProductBuilder? product) => _$this._product = product;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  ProductAndQuantityBuilder();

  ProductAndQuantityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _product = $v.product?.toBuilder();
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductAndQuantity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProductAndQuantity;
  }

  @override
  void update(void Function(ProductAndQuantityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ProductAndQuantity build() {
    _$ProductAndQuantity _$result;
    try {
      _$result = _$v ??
          new _$ProductAndQuantity._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, 'ProductAndQuantity', 'id'),
              product: _product?.build(),
              quantity: BuiltValueNullFieldError.checkNotNull(
                  quantity, 'ProductAndQuantity', 'quantity'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'product';
        _product?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ProductAndQuantity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Reservation extends Reservation {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final String email;
  @override
  final bool isActive;
  @override
  final int originalPrice;
  @override
  final String paymentIntentId;
  @override
  final String phoneNumber;
  @override
  final BuiltList<ProductAndQuantity> productIdWithCounts;
  @override
  final String showTimeId;
  @override
  final ShowTime? showTime;
  @override
  final int totalPrice;
  @override
  final DateTime updatedAt;
  @override
  final User? user;
  @override
  final BuiltList<Ticket>? tickets;
  @override
  final String? promotionId;
  @override
  final Promotion? promotion;

  factory _$Reservation([void Function(ReservationBuilder)? updates]) =>
      (new ReservationBuilder()..update(updates)).build();

  _$Reservation._(
      {required this.id,
      required this.createdAt,
      required this.email,
      required this.isActive,
      required this.originalPrice,
      required this.paymentIntentId,
      required this.phoneNumber,
      required this.productIdWithCounts,
      required this.showTimeId,
      this.showTime,
      required this.totalPrice,
      required this.updatedAt,
      this.user,
      this.tickets,
      this.promotionId,
      this.promotion})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'Reservation', 'id');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'Reservation', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(email, 'Reservation', 'email');
    BuiltValueNullFieldError.checkNotNull(isActive, 'Reservation', 'isActive');
    BuiltValueNullFieldError.checkNotNull(
        originalPrice, 'Reservation', 'originalPrice');
    BuiltValueNullFieldError.checkNotNull(
        paymentIntentId, 'Reservation', 'paymentIntentId');
    BuiltValueNullFieldError.checkNotNull(
        phoneNumber, 'Reservation', 'phoneNumber');
    BuiltValueNullFieldError.checkNotNull(
        productIdWithCounts, 'Reservation', 'productIdWithCounts');
    BuiltValueNullFieldError.checkNotNull(
        showTimeId, 'Reservation', 'showTimeId');
    BuiltValueNullFieldError.checkNotNull(
        totalPrice, 'Reservation', 'totalPrice');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'Reservation', 'updatedAt');
  }

  @override
  Reservation rebuild(void Function(ReservationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReservationBuilder toBuilder() => new ReservationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Reservation &&
        id == other.id &&
        createdAt == other.createdAt &&
        email == other.email &&
        isActive == other.isActive &&
        originalPrice == other.originalPrice &&
        paymentIntentId == other.paymentIntentId &&
        phoneNumber == other.phoneNumber &&
        productIdWithCounts == other.productIdWithCounts &&
        showTimeId == other.showTimeId &&
        showTime == other.showTime &&
        totalPrice == other.totalPrice &&
        updatedAt == other.updatedAt &&
        user == other.user &&
        tickets == other.tickets &&
        promotionId == other.promotionId &&
        promotion == other.promotion;
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
                                                                createdAt
                                                                    .hashCode),
                                                            email.hashCode),
                                                        isActive.hashCode),
                                                    originalPrice.hashCode),
                                                paymentIntentId.hashCode),
                                            phoneNumber.hashCode),
                                        productIdWithCounts.hashCode),
                                    showTimeId.hashCode),
                                showTime.hashCode),
                            totalPrice.hashCode),
                        updatedAt.hashCode),
                    user.hashCode),
                tickets.hashCode),
            promotionId.hashCode),
        promotion.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Reservation')
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('email', email)
          ..add('isActive', isActive)
          ..add('originalPrice', originalPrice)
          ..add('paymentIntentId', paymentIntentId)
          ..add('phoneNumber', phoneNumber)
          ..add('productIdWithCounts', productIdWithCounts)
          ..add('showTimeId', showTimeId)
          ..add('showTime', showTime)
          ..add('totalPrice', totalPrice)
          ..add('updatedAt', updatedAt)
          ..add('user', user)
          ..add('tickets', tickets)
          ..add('promotionId', promotionId)
          ..add('promotion', promotion))
        .toString();
  }
}

class ReservationBuilder implements Builder<Reservation, ReservationBuilder> {
  _$Reservation? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  int? _originalPrice;
  int? get originalPrice => _$this._originalPrice;
  set originalPrice(int? originalPrice) =>
      _$this._originalPrice = originalPrice;

  String? _paymentIntentId;
  String? get paymentIntentId => _$this._paymentIntentId;
  set paymentIntentId(String? paymentIntentId) =>
      _$this._paymentIntentId = paymentIntentId;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  ListBuilder<ProductAndQuantity>? _productIdWithCounts;
  ListBuilder<ProductAndQuantity> get productIdWithCounts =>
      _$this._productIdWithCounts ??= new ListBuilder<ProductAndQuantity>();
  set productIdWithCounts(
          ListBuilder<ProductAndQuantity>? productIdWithCounts) =>
      _$this._productIdWithCounts = productIdWithCounts;

  String? _showTimeId;
  String? get showTimeId => _$this._showTimeId;
  set showTimeId(String? showTimeId) => _$this._showTimeId = showTimeId;

  ShowTimeBuilder? _showTime;
  ShowTimeBuilder get showTime => _$this._showTime ??= new ShowTimeBuilder();
  set showTime(ShowTimeBuilder? showTime) => _$this._showTime = showTime;

  int? _totalPrice;
  int? get totalPrice => _$this._totalPrice;
  set totalPrice(int? totalPrice) => _$this._totalPrice = totalPrice;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  ListBuilder<Ticket>? _tickets;
  ListBuilder<Ticket> get tickets =>
      _$this._tickets ??= new ListBuilder<Ticket>();
  set tickets(ListBuilder<Ticket>? tickets) => _$this._tickets = tickets;

  String? _promotionId;
  String? get promotionId => _$this._promotionId;
  set promotionId(String? promotionId) => _$this._promotionId = promotionId;

  PromotionBuilder? _promotion;
  PromotionBuilder get promotion =>
      _$this._promotion ??= new PromotionBuilder();
  set promotion(PromotionBuilder? promotion) => _$this._promotion = promotion;

  ReservationBuilder();

  ReservationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _createdAt = $v.createdAt;
      _email = $v.email;
      _isActive = $v.isActive;
      _originalPrice = $v.originalPrice;
      _paymentIntentId = $v.paymentIntentId;
      _phoneNumber = $v.phoneNumber;
      _productIdWithCounts = $v.productIdWithCounts.toBuilder();
      _showTimeId = $v.showTimeId;
      _showTime = $v.showTime?.toBuilder();
      _totalPrice = $v.totalPrice;
      _updatedAt = $v.updatedAt;
      _user = $v.user?.toBuilder();
      _tickets = $v.tickets?.toBuilder();
      _promotionId = $v.promotionId;
      _promotion = $v.promotion?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Reservation other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Reservation;
  }

  @override
  void update(void Function(ReservationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Reservation build() {
    _$Reservation _$result;
    try {
      _$result = _$v ??
          new _$Reservation._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, 'Reservation', 'id'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, 'Reservation', 'createdAt'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, 'Reservation', 'email'),
              isActive: BuiltValueNullFieldError.checkNotNull(
                  isActive, 'Reservation', 'isActive'),
              originalPrice: BuiltValueNullFieldError.checkNotNull(
                  originalPrice, 'Reservation', 'originalPrice'),
              paymentIntentId: BuiltValueNullFieldError.checkNotNull(
                  paymentIntentId, 'Reservation', 'paymentIntentId'),
              phoneNumber: BuiltValueNullFieldError.checkNotNull(
                  phoneNumber, 'Reservation', 'phoneNumber'),
              productIdWithCounts: productIdWithCounts.build(),
              showTimeId: BuiltValueNullFieldError.checkNotNull(
                  showTimeId, 'Reservation', 'showTimeId'),
              showTime: _showTime?.build(),
              totalPrice: BuiltValueNullFieldError.checkNotNull(
                  totalPrice, 'Reservation', 'totalPrice'),
              updatedAt:
                  BuiltValueNullFieldError.checkNotNull(updatedAt, 'Reservation', 'updatedAt'),
              user: _user?.build(),
              tickets: _tickets?.build(),
              promotionId: promotionId,
              promotion: _promotion?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'productIdWithCounts';
        productIdWithCounts.build();

        _$failedField = 'showTime';
        _showTime?.build();

        _$failedField = 'user';
        _user?.build();
        _$failedField = 'tickets';
        _tickets?.build();

        _$failedField = 'promotion';
        _promotion?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Reservation', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
