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

  factory _$Card([void Function(CardBuilder) updates]) =>
      (new CardBuilder()..update(updates)).build();

  _$Card._(
      {this.brand,
      this.card_holder_name,
      this.country,
      this.exp_month,
      this.exp_year,
      this.funding,
      this.id,
      this.last4})
      : super._() {
    if (brand == null) {
      throw new BuiltValueNullFieldError('Card', 'brand');
    }
    if (card_holder_name == null) {
      throw new BuiltValueNullFieldError('Card', 'card_holder_name');
    }
    if (country == null) {
      throw new BuiltValueNullFieldError('Card', 'country');
    }
    if (exp_month == null) {
      throw new BuiltValueNullFieldError('Card', 'exp_month');
    }
    if (exp_year == null) {
      throw new BuiltValueNullFieldError('Card', 'exp_year');
    }
    if (funding == null) {
      throw new BuiltValueNullFieldError('Card', 'funding');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Card', 'id');
    }
    if (last4 == null) {
      throw new BuiltValueNullFieldError('Card', 'last4');
    }
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
  _$Card _$v;

  String _brand;
  String get brand => _$this._brand;
  set brand(String brand) => _$this._brand = brand;

  String _card_holder_name;
  String get card_holder_name => _$this._card_holder_name;
  set card_holder_name(String card_holder_name) =>
      _$this._card_holder_name = card_holder_name;

  String _country;
  String get country => _$this._country;
  set country(String country) => _$this._country = country;

  int _exp_month;
  int get exp_month => _$this._exp_month;
  set exp_month(int exp_month) => _$this._exp_month = exp_month;

  int _exp_year;
  int get exp_year => _$this._exp_year;
  set exp_year(int exp_year) => _$this._exp_year = exp_year;

  String _funding;
  String get funding => _$this._funding;
  set funding(String funding) => _$this._funding = funding;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _last4;
  String get last4 => _$this._last4;
  set last4(String last4) => _$this._last4 = last4;

  CardBuilder();

  CardBuilder get _$this {
    if (_$v != null) {
      _brand = _$v.brand;
      _card_holder_name = _$v.card_holder_name;
      _country = _$v.country;
      _exp_month = _$v.exp_month;
      _exp_year = _$v.exp_year;
      _funding = _$v.funding;
      _id = _$v.id;
      _last4 = _$v.last4;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Card other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Card;
  }

  @override
  void update(void Function(CardBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Card build() {
    final _$result = _$v ??
        new _$Card._(
            brand: brand,
            card_holder_name: card_holder_name,
            country: country,
            exp_month: exp_month,
            exp_year: exp_year,
            funding: funding,
            id: id,
            last4: last4);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
