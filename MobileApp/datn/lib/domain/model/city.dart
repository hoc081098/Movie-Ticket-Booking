import 'package:built_value/built_value.dart';

import 'location.dart';

part 'city.g.dart';

abstract class City implements Built<City, CityBuilder> {
  @deprecated
  String get name;

  Location? get location;

  City._();

  factory City([void Function(CityBuilder) updates]) = _$City;
}
