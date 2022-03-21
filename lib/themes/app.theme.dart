import 'package:flutter/material.dart';
import 'package:homsai/themes/button.theme.dart';
import 'package:homsai/themes/card.theme.dart';
import 'package:homsai/themes/checkbox.theme.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/themes/input_decoration.theme.dart';

class HomsaiThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: _textTheme,
      primaryColor: HomsaiColors.primaryBlack,
      disabledColor: HomsaiColors.primaryBlack,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      inputDecorationTheme: HomsaiInputDecorationTheme.defaultTheme(
        colorScheme,
        _textTheme,
      ),
      checkboxTheme: HomsaiCheckboxTheme.defaultTheme(colorScheme),
      cardTheme: HomsaiCardTheme.defaultTheme(colorScheme),
      textButtonTheme: HomsaiButtonsTheme.defaultTextTheme(
        colorScheme,
        _textTheme,
      ),
      elevatedButtonTheme: HomsaiButtonsTheme.defaultElevatedTheme(
        colorScheme,
        _textTheme,
      ),
      outlinedButtonTheme: HomsaiButtonsTheme.defaultOutlinedTheme(
        colorScheme,
        _textTheme,
      ),
      iconTheme: IconThemeData(color: colorScheme.onBackground),
      unselectedWidgetColor: colorScheme.onBackground,
      toggleableActiveColor: HomsaiColors.primaryGreen,
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
        contentTextStyle: _textTheme.subtitle1!.apply(color: _darkFillColor),
      ),
    );
  }

  static ColorScheme lightColorScheme = ColorScheme(
    primary: HomsaiColors.primaryGreen,
    secondary: HomsaiColors.secondaryGreen,
    background: HomsaiColors.primaryBlack,
    surface: HomsaiColors.secondaryBlack,
    onBackground: HomsaiColors.primaryWhite,
    error: HomsaiColors.primaryRed,
    onError: HomsaiColors.primaryWhite,
    onPrimary: HomsaiColors.primaryBlack,
    onSecondary: HomsaiColors.secondaryBlack,
    onSurface: HomsaiColors.primaryWhite,
    brightness: Brightness.light,
  );

  static const _thin = FontWeight.w300;
  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static final TextTheme _textTheme = const TextTheme(
    headline4: TextStyle(
        fontFamily: "JoyrideExtended", fontWeight: _bold, fontSize: 22.0),
    caption: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _semiBold, fontSize: 16.0),
    headline5: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _medium, fontSize: 22.0),
    subtitle1: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _thin, fontSize: 14.0),
    overline: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _medium, fontSize: 12.0),
    bodyText1: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _regular, fontSize: 14.0),
    subtitle2: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _thin, fontSize: 16.0),
    bodyText2: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _regular, fontSize: 16.0),
    headline6: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _bold, fontSize: 16.0),
    button: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _semiBold, fontSize: 16.0),
  ).apply(
    bodyColor: HomsaiColors.primaryWhite,
    displayColor: HomsaiColors.primaryWhite,
  );
}