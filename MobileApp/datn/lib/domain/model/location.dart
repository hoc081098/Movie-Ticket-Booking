import 'package:built_value/built_value.dart';

part 'location.g.dart';

abstract class Location implements Built<Location, LocationBuilder> {
  double get latitude;

  double get longitude;

  Location._();

  factory Location([void Function(LocationBuilder) updates]) = _$Location;
}
