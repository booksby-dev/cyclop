import 'package:flutter/material.dart';

const defaultRadius = 14.0;

const defaultBorderRadius = BorderRadius.all(Radius.circular(defaultRadius));

final lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: const Color(0xfff0f0f0),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.cyan,
    backgroundColor: const Color(0xffdadada),
  ),
  inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(
        isDense: true,
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(defaultRadius)),
      ),
  dialogTheme: ThemeData.light().dialogTheme.copyWith(
        backgroundColor: const Color(0xfff6f6f6),
      ),
  iconTheme: ThemeData.light().iconTheme.copyWith(color: Colors.blue),
  textButtonTheme: TextButtonThemeData(style: _lightTextButtonStyle),
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.cyan,
    backgroundColor: Colors.grey.shade700,
  ),
  textSelectionTheme: ThemeData.light().textSelectionTheme.copyWith(selectionColor: Colors.cyan.shade700),
  dialogTheme: ThemeData.light().dialogTheme.copyWith(
        backgroundColor: Colors.grey.shade800,
      ),
  inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(fillColor: Colors.grey.shade800),
  textButtonTheme: TextButtonThemeData(style: _darkTextButtonStyle),
);

final _lightTextButtonStyle = ButtonStyle(
  shape: WidgetStateProperty.all(
    const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  ),
  padding: WidgetStateProperty.all(
    const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
  ),
  foregroundColor: WidgetStateProperty.all(Colors.grey.shade700),
  overlayColor: WidgetStateProperty.all(Colors.white30),
);

final _darkTextButtonStyle = ButtonStyle(
  shape: WidgetStateProperty.all(
    const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  ),
  padding: WidgetStateProperty.all(
    const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
  ),
  foregroundColor: WidgetStateProperty.all(Colors.white70),
  overlayColor: WidgetStateProperty.all(Colors.black12),
);

const defaultDivider = Divider(
  color: Color(0xff999999),
  indent: 8,
  height: 10,
  endIndent: 8,
);

const shadowColor = Color(0x44333333);

const darkShadowColor = Color(0x99333333);

const defaultShadowBox = [
  BoxShadow(blurRadius: 3, spreadRadius: 1, color: shadowColor)
];

const darkShadowBox = [
  BoxShadow(blurRadius: 3, spreadRadius: 1, color: darkShadowColor)
];

const largeDarkShadowBox = [
  BoxShadow(blurRadius: 10, spreadRadius: 5, color: shadowColor)
];
