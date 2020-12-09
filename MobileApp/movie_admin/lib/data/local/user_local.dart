import 'package:meta/meta.dart';

class LocationLocal {
  final double latitude;

  final double longitude;

  LocationLocal({
    @required this.latitude,
    @required this.longitude,
  });

  factory LocationLocal.fromJson(Map map) {
    return LocationLocal(
        latitude: map['latitude'], longitude: map['longitude']);
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class UserLocal {
  final String uid;

  final String email;

  final String phone_number;

  final String full_name;

  final String gender;

  final String avatar;

  final String address;

  final DateTime birthday;

  final LocationLocal location;

  final bool is_completed;

  final bool is_active;

  final String role;

  final String theatreResponseString;

  UserLocal({
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
    @required this.theatreResponseString,
  });

  factory UserLocal.fromJson(Map<String, dynamic> map) {
    return UserLocal(
      uid: map['uid'],
      email: map['email'],
      phone_number: map['phone_number'],
      full_name: map['full_name'],
      gender: map['gender'],
      avatar: map['avatar'],
      address: map['address'],
      birthday: map['birthday'] == null
          ? null
          : DateTime.parse(map['birthday']).toLocal(),
      location: map['location'] == null
          ? null
          : LocationLocal.fromJson(map['location']),
      is_completed: map['is_completed'],
      is_active: map['is_active'],
      role: map['role'],
      theatreResponseString: map['theatreResponseString'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phone_number': phone_number,
      'full_name': full_name,
      'gender': gender,
      'avatar': avatar,
      'address': address,
      'birthday': birthday?.toIso8601String(),
      'location': location?.toJson(),
      'is_completed': is_completed,
      'is_active': is_active,
      'role': role,
      'theatreResponseString': theatreResponseString,
    };
  }
}
