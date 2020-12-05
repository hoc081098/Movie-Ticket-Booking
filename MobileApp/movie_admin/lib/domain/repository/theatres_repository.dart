import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

import '../../ui/theatres/seat.dart';
import '../model/location.dart';
import '../model/theatre.dart';

abstract class TheatresRepository {
  Future<List<Theatre>> getTheatres();

  Future<Theatre> addTheatre({
    @required String name,
    @required String address,
    @required String phone_number,
    @required String email,
    @required String description,
    @required Location location,
    @required File cover,
    @required File thumbnail,
    @required BuiltList<Seat> seats,
  });
}
