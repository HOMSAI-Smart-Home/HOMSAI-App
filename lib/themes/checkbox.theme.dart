import 'package:flutter/material.dart';

class HomsaiCheckboxTheme {
  static CheckboxThemeData defaultTheme(ColorScheme colorScheme) {
    return CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.primary;
        }
        return null;
      }),
      side: BorderSide(
        color: colorScheme.onBackground,
        width: 1,
      ),
    );
  }
}
