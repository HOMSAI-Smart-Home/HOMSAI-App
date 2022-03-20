import 'package:flutter/material.dart';
import 'package:homsai/themes/colors.theme.dart';

class HomsaiInputDecorationTheme {
  static InputDecorationTheme defaultTheme(
      ColorScheme colorScheme, TextTheme textTheme) {
    return InputDecorationTheme(
      border: _normalTextBorder(colorScheme),
      focusedBorder: _normalTextBorder(colorScheme),
      errorBorder: _errorTextBorder(colorScheme),
      errorMaxLines: 2,
      errorStyle: textTheme.subtitle2?.copyWith(color: HomsaiColors.primaryRed),
      labelStyle: textTheme.subtitle2,
    );
  }

  static OutlineInputBorder _normalTextBorder(ColorScheme colorScheme) {
    return _textBorder(colorScheme.onBackground);
  }

  static OutlineInputBorder _errorTextBorder(ColorScheme colorScheme) {
    return _textBorder(colorScheme.error);
  }

  static OutlineInputBorder _textBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        width: 1,
        color: color,
      ),
    );
  }
}
