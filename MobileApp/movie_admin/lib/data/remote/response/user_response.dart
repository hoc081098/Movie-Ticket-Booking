import 'package:meta/meta.dart';

class LocationResponse {
  final List<double> coordinates;

  LocationResponse._(this.coordinates);

  factory LocationResponse.fromJson(Map map) {
    return LocationResponse._(map['coordinates']);
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
  });

  factory UserResponse.fromJson(Map map) {
    return UserResponse(
      uid: map['uid'],
      email: map['email'],
      phone_number: map['phone_number'],
      full_name: map['full_name'],
      gender: map['gender'],
      avatar: map['avatar'],
      address: map['address'],
      birthday: DateTime.parse(map['birthday']).toLocal(),
      location: LocationResponse.fromJson(map['location']),
      is_completed: map['is_completed'],
      is_active: map['is_active'],
    );
  }
}
