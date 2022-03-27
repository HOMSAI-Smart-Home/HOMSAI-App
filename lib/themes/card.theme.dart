import 'package:flutter/material.dart';
import 'package:homsai/themes/colors.theme.dart';

class HomsaiCardTheme {
  static CardTheme defaultTheme(ColorScheme colorScheme) {
    return CardTheme(
      color: HomsaiColors.secondaryBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      shadowColor: Colors.black,
    );
  }

  static ThemeData alertTheme(ThemeData themeData, Color primary) {
    return themeData.copyWith(
      cardTheme: themeData.cardTheme.copyWith(
        color: primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 0,
      ),
      iconTheme: themeData.iconTheme.copyWith(
        color: primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            primary: primary,
            side: BorderSide(
              color: primary,
            ),
            minimumSize: const Size(100, 30)),
      ),
      splashColor: primary.withOpacity(0.3),
    );
  }

  static ThemeData tipAlertTheme(ThemeData themeData) {
    return alertTheme(themeData, HomsaiColors.primaryGreen);
  }

  static ThemeData warningAlertTheme(ThemeData themeData) {
    return alertTheme(themeData, HomsaiColors.secondaryYellow);
  }

  static ThemeData errorAlertTheme(ThemeData themeData) {
    return alertTheme(themeData, HomsaiColors.primaryRed);
  }

  static ThemeData infoAlertTheme(ThemeData themeData) {
    return alertTheme(themeData, HomsaiColors.primaryGrey);
  }
}
