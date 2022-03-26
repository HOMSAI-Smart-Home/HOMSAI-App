import 'package:flutter/material.dart';

class HomsaiIconTheme {
  static IconThemeData defaultTheme(ColorScheme colorScheme) {
    return IconThemeData(
      color: colorScheme.onBackground,
    );
  }
}
