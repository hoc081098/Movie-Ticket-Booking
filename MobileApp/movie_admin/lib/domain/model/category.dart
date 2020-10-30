import 'package:meta/meta.dart';

class Category {
  final String id;

  final String name;

  final DateTime createdAt;

  final DateTime updatedAt;

  final bool is_active;

  Category({
    @required this.id,
    @required this.name,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.is_active,
  });
}
