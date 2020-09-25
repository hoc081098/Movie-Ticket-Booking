import 'package:built_value/built_value.dart';

import 'location.dart';

part 'city.g.dart';

abstract class City implements Built<City, CityBuilder> {
  String get name;

  @nullable
  Location get location;

  City._();

  factory City([void Function(CityBuilder) updates]) = _$City;
}
