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

  factory _$Promotion([void Function(PromotionBuilder)? updates]) =>
      (new PromotionBuilder()..update(updates)).build();

  _$Promotion._(
      {required this.id,
      required this.code,
      required this.discount,
      required this.endTime,
      required this.isActive,
      required this.name,
      required this.startTime,
      required this.creator,
      required this.showTime,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'Promotion', 'id');
    BuiltValueNullFieldError.checkNotNull(code, 'Promotion', 'code');
    BuiltValueNullFieldError.checkNotNull(discount, 'Promotion', 'discount');
    BuiltValueNullFieldError.checkNotNull(endTime, 'Promotion', 'endTime');
    BuiltValueNullFieldError.checkNotNull(isActive, 'Promotion', 'isActive');
    BuiltValueNullFieldError.checkNotNull(name, 'Promotion', 'name');
    BuiltValueNullFieldError.checkNotNull(startTime, 'Promotion', 'startTime');
    BuiltValueNullFieldError.checkNotNull(creator, 'Promotion', 'creator');
    BuiltValueNullFieldError.checkNotNull(showTime, 'Promotion', 'showTime');
    BuiltValueNullFieldError.checkNotNull(createdAt, 'Promotion', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(updatedAt, 'Promotion', 'updatedAt');
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
  _$Promotion? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  double? _discount;
  double? get discount => _$this._discount;
  set discount(double? discount) => _$this._discount = discount;

  DateTime? _endTime;
  DateTime? get endTime => _$this._endTime;
  set endTime(DateTime? endTime) => _$this._endTime = endTime;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _startTime;
  DateTime? get startTime => _$this._startTime;
  set startTime(DateTime? startTime) => _$this._startTime = startTime;

  String? _creator;
  String? get creator => _$this._creator;
  set creator(String? creator) => _$this._creator = creator;

  String? _showTime;
  String? get showTime => _$this._showTime;
  set showTime(String? showTime) => _$this._showTime = showTime;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  PromotionBuilder();

  PromotionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _discount = $v.discount;
      _endTime = $v.endTime;
      _isActive = $v.isActive;
      _name = $v.name;
      _startTime = $v.startTime;
      _creator = $v.creator;
      _showTime = $v.showTime;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Promotion other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Promotion;
  }

  @override
  void update(void Function(PromotionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Promotion build() {
    final _$result = _$v ??
        new _$Promotion._(
            id: BuiltValueNullFieldError.checkNotNull(id, 'Promotion', 'id'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, 'Promotion', 'code'),
            discount: BuiltValueNullFieldError.checkNotNull(
                discount, 'Promotion', 'discount'),
            endTime: BuiltValueNullFieldError.checkNotNull(
                endTime, 'Promotion', 'endTime'),
            isActive: BuiltValueNullFieldError.checkNotNull(
                isActive, 'Promotion', 'isActive'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'Promotion', 'name'),
            startTime: BuiltValueNullFieldError.checkNotNull(
                startTime, 'Promotion', 'startTime'),
            creator: BuiltValueNullFieldError.checkNotNull(
                creator, 'Promotion', 'creator'),
            showTime: BuiltValueNullFieldError.checkNotNull(
                showTime, 'Promotion', 'showTime'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, 'Promotion', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, 'Promotion', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
