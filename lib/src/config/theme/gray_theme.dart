// Define a custom dark theme
import 'package:flutter/material.dart';

final ThemeData grayTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF266E90), // Primary Orange Color
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFCCCCCC), // Primary Orange Color
    secondary: Color(0xFF666666), // This is the new way to set accent color
    tertiary: Color(0xFF555555), // Background Color
    surface: Color(0xFF5E5E5E), // Background Highlight Color
    surfaceDim: Color(0xFF222222),
    onPrimary: Color(0xFF222222), // Text/icon color on primary color
    onSecondary: Color(0xFFFFFFFF), // Text/icon color on secondary color
    onSurface: Color(0xFF333333), // Text/icon color on background color
  ),
  scaffoldBackgroundColor: const Color(0xFF121212), // Background Color
  cardColor: const Color(0xFF1E1E1E), // Background Highlight Color
  dividerColor: const Color(0xFF424242), // Border Color
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 96.0), // Primary Text Color
    displayMedium: TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 60.0), // Primary Text Color
    displaySmall: TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 48.0), // Primary Text Color
    headlineLarge: TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 32.0), // Primary Text Color
    headlineMedium: TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 28.0), // Primary Text Color
    headlineSmall: TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 24.0), // Primary Text Color
    titleLarge: TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 22.0), // Primary Text Color
    titleMedium: TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 20.0), // Primary Text Color
    titleSmall: TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 18.0), // Primary Text Color
    bodyLarge: TextStyle(
        color: Color(0xFFBDBDBD), fontSize: 16.0), // Secondary Text Color
    bodyMedium: TextStyle(
        color: Color(0xFFBDBDBD), fontSize: 14.0), // Secondary Text Color
    bodySmall: TextStyle(
        color: Color(0xFFBDBDBD), fontSize: 12.0), // Secondary Text Color
    labelLarge: TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 14.0), // Primary Text Color
    labelMedium: TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 12.0), // Primary Text Color
    labelSmall: TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 10.0), // Primary Text Color
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFFF2A30F), // Primary Orange Color
    textTheme: ButtonTextTheme.primary,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFF2A30F), // Primary Orange Color
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF121212), // Background Color
    titleTextStyle:
        TextStyle(color: Color(0xFFFFFFFF), fontSize: 20), // AppBar Text Color
    iconTheme: IconThemeData(
      color: Color(0xFFFFFFFF), // AppBar Icon Color
    ),
  ),
);
