import 'package:formz/formz.dart';

enum CoordinateValidationError { invalid }

class Coordinate extends FormzInput<String, CoordinateValidationError> {
  const Coordinate.pure([String value = '']) : super.pure(value);
  const Coordinate.dirty([String value = '']) : super.dirty(value);

  @override
  CoordinateValidationError? validator(String? value) {
    return null;
  }
}
