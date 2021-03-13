// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PromotionResponse> _$promotionResponseSerializer =
    new _$PromotionResponseSerializer();

class _$PromotionResponseSerializer
    implements StructuredSerializer<PromotionResponse> {
  @override
  final Iterable<Type> types = const [PromotionResponse, _$PromotionResponse];
  @override
  final String wireName = 'PromotionResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, PromotionResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'code',
      serializers.serialize(object.code, specifiedType: const FullType(String)),
      'discount',
      serializers.serialize(object.discount,
          specifiedType: const FullType(double)),
      'end_time',
      serializers.serialize(object.end_time,
          specifiedType: const FullType(DateTime)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'start_time',
      serializers.serialize(object.start_time,
          specifiedType: const FullType(DateTime)),
      'creator',
      serializers.serialize(object.creator,
          specifiedType: const FullType(String)),
      'show_time',
      serializers.serialize(object.show_time,
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
  PromotionResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PromotionResponseBuilder();

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
        case 'code':
          result.code = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'discount':
          result.discount = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'end_time':
          result.end_time = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'is_active':
          result.is_active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'start_time':
          result.start_time = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'creator':
          result.creator = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'show_time':
          result.show_time = serializers.deserialize(value,
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

class _$PromotionResponse extends PromotionResponse {
  @override
  final String id;
  @override
  final String code;
  @override
  final double discount;
  @override
  final DateTime end_time;
  @override
  final bool? is_active;
  @override
  final String name;
  @override
  final DateTime start_time;
  @override
  final String creator;
  @override
  final String show_time;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$PromotionResponse(
          [void Function(PromotionResponseBuilder)? updates]) =>
      (new PromotionResponseBuilder()..update(updates)).build();

  _$PromotionResponse._(
      {required this.id,
      required this.code,
      required this.discount,
      required this.end_time,
      this.is_active,
      required this.name,
      required this.start_time,
      required this.creator,
      required this.show_time,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'PromotionResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(code, 'PromotionResponse', 'code');
    BuiltValueNullFieldError.checkNotNull(
        discount, 'PromotionResponse', 'discount');
    BuiltValueNullFieldError.checkNotNull(
        end_time, 'PromotionResponse', 'end_time');
    BuiltValueNullFieldError.checkNotNull(name, 'PromotionResponse', 'name');
    BuiltValueNullFieldError.checkNotNull(
        start_time, 'PromotionResponse', 'start_time');
    BuiltValueNullFieldError.checkNotNull(
        creator, 'PromotionResponse', 'creator');
    BuiltValueNullFieldError.checkNotNull(
        show_time, 'PromotionResponse', 'show_time');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'PromotionResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'PromotionResponse', 'updatedAt');
  }

  @override
  PromotionResponse rebuild(void Function(PromotionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PromotionResponseBuilder toBuilder() =>
      new PromotionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PromotionResponse &&
        id == other.id &&
        code == other.code &&
        discount == other.discount &&
        end_time == other.end_time &&
        is_active == other.is_active &&
        name == other.name &&
        start_time == other.start_time &&
        creator == other.creator &&
        show_time == other.show_time &&
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
                                    end_time.hashCode),
                                is_active.hashCode),
                            name.hashCode),
                        start_time.hashCode),
                    creator.hashCode),
                show_time.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PromotionResponse')
          ..add('id', id)
          ..add('code', code)
          ..add('discount', discount)
          ..add('end_time', end_time)
          ..add('is_active', is_active)
          ..add('name', name)
          ..add('start_time', start_time)
          ..add('creator', creator)
          ..add('show_time', show_time)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PromotionResponseBuilder
    implements Builder<PromotionResponse, PromotionResponseBuilder> {
  _$PromotionResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  double? _discount;
  double? get discount => _$this._discount;
  set discount(double? discount) => _$this._discount = discount;

  DateTime? _end_time;
  DateTime? get end_time => _$this._end_time;
  set end_time(DateTime? end_time) => _$this._end_time = end_time;

  bool? _is_active;
  bool? get is_active => _$this._is_active;
  set is_active(bool? is_active) => _$this._is_active = is_active;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _start_time;
  DateTime? get start_time => _$this._start_time;
  set start_time(DateTime? start_time) => _$this._start_time = start_time;

  String? _creator;
  String? get creator => _$this._creator;
  set creator(String? creator) => _$this._creator = creator;

  String? _show_time;
  String? get show_time => _$this._show_time;
  set show_time(String? show_time) => _$this._show_time = show_time;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  PromotionResponseBuilder();

  PromotionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _discount = $v.discount;
      _end_time = $v.end_time;
      _is_active = $v.is_active;
      _name = $v.name;
      _start_time = $v.start_time;
      _creator = $v.creator;
      _show_time = $v.show_time;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PromotionResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PromotionResponse;
  }

  @override
  void update(void Function(PromotionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PromotionResponse build() {
    final _$result = _$v ??
        new _$PromotionResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, 'PromotionResponse', 'id'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, 'PromotionResponse', 'code'),
            discount: BuiltValueNullFieldError.checkNotNull(
                discount, 'PromotionResponse', 'discount'),
            end_time: BuiltValueNullFieldError.checkNotNull(
                end_time, 'PromotionResponse', 'end_time'),
            is_active: is_active,
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'PromotionResponse', 'name'),
            start_time: BuiltValueNullFieldError.checkNotNull(
                start_time, 'PromotionResponse', 'start_time'),
            creator: BuiltValueNullFieldError.checkNotNull(
                creator, 'PromotionResponse', 'creator'),
            show_time: BuiltValueNullFieldError.checkNotNull(
                show_time, 'PromotionResponse', 'show_time'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, 'PromotionResponse', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, 'PromotionResponse', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
