import 'package:meta/meta.dart';

import 'theatre_response.dart';

class LocationResponse {
  final List<double> coordinates;

  LocationResponse._(this.coordinates);

  factory LocationResponse.fromJson(Map map) {
    final list = map['coordinates'] as List;
    if (list == null || list.isEmpty) {
      return LocationResponse._([]);
    }

    final nums = list.cast<num>();
    return LocationResponse._([
      nums[0].toDouble(),
      nums[1].toDouble(),
    ]);
  }

  double get longitude => coordinates.isEmpty ? null : coordinates[0];

  double get latitude => coordinates.isEmpty ? null : coordinates[1];
}

class UserResponse {
  final String uid;

  final String email;

  final String phone_number;

  final String full_name;

  final String gender;

  final String avatar;

  final String address;

  final DateTime birthday;

  final LocationResponse location;

  final bool is_completed;

  final bool is_active;

  final String role;

  final TheatreResponse theatre;

  UserResponse({
    @required this.uid,
    @required this.email,
    @required this.phone_number,
    @required this.full_name,
    @required this.gender,
    @required this.avatar,
    @required this.address,
    @required this.birthday,
    @required this.location,
    @required this.is_completed,
    @required this.is_active,
    @required this.role,
    @required this.theatre,
  });

  factory UserResponse.fromJson(Map map) {
    final theatre = map['theatre'];
    return UserResponse(
      uid: map['uid'],
      email: map['email'],
      phone_number: map['phone_number'],
      full_name: map['full_name'],
      gender: map['gender'],
      avatar: map['avatar'],
      address: map['address'],
      birthday: map['birthday'] != null
          ? DateTime.parse(map['birthday']).toLocal()
          : null,
      location: map['location'] != null
          ? LocationResponse.fromJson(map['location'])
          : null,
      is_completed: map['is_completed'],
      is_active: map['is_active'],
      role: map['role'],
      theatre: theatre == null ? null : TheatreResponse.fromJson(theatre),
    );
  }
}
