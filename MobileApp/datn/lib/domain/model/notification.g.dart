// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Notification extends Notification {
  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  final String to_user;
  @override
  final Reservation reservation;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$Notification([void Function(NotificationBuilder)? updates]) =>
      (new NotificationBuilder()..update(updates)).build();

  _$Notification._(
      {required this.id,
      required this.title,
      required this.body,
      required this.to_user,
      required this.reservation,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'Notification', 'id');
    BuiltValueNullFieldError.checkNotNull(title, 'Notification', 'title');
    BuiltValueNullFieldError.checkNotNull(body, 'Notification', 'body');
    BuiltValueNullFieldError.checkNotNull(to_user, 'Notification', 'to_user');
    BuiltValueNullFieldError.checkNotNull(
        reservation, 'Notification', 'reservation');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'Notification', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'Notification', 'updatedAt');
  }

  @override
  Notification rebuild(void Function(NotificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationBuilder toBuilder() => new NotificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Notification &&
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
    return (newBuiltValueToStringHelper('Notification')
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

class NotificationBuilder
    implements Builder<Notification, NotificationBuilder> {
  _$Notification? _$v;

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

  ReservationBuilder? _reservation;
  ReservationBuilder get reservation =>
      _$this._reservation ??= new ReservationBuilder();
  set reservation(ReservationBuilder? reservation) =>
      _$this._reservation = reservation;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  NotificationBuilder();

  NotificationBuilder get _$this {
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
  void replace(Notification other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Notification;
  }

  @override
  void update(void Function(NotificationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Notification build() {
    _$Notification _$result;
    try {
      _$result = _$v ??
          new _$Notification._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, 'Notification', 'id'),
              title: BuiltValueNullFieldError.checkNotNull(
                  title, 'Notification', 'title'),
              body: BuiltValueNullFieldError.checkNotNull(
                  body, 'Notification', 'body'),
              to_user: BuiltValueNullFieldError.checkNotNull(
                  to_user, 'Notification', 'to_user'),
              reservation: reservation.build(),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, 'Notification', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, 'Notification', 'updatedAt'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reservation';
        reservation.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Notification', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
