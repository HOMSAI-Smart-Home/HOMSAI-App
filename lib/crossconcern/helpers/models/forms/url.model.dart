import 'package:formz/formz.dart';

enum UrlValidationError { invalid }

class Url extends FormzInput<String, UrlValidationError> {
  const Url.pure([String value = '']) : super.pure(value);
  const Url.dirty([String value = '']) : super.dirty(value);

  static final _urlRegex = RegExp(
      r'^(?:http:\/\/|https:\/\/)(?:(?:www\.)?[\w\.]+\w|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))(?:\:(?:[0-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]))?$');

  @override
  UrlValidationError? validator(String? value) {
    return _urlRegex.hasMatch(value ?? '') ? null : UrlValidationError.invalid;
  }
}
