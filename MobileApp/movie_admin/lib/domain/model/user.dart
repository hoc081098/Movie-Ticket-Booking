import 'package:meta/meta.dart';

import 'location.dart';
import 'theatre.dart';

enum Gender { MALE, FEMALE }
enum Role { ADMIN, STAFF, USER }

extension ToString on Role {
  String string() => this == Role.ADMIN
      ? 'ADMIN'
      : this == Role.STAFF
          ? 'STAFF'
          : 'USER';
}

class User {
  final String uid;

  final String email;

  final String phoneNumber;

  final String fullName;

  final Gender gender;

  final String avatar;

  final String address;

  final DateTime birthday;

  final Location location;

  final bool isCompleted;

  final bool isActive;

  final Role role;

  final Theatre theatre;

  User({
    @required this.uid,
    @required this.email,
    @required this.phoneNumber,
    @required this.fullName,
    @required this.gender,
    @required this.avatar,
    @required this.address,
    @required this.birthday,
    @required this.location,
    @required this.isCompleted,
    @required this.isActive,
    @required this.role,
    @required this.theatre,
  });
}
