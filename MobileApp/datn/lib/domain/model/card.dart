import 'package:built_value/built_value.dart';

part 'card.g.dart';

abstract class Card implements Built<Card, CardBuilder> {
  String get brand;

  String get card_holder_name;

  String get country;

  int get exp_month;

  int get exp_year;

  String get funding;

  String get id;

  String get last4;

  Card._();

  factory Card([void Function(CardBuilder) updates]) = _$Card;
}
