import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';

import '../model/city.dart';

abstract class CityRepository {
  static const nationwide = 'Nationwide';

  BuiltList<City> get allCities;

  Future<void> change(City city);

  ValueStream<City> get selectedCity$;
}
