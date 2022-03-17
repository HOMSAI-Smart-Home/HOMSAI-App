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

  static ThemeData confirmTheme(ThemeData themeData) {
    return themeData.copyWith(
      cardTheme: themeData.cardTheme.copyWith(
        color: HomsaiColors.primaryGreen.withOpacity(0.3),
      ),
      iconTheme: themeData.iconTheme.copyWith(
        color: HomsaiColors.primaryGreen,
      ),
    );
  }
}
