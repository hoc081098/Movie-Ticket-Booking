// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SingleMessageErrorResponse> _$singleMessageErrorResponseSerializer =
    new _$SingleMessageErrorResponseSerializer();
Serializer<MultipleMessagesErrorResponse>
    _$multipleMessagesErrorResponseSerializer =
    new _$MultipleMessagesErrorResponseSerializer();

class _$SingleMessageErrorResponseSerializer
    implements StructuredSerializer<SingleMessageErrorResponse> {
  @override
  final Iterable<Type> types = const [
    SingleMessageErrorResponse,
    _$SingleMessageErrorResponse
  ];
  @override
  final String wireName = 'SingleMessageErrorResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, SingleMessageErrorResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'statusCode',
      serializers.serialize(object.statusCode,
          specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.error;
    if (value != null) {
      result
        ..add('error')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.message;
    if (value != null) {
      result
        ..add('message')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  SingleMessageErrorResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SingleMessageErrorResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'statusCode':
          result.statusCode = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'error':
          result.error = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$MultipleMessagesErrorResponseSerializer
    implements StructuredSerializer<MultipleMessagesErrorResponse> {
  @override
  final Iterable<Type> types = const [
    MultipleMessagesErrorResponse,
    _$MultipleMessagesErrorResponse
  ];
  @override
  final String wireName = 'MultipleMessagesErrorResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, MultipleMessagesErrorResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'statusCode',
      serializers.serialize(object.statusCode,
          specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.error;
    if (value != null) {
      result
        ..add('error')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.messages;
    if (value != null) {
      result
        ..add('message')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    return result;
  }

  @override
  MultipleMessagesErrorResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MultipleMessagesErrorResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'statusCode':
          result.statusCode = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'error':
          result.error = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'message':
          result.messages.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$SingleMessageErrorResponse extends SingleMessageErrorResponse {
  @override
  final int statusCode;
  @override
  final String? error;
  @override
  final String? message;

  factory _$SingleMessageErrorResponse(
          [void Function(SingleMessageErrorResponseBuilder)? updates]) =>
      (new SingleMessageErrorResponseBuilder()..update(updates)).build();

  _$SingleMessageErrorResponse._(
      {required this.statusCode, this.error, this.message})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        statusCode, 'SingleMessageErrorResponse', 'statusCode');
  }

  @override
  SingleMessageErrorResponse rebuild(
          void Function(SingleMessageErrorResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SingleMessageErrorResponseBuilder toBuilder() =>
      new SingleMessageErrorResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SingleMessageErrorResponse &&
        statusCode == other.statusCode &&
        error == other.error &&
        message == other.message;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, statusCode.hashCode), error.hashCode), message.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SingleMessageErrorResponse')
          ..add('statusCode', statusCode)
          ..add('error', error)
          ..add('message', message))
        .toString();
  }
}

class SingleMessageErrorResponseBuilder
    implements
        Builder<SingleMessageErrorResponse, SingleMessageErrorResponseBuilder> {
  _$SingleMessageErrorResponse? _$v;

  int? _statusCode;
  int? get statusCode => _$this._statusCode;
  set statusCode(int? statusCode) => _$this._statusCode = statusCode;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  SingleMessageErrorResponseBuilder();

  SingleMessageErrorResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _statusCode = $v.statusCode;
      _error = $v.error;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SingleMessageErrorResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SingleMessageErrorResponse;
  }

  @override
  void update(void Function(SingleMessageErrorResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SingleMessageErrorResponse build() {
    final _$result = _$v ??
        new _$SingleMessageErrorResponse._(
            statusCode: BuiltValueNullFieldError.checkNotNull(
                statusCode, 'SingleMessageErrorResponse', 'statusCode'),
            error: error,
            message: message);
    replace(_$result);
    return _$result;
  }
}

class _$MultipleMessagesErrorResponse extends MultipleMessagesErrorResponse {
  @override
  final int statusCode;
  @override
  final String? error;
  @override
  final BuiltList<String>? messages;

  factory _$MultipleMessagesErrorResponse(
          [void Function(MultipleMessagesErrorResponseBuilder)? updates]) =>
      (new MultipleMessagesErrorResponseBuilder()..update(updates)).build();

  _$MultipleMessagesErrorResponse._(
      {required this.statusCode, this.error, this.messages})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        statusCode, 'MultipleMessagesErrorResponse', 'statusCode');
  }

  @override
  MultipleMessagesErrorResponse rebuild(
          void Function(MultipleMessagesErrorResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MultipleMessagesErrorResponseBuilder toBuilder() =>
      new MultipleMessagesErrorResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MultipleMessagesErrorResponse &&
        statusCode == other.statusCode &&
        error == other.error &&
        messages == other.messages;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, statusCode.hashCode), error.hashCode), messages.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MultipleMessagesErrorResponse')
          ..add('statusCode', statusCode)
          ..add('error', error)
          ..add('messages', messages))
        .toString();
  }
}

class MultipleMessagesErrorResponseBuilder
    implements
        Builder<MultipleMessagesErrorResponse,
            MultipleMessagesErrorResponseBuilder> {
  _$MultipleMessagesErrorResponse? _$v;

  int? _statusCode;
  int? get statusCode => _$this._statusCode;
  set statusCode(int? statusCode) => _$this._statusCode = statusCode;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  ListBuilder<String>? _messages;
  ListBuilder<String> get messages =>
      _$this._messages ??= new ListBuilder<String>();
  set messages(ListBuilder<String>? messages) => _$this._messages = messages;

  MultipleMessagesErrorResponseBuilder();

  MultipleMessagesErrorResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _statusCode = $v.statusCode;
      _error = $v.error;
      _messages = $v.messages?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MultipleMessagesErrorResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MultipleMessagesErrorResponse;
  }

  @override
  void update(void Function(MultipleMessagesErrorResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MultipleMessagesErrorResponse build() {
    _$MultipleMessagesErrorResponse _$result;
    try {
      _$result = _$v ??
          new _$MultipleMessagesErrorResponse._(
              statusCode: BuiltValueNullFieldError.checkNotNull(
                  statusCode, 'MultipleMessagesErrorResponse', 'statusCode'),
              error: error,
              messages: _messages?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'messages';
        _messages?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'MultipleMessagesErrorResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
