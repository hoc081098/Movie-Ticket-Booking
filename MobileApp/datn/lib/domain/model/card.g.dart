// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Card extends Card {
  @override
  final String brand;
  @override
  final String card_holder_name;
  @override
  final String country;
  @override
  final int exp_month;
  @override
  final int exp_year;
  @override
  final String funding;
  @override
  final String id;
  @override
  final String last4;

  factory _$Card([void Function(CardBuilder)? updates]) =>
      (new CardBuilder()..update(updates)).build();

  _$Card._(
      {required this.brand,
      required this.card_holder_name,
      required this.country,
      required this.exp_month,
      required this.exp_year,
      required this.funding,
      required this.id,
      required this.last4})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(brand, 'Card', 'brand');
    BuiltValueNullFieldError.checkNotNull(
        card_holder_name, 'Card', 'card_holder_name');
    BuiltValueNullFieldError.checkNotNull(country, 'Card', 'country');
    BuiltValueNullFieldError.checkNotNull(exp_month, 'Card', 'exp_month');
    BuiltValueNullFieldError.checkNotNull(exp_year, 'Card', 'exp_year');
    BuiltValueNullFieldError.checkNotNull(funding, 'Card', 'funding');
    BuiltValueNullFieldError.checkNotNull(id, 'Card', 'id');
    BuiltValueNullFieldError.checkNotNull(last4, 'Card', 'last4');
  }

  @override
  Card rebuild(void Function(CardBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CardBuilder toBuilder() => new CardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Card &&
        brand == other.brand &&
        card_holder_name == other.card_holder_name &&
        country == other.country &&
        exp_month == other.exp_month &&
        exp_year == other.exp_year &&
        funding == other.funding &&
        id == other.id &&
        last4 == other.last4;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc(0, brand.hashCode),
                                card_holder_name.hashCode),
                            country.hashCode),
                        exp_month.hashCode),
                    exp_year.hashCode),
                funding.hashCode),
            id.hashCode),
        last4.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Card')
          ..add('brand', brand)
          ..add('card_holder_name', card_holder_name)
          ..add('country', country)
          ..add('exp_month', exp_month)
          ..add('exp_year', exp_year)
          ..add('funding', funding)
          ..add('id', id)
          ..add('last4', last4))
        .toString();
  }
}

class CardBuilder implements Builder<Card, CardBuilder> {
  _$Card? _$v;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _card_holder_name;
  String? get card_holder_name => _$this._card_holder_name;
  set card_holder_name(String? card_holder_name) =>
      _$this._card_holder_name = card_holder_name;

  String? _country;
  String? get country => _$this._country;
  set country(String? country) => _$this._country = country;

  int? _exp_month;
  int? get exp_month => _$this._exp_month;
  set exp_month(int? exp_month) => _$this._exp_month = exp_month;

  int? _exp_year;
  int? get exp_year => _$this._exp_year;
  set exp_year(int? exp_year) => _$this._exp_year = exp_year;

  String? _funding;
  String? get funding => _$this._funding;
  set funding(String? funding) => _$this._funding = funding;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _last4;
  String? get last4 => _$this._last4;
  set last4(String? last4) => _$this._last4 = last4;

  CardBuilder();

  CardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _brand = $v.brand;
      _card_holder_name = $v.card_holder_name;
      _country = $v.country;
      _exp_month = $v.exp_month;
      _exp_year = $v.exp_year;
      _funding = $v.funding;
      _id = $v.id;
      _last4 = $v.last4;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Card other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Card;
  }

  @override
  void update(void Function(CardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Card build() {
    final _$result = _$v ??
        new _$Card._(
            brand:
                BuiltValueNullFieldError.checkNotNull(brand, 'Card', 'brand'),
            card_holder_name: BuiltValueNullFieldError.checkNotNull(
                card_holder_name, 'Card', 'card_holder_name'),
            country: BuiltValueNullFieldError.checkNotNull(
                country, 'Card', 'country'),
            exp_month: BuiltValueNullFieldError.checkNotNull(
                exp_month, 'Card', 'exp_month'),
            exp_year: BuiltValueNullFieldError.checkNotNull(
                exp_year, 'Card', 'exp_year'),
            funding: BuiltValueNullFieldError.checkNotNull(
                funding, 'Card', 'funding'),
            id: BuiltValueNullFieldError.checkNotNull(id, 'Card', 'id'),
            last4:
                BuiltValueNullFieldError.checkNotNull(last4, 'Card', 'last4'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
