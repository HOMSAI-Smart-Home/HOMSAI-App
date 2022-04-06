import 'package:formz/formz.dart';

enum PlantNameValidationError { invalid }

class PlantName extends FormzInput<String, PlantNameValidationError> {
  const PlantName.pure([String value = '']) : super.pure(value);
  const PlantName.dirty([String value = '']) : super.dirty(value);

  @override
  PlantNameValidationError? validator(String? value) {
    return null;
  }
}
