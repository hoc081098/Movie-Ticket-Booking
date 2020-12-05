import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart' as uuid;

import '../../domain/model/location.dart';
import '../../domain/model/theatre.dart';
import '../../domain/repository/theatres_repository.dart';
import '../../ui/theatres/seat.dart';
import '../mappers.dart' as mappers;
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/theatre_response.dart';

class TheatresRepositoryImpl implements TheatresRepository {
  final AuthClient _authClient;
  final _firebaseStorage = FirebaseStorage.instance;

  TheatresRepositoryImpl(this._authClient);

  @override
  Future<List<Theatre>> getTheatres() async {
    final json = await _authClient.getBody(buildUrl('/theatres/nearby'));
    return [
      for (final r in json)
        mappers.theatreResponseToTheatre(TheatreResponse.fromJson(r)),
    ];
  }

  @override
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
  }) async {
    final urls = await Future.wait(
      [
        _uploadFile(cover),
        _uploadFile(thumbnail),
      ],
      eagerError: true,
    );

    final body = {
      'lat': location.latitude,
      'lng': location.longitude,
      'name': name,
      'address': address,
      'phone_number': phone_number,
      'email': email,
      'description': description,
      'thumbnail': urls[1],
      'cover': urls[0],
      'seats': [
        for (final s in seats)
          {
            'row': s.row,
            'count': s.count,
            'coordinates': [s.coordinates.x, s.coordinates.y],
          }
      ],
    };

    print('Body: $body');

    final json = await _authClient.postBody(
      buildUrl('/admin_theatres'),
      body: body,
    );

    return mappers.theatreResponseToTheatre(TheatreResponse.fromJson(json));
  }

  Future<String> _uploadFile(File file) async {
    final task = _firebaseStorage
        .ref()
        .child('theatre_images')
        .child(uuid.Uuid().v4())
        .putFile(file);
    await task;
    return await task.snapshot.ref.getDownloadURL();
  }
}
