import 'package:formz/formz.dart';

enum UrlValidationError { invalid }

class Url extends FormzInput<String, UrlValidationError> {
  const Url.pure([String value = '']) : super.pure(value);
  const Url.dirty([String value = '']) : super.dirty(value);

  static final _urlRegex = RegExp(
    r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|^((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$',
  );

  @override
  UrlValidationError? validator(String? value) {
    return _urlRegex.hasMatch(value ?? '') ? null : UrlValidationError.invalid;
  }
}
