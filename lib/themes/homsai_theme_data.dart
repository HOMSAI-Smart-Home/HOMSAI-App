import 'package:flutter/material.dart';

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
      // Matches manifest.json colors and background color.
      primaryColor: const Color(0xFF030303),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
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

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFFB93C5D),
    primaryContainer: Color(0xFF117378),
    secondary: Color(0xFFEFF3F3),
    secondaryContainer: Color(0xFFFAFBFB),
    background: Color(0xFFE6EBEB),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;
  static const _extraBold = FontWeight.w800;
  static const _black = FontWeight.w900;

  static const TextTheme _textTheme = TextTheme(
    headline4: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _bold, fontSize: 20.0),
    caption: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _semiBold, fontSize: 16.0),
    headline5: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _medium, fontSize: 16.0),
    subtitle1: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _medium, fontSize: 16.0),
    overline: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _medium, fontSize: 12.0),
    bodyText1: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _regular, fontSize: 14.0),
    subtitle2: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _medium, fontSize: 14.0),
    bodyText2: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _regular, fontSize: 16.0),
    headline6: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _bold, fontSize: 16.0),
    button: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _semiBold, fontSize: 14.0),
  );
}
