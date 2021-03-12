import 'package:built_value/built_value.dart';

part 'person.g.dart';

abstract class Person implements Built<Person, PersonBuilder> {
  bool get is_active;

  String get id;

  String? get avatar;

  String get full_name;

  DateTime get createdAt;

  DateTime get updatedAt;

  Person._();

  factory Person([void Function(PersonBuilder) updates]) = _$Person;
}
