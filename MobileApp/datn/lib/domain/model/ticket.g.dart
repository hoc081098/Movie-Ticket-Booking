// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Ticket extends Ticket {
  @override
  final String id;
  @override
  final bool is_active;
  @override
  final int price;
  @override
  final String? reservationId;
  @override
  final Seat seat;
  @override
  final String show_time;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final Reservation? reservation;

  factory _$Ticket([void Function(TicketBuilder)? updates]) =>
      (new TicketBuilder()..update(updates)).build();

  _$Ticket._(
      {required this.id,
      required this.is_active,
      required this.price,
      this.reservationId,
      required this.seat,
      required this.show_time,
      required this.createdAt,
      required this.updatedAt,
      this.reservation})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'Ticket', 'id');
    BuiltValueNullFieldError.checkNotNull(is_active, 'Ticket', 'is_active');
    BuiltValueNullFieldError.checkNotNull(price, 'Ticket', 'price');
    BuiltValueNullFieldError.checkNotNull(seat, 'Ticket', 'seat');
    BuiltValueNullFieldError.checkNotNull(show_time, 'Ticket', 'show_time');
    BuiltValueNullFieldError.checkNotNull(createdAt, 'Ticket', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(updatedAt, 'Ticket', 'updatedAt');
  }

  @override
  Ticket rebuild(void Function(TicketBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketBuilder toBuilder() => new TicketBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Ticket &&
        id == other.id &&
        is_active == other.is_active &&
        price == other.price &&
        reservationId == other.reservationId &&
        seat == other.seat &&
        show_time == other.show_time &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        reservation == other.reservation;
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
                                price.hashCode),
                            reservationId.hashCode),
                        seat.hashCode),
                    show_time.hashCode),
                createdAt.hashCode),
            updatedAt.hashCode),
        reservation.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Ticket')
          ..add('id', id)
          ..add('is_active', is_active)
          ..add('price', price)
          ..add('reservationId', reservationId)
          ..add('seat', seat)
          ..add('show_time', show_time)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('reservation', reservation))
        .toString();
  }
}

class TicketBuilder implements Builder<Ticket, TicketBuilder> {
  _$Ticket? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _is_active;
  bool? get is_active => _$this._is_active;
  set is_active(bool? is_active) => _$this._is_active = is_active;

  int? _price;
  int? get price => _$this._price;
  set price(int? price) => _$this._price = price;

  String? _reservationId;
  String? get reservationId => _$this._reservationId;
  set reservationId(String? reservationId) =>
      _$this._reservationId = reservationId;

  SeatBuilder? _seat;
  SeatBuilder get seat => _$this._seat ??= new SeatBuilder();
  set seat(SeatBuilder? seat) => _$this._seat = seat;

  String? _show_time;
  String? get show_time => _$this._show_time;
  set show_time(String? show_time) => _$this._show_time = show_time;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ReservationBuilder? _reservation;
  ReservationBuilder get reservation =>
      _$this._reservation ??= new ReservationBuilder();
  set reservation(ReservationBuilder? reservation) =>
      _$this._reservation = reservation;

  TicketBuilder();

  TicketBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _is_active = $v.is_active;
      _price = $v.price;
      _reservationId = $v.reservationId;
      _seat = $v.seat.toBuilder();
      _show_time = $v.show_time;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _reservation = $v.reservation?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Ticket other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Ticket;
  }

  @override
  void update(void Function(TicketBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Ticket build() {
    _$Ticket _$result;
    try {
      _$result = _$v ??
          new _$Ticket._(
              id: BuiltValueNullFieldError.checkNotNull(id, 'Ticket', 'id'),
              is_active: BuiltValueNullFieldError.checkNotNull(
                  is_active, 'Ticket', 'is_active'),
              price: BuiltValueNullFieldError.checkNotNull(
                  price, 'Ticket', 'price'),
              reservationId: reservationId,
              seat: seat.build(),
              show_time: BuiltValueNullFieldError.checkNotNull(
                  show_time, 'Ticket', 'show_time'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, 'Ticket', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, 'Ticket', 'updatedAt'),
              reservation: _reservation?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'seat';
        seat.build();

        _$failedField = 'reservation';
        _reservation?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Ticket', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
