import 'package:built_collection/built_collection.dart';

import '../model/location.dart';
import '../model/theatre.dart';

abstract class TheatreRepository {
  Stream<BuiltList<Theatre>> getNearbyTheatres(Location? location);
}
