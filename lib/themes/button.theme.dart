import 'package:flutter/material.dart';

class HomsaiButtonsTheme {
  static TextButtonThemeData defaultTextTheme(
      ColorScheme colorScheme, TextTheme textTheme) {
    return TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          textTheme.headline2?.copyWith(color: colorScheme.primary),
        ),
      ),
    );
  }

  static ElevatedButtonThemeData defaultElevatedTheme(
      ColorScheme colorScheme, TextTheme textTheme) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return colorScheme.primary.withOpacity(0.3);
          }
          return null;
        }),
        foregroundColor: MaterialStateProperty.all(colorScheme.onPrimary),
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(48)),
        textStyle: MaterialStateProperty.all(
            textTheme.headline6?.copyWith(color: colorScheme.background)),
        elevation: MaterialStateProperty.all(5.0),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        )),
        padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
      ),
    );
  }

  static OutlinedButtonThemeData defaultOutlinedTheme(
      ColorScheme colorScheme, TextTheme textTheme) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return colorScheme.onBackground.withOpacity(0.3);
          }
          return colorScheme.onBackground;
        }),
        overlayColor: MaterialStateProperty.all(colorScheme.surface),
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(48)),
        textStyle: MaterialStateProperty.all(
            textTheme.headline6?.copyWith(color: colorScheme.onBackground)),
        elevation: MaterialStateProperty.all(0.0),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: colorScheme.onBackground,
              width: 1,
            ))),
        side: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return BorderSide(
              color: colorScheme.onBackground.withOpacity(0.3),
              width: 1,
            );
          }
          return BorderSide(
            color: colorScheme.onBackground,
            width: 1,
          );
        }),
        padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
      ),
    );
  }
}
