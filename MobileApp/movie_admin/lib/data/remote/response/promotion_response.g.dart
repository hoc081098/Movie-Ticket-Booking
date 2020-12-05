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
  Iterable<Object> serialize(Serializers serializers, PromotionResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
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
      'is_active',
      serializers.serialize(object.is_active,
          specifiedType: const FullType(bool)),
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

    return result;
  }

  @override
  PromotionResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PromotionResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
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
  final bool is_active;
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
          [void Function(PromotionResponseBuilder) updates]) =>
      (new PromotionResponseBuilder()..update(updates)).build();

  _$PromotionResponse._(
      {this.id,
      this.code,
      this.discount,
      this.end_time,
      this.is_active,
      this.name,
      this.start_time,
      this.creator,
      this.show_time,
      this.createdAt,
      this.updatedAt})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('PromotionResponse', 'id');
    }
    if (code == null) {
      throw new BuiltValueNullFieldError('PromotionResponse', 'code');
    }
    if (discount == null) {
      throw new BuiltValueNullFieldError('PromotionResponse', 'discount');
    }
    if (end_time == null) {
      throw new BuiltValueNullFieldError('PromotionResponse', 'end_time');
    }
    if (is_active == null) {
      throw new BuiltValueNullFieldError('PromotionResponse', 'is_active');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('PromotionResponse', 'name');
    }
    if (start_time == null) {
      throw new BuiltValueNullFieldError('PromotionResponse', 'start_time');
    }
    if (creator == null) {
      throw new BuiltValueNullFieldError('PromotionResponse', 'creator');
    }
    if (show_time == null) {
      throw new BuiltValueNullFieldError('PromotionResponse', 'show_time');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('PromotionResponse', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('PromotionResponse', 'updatedAt');
    }
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
  _$PromotionResponse _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _code;
  String get code => _$this._code;
  set code(String code) => _$this._code = code;

  double _discount;
  double get discount => _$this._discount;
  set discount(double discount) => _$this._discount = discount;

  DateTime _end_time;
  DateTime get end_time => _$this._end_time;
  set end_time(DateTime end_time) => _$this._end_time = end_time;

  bool _is_active;
  bool get is_active => _$this._is_active;
  set is_active(bool is_active) => _$this._is_active = is_active;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  DateTime _start_time;
  DateTime get start_time => _$this._start_time;
  set start_time(DateTime start_time) => _$this._start_time = start_time;

  String _creator;
  String get creator => _$this._creator;
  set creator(String creator) => _$this._creator = creator;

  String _show_time;
  String get show_time => _$this._show_time;
  set show_time(String show_time) => _$this._show_time = show_time;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  PromotionResponseBuilder();

  PromotionResponseBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _code = _$v.code;
      _discount = _$v.discount;
      _end_time = _$v.end_time;
      _is_active = _$v.is_active;
      _name = _$v.name;
      _start_time = _$v.start_time;
      _creator = _$v.creator;
      _show_time = _$v.show_time;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PromotionResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PromotionResponse;
  }

  @override
  void update(void Function(PromotionResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PromotionResponse build() {
    final _$result = _$v ??
        new _$PromotionResponse._(
            id: id,
            code: code,
            discount: discount,
            end_time: end_time,
            is_active: is_active,
            name: name,
            start_time: start_time,
            creator: creator,
            show_time: show_time,
            createdAt: createdAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
