import 'package:meta/meta.dart';

@sealed
abstract class Optional<T extends Object> {
  const Optional._();

  factory Optional.none() = None;

  const factory Optional.some(T value) = Some;

  factory Optional.of(T? value) =>
      value == null ? None() as Optional<T> : Some<T>(value);

  R fold<R>(R Function() none, R Function(T) some) {
    final self = this;
    if (self is Some<T>) {
      return some(self.value);
    }
    if (self is None) {
      return none();
    }
    throw 'Something was wrong $this';
  }
}

class Some<T extends Object> extends Optional<T> {
  final T value;

  const Some(this.value) : super._();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Some && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Some{value: $value}';
}

class None extends Optional<Never> {
  const None._() : super._();

  factory None() => const None._();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is None && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'None{}';
}
