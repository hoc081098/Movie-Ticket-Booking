import 'package:built_value/built_value.dart';

part 'promotion.g.dart';

abstract class Promotion implements Built<Promotion, PromotionBuilder> {
  String get id;

  String get code;

  double get discount;

  DateTime get endTime;

  bool get isActive;

  String get name;

  DateTime get startTime;

  String get creator;

  String get showTime;

  DateTime get createdAt;

  DateTime get updatedAt;

  Promotion._();

  factory Promotion([void Function(PromotionBuilder) updates]) = _$Promotion;
}
