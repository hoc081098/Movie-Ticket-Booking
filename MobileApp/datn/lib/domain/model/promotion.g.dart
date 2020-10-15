// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Promotion extends Promotion {
  @override
  final String id;
  @override
  final String code;
  @override
  final double discount;
  @override
  final DateTime endTime;
  @override
  final bool isActive;
  @override
  final String name;
  @override
  final DateTime startTime;
  @override
  final String creator;
  @override
  final String showTime;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$Promotion([void Function(PromotionBuilder) updates]) =>
      (new PromotionBuilder()..update(updates)).build();

  _$Promotion._(
      {this.id,
      this.code,
      this.discount,
      this.endTime,
      this.isActive,
      this.name,
      this.startTime,
      this.creator,
      this.showTime,
      this.createdAt,
      this.updatedAt})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Promotion', 'id');
    }
    if (code == null) {
      throw new BuiltValueNullFieldError('Promotion', 'code');
    }
    if (discount == null) {
      throw new BuiltValueNullFieldError('Promotion', 'discount');
    }
    if (endTime == null) {
      throw new BuiltValueNullFieldError('Promotion', 'endTime');
    }
    if (isActive == null) {
      throw new BuiltValueNullFieldError('Promotion', 'isActive');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Promotion', 'name');
    }
    if (startTime == null) {
      throw new BuiltValueNullFieldError('Promotion', 'startTime');
    }
    if (creator == null) {
      throw new BuiltValueNullFieldError('Promotion', 'creator');
    }
    if (showTime == null) {
      throw new BuiltValueNullFieldError('Promotion', 'showTime');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Promotion', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('Promotion', 'updatedAt');
    }
  }

  @override
  Promotion rebuild(void Function(PromotionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PromotionBuilder toBuilder() => new PromotionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Promotion &&
        id == other.id &&
        code == other.code &&
        discount == other.discount &&
        endTime == other.endTime &&
        isActive == other.isActive &&
        name == other.name &&
        startTime == other.startTime &&
        creator == other.creator &&
        showTime == other.showTime &&
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
                                    $jc($jc($jc(0, id.hashCode), code.hashCode),
                                        discount.hashCode),
                                    endTime.hashCode),
                                isActive.hashCode),
                            name.hashCode),
                        startTime.hashCode),
                    creator.hashCode),
                showTime.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Promotion')
          ..add('id', id)
          ..add('code', code)
          ..add('discount', discount)
          ..add('endTime', endTime)
          ..add('isActive', isActive)
          ..add('name', name)
          ..add('startTime', startTime)
          ..add('creator', creator)
          ..add('showTime', showTime)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PromotionBuilder implements Builder<Promotion, PromotionBuilder> {
  _$Promotion _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _code;
  String get code => _$this._code;
  set code(String code) => _$this._code = code;

  double _discount;
  double get discount => _$this._discount;
  set discount(double discount) => _$this._discount = discount;

  DateTime _endTime;
  DateTime get endTime => _$this._endTime;
  set endTime(DateTime endTime) => _$this._endTime = endTime;

  bool _isActive;
  bool get isActive => _$this._isActive;
  set isActive(bool isActive) => _$this._isActive = isActive;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  DateTime _startTime;
  DateTime get startTime => _$this._startTime;
  set startTime(DateTime startTime) => _$this._startTime = startTime;

  String _creator;
  String get creator => _$this._creator;
  set creator(String creator) => _$this._creator = creator;

  String _showTime;
  String get showTime => _$this._showTime;
  set showTime(String showTime) => _$this._showTime = showTime;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  PromotionBuilder();

  PromotionBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _code = _$v.code;
      _discount = _$v.discount;
      _endTime = _$v.endTime;
      _isActive = _$v.isActive;
      _name = _$v.name;
      _startTime = _$v.startTime;
      _creator = _$v.creator;
      _showTime = _$v.showTime;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Promotion other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Promotion;
  }

  @override
  void update(void Function(PromotionBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Promotion build() {
    final _$result = _$v ??
        new _$Promotion._(
            id: id,
            code: code,
            discount: discount,
            endTime: endTime,
            isActive: isActive,
            name: name,
            startTime: startTime,
            creator: creator,
            showTime: showTime,
            createdAt: createdAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
