import 'package:formz/formz.dart';

enum UrlValidationError { invalid }

class Url extends FormzInput<String, UrlValidationError> {
  const Url.pure([String value = '']) : super.pure(value);
  const Url.dirty([String value = '']) : super.dirty(value);

  static final _urlRegex = RegExp(
      r"^(?:https?:\/\/)?(?:(?:(?:(?:www\.)?(?!www\.)(?:\w+|\d*|\.*))\.\w+)|(?:(?:(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))))(?:\:(?:[0-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]))?\/?$");

  @override
  UrlValidationError? validator(String? value) {
    Uri.parse(value!);
    return _urlRegex.hasMatch(value) ? null : UrlValidationError.invalid;
  }

  // OLD Regex
  //r"^(?:(?:http:\/\/|https:\/\/)|\w)(?:(?:(?:www\.)?(?:[a-zA-Z\.])+\w)|(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))(?:\:(?:[0-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]))?\/*$"
}
