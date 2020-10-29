import 'package:meta/meta.dart';

class Person {
  final bool is_active;

  final String id;

  final String avatar;

  final String full_name;

  final DateTime createdAt;

  final DateTime updatedAt;

  Person({
    @required this.is_active,
    @required this.id,
    @required this.avatar,
    @required this.full_name,
    @required this.createdAt,
    @required this.updatedAt,
  });
}
