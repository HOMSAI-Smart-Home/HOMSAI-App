import 'package:flutter/material.dart';
import 'package:homsai/themes/button.theme.dart';
import 'package:homsai/themes/card.theme.dart';
import 'package:homsai/themes/checkbox.theme.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/themes/icon.theme.dart';
import 'package:homsai/themes/input_decoration.theme.dart';

class HomsaiThemeData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
        colorScheme: colorScheme,
        textTheme: _textTheme,
        primaryColor: HomsaiColors.primaryBlack,
        disabledColor: HomsaiColors.primaryGrey,
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
        dialogTheme: DialogTheme(
            titleTextStyle: _textTheme.headline4,
            contentTextStyle: _textTheme.bodyText1,
            backgroundColor: colorScheme.surface),
        iconTheme: HomsaiIconTheme.defaultTheme(colorScheme),
        primaryIconTheme: HomsaiIconTheme.defaultTheme(colorScheme),
        unselectedWidgetColor: colorScheme.onBackground,
        toggleableActiveColor: HomsaiColors.primaryGreen,
        canvasColor: colorScheme.background,
        scaffoldBackgroundColor: colorScheme.background,
        highlightColor: Colors.transparent,
        focusColor: focusColor,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: HomsaiColors.primaryWhite,
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(HomsaiColors.primaryWhite),
        ));
  }

  static ColorScheme lightColorScheme = const ColorScheme(
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
    surfaceVariant: HomsaiColors.secondaryBlack,
    onSurfaceVariant: HomsaiColors.primaryGrey,
    brightness: Brightness.light,
  );

  static const _light = FontWeight.w300;
  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _bold = FontWeight.w700;

  static final TextTheme _textTheme = const TextTheme(
    headline1: TextStyle(
        fontFamily: "JoyrideExtended",
        fontWeight: _regular,
        fontSize: 22.0,
        height: 1.5),
    headline2: TextStyle(
        fontFamily: "HelveticaNowText",
        fontWeight: _medium,
        fontSize: 22.0,
        height: 1.5),
    headline3: TextStyle(
        fontFamily: "HelveticaNowText",
        fontWeight: _medium,
        fontSize: 18.0,
        height: 1.5),
    headline4: TextStyle(
        fontFamily: "HelveticaNowText",
        fontWeight: _bold,
        fontSize: 16.0,
        height: 1.5),
    headline5: TextStyle(
        fontFamily: "HelveticaNowText",
        fontWeight: _bold,
        fontSize: 14.0,
        height: 1.5),
    bodyText1: TextStyle(
        fontFamily: "HelveticaNowText",
        fontWeight: _light,
        fontSize: 16.0,
        height: 1.5),
    bodyText2: TextStyle(
        fontFamily: "HelveticaNowText",
        fontWeight: _light,
        fontSize: 12.0,
        height: 1.5),
    caption: TextStyle(
        fontFamily: "HelveticaNowText",
        fontWeight: _light,
        fontSize: 14.0,
        height: 1.5),
    button: TextStyle(
        fontFamily: "HelveticaNowText", fontWeight: _medium, fontSize: 18.0),
  ).apply(
    bodyColor: HomsaiColors.primaryWhite,
    displayColor: HomsaiColors.primaryWhite,
  );
}
