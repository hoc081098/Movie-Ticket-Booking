import 'package:meta/meta.dart';

import 'location.dart';

class Theatre {
  final Location location;
  final bool isActive;
  final List<String> rooms;
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String description;
  final String email;
  final String openingHours;
  final String roomSummary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String cover;
  final String thumbnail;

  Theatre({
    @required this.location,
    @required this.isActive,
    @required this.rooms,
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.phoneNumber,
    @required this.description,
    @required this.email,
    @required this.openingHours,
    @required this.roomSummary,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.cover,
    @required this.thumbnail,
  });

  @override
  String toString() =>
      'Theatre{location: $location, isActive: $isActive, rooms: $rooms, id: $id,'
      ' name: $name, address: $address, phoneNumber: $phoneNumber, description:'
      ' $description, email: $email, openingHours: $openingHours, roomSummary: $roomSummary,'
      ' createdAt: $createdAt, updatedAt: $updatedAt, cover: $cover, thumbnail: $thumbnail}';
}
