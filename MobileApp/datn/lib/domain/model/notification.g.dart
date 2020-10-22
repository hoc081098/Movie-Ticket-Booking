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

  factory _$Notification([void Function(NotificationBuilder) updates]) =>
      (new NotificationBuilder()..update(updates)).build();

  _$Notification._(
      {this.id,
      this.title,
      this.body,
      this.to_user,
      this.reservation,
      this.createdAt,
      this.updatedAt})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Notification', 'id');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Notification', 'title');
    }
    if (body == null) {
      throw new BuiltValueNullFieldError('Notification', 'body');
    }
    if (to_user == null) {
      throw new BuiltValueNullFieldError('Notification', 'to_user');
    }
    if (reservation == null) {
      throw new BuiltValueNullFieldError('Notification', 'reservation');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Notification', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('Notification', 'updatedAt');
    }
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
  _$Notification _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _body;
  String get body => _$this._body;
  set body(String body) => _$this._body = body;

  String _to_user;
  String get to_user => _$this._to_user;
  set to_user(String to_user) => _$this._to_user = to_user;

  ReservationBuilder _reservation;
  ReservationBuilder get reservation =>
      _$this._reservation ??= new ReservationBuilder();
  set reservation(ReservationBuilder reservation) =>
      _$this._reservation = reservation;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  NotificationBuilder();

  NotificationBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _body = _$v.body;
      _to_user = _$v.to_user;
      _reservation = _$v.reservation?.toBuilder();
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Notification other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Notification;
  }

  @override
  void update(void Function(NotificationBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Notification build() {
    _$Notification _$result;
    try {
      _$result = _$v ??
          new _$Notification._(
              id: id,
              title: title,
              body: body,
              to_user: to_user,
              reservation: reservation.build(),
              createdAt: createdAt,
              updatedAt: updatedAt);
    } catch (_) {
      String _$failedField;
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
