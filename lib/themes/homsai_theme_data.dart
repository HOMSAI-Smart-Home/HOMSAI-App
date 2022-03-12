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
      primaryColor: const Color(0xFF202020),
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
    primary: Color(0xFF56BB76),
    secondary: Color(0xFFF2F2F2),
    background: Color(0xFF202020),
    surface: Color(0xFF2C2C2C),
    onBackground: Color(0xFFF2F2F2),
    error: Color(0xFFA94A15),
    onError: Color(0xFFF03829),
    onPrimary: Color(0xFF202020),
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFFF2F2F2),
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
        fontFamily: "HelveticaNowText", fontWeight: _semiBold, fontSize: 18.0),
    headline5: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _medium, fontSize: 18.0),
    subtitle1: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _medium, fontSize: 18.0),
    overline: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _medium, fontSize: 12.0),
    bodyText1: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _regular, fontSize: 14.0),
    subtitle2: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _thin, fontSize: 18.0),
    bodyText2: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _regular, fontSize: 18.0),
    headline6: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _bold, fontSize: 18.0),
    button: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _semiBold, fontSize: 18.0),
  ).apply(
    bodyColor: const Color(0xFFF2F2F2),
    displayColor: const Color(0xFFF2F2F2),
  );
}
