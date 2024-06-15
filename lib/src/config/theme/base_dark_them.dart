// Define a custom dark theme
import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFF2A30F), // Primary Orange Color
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFF9800), // Primary Orange Color
    secondary: Color(0xFFF27B13), // This is the new way to set accent color
    tertiary: Color(0xFFF2E0C9),
    background: Color(0xFF1E1D26), // Background Color
    surface: Color(0xFF1E1D26), // Background Highlight Color
    surfaceDim: Color.fromARGB(255, 72, 69, 69),
    onPrimary: Color(0xFFFFFFFF), // Text/icon color on primary color
    onSecondary: Color(0xFFFFFFFF), // Text/icon color on secondary color
    onSurface: Color(0xFFBDBDBD), // Text/icon color on surface color
    onBackground: Color(0xFFBDBDBD), // Text/icon color on background color
  ),
  scaffoldBackgroundColor: const Color(0xFF121212), // Background Color
  cardColor: const Color(0xFF1E1E1E), // Background Highlight Color
  dividerColor: const Color(0xFF424242), // Border Color
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Color(0xFFFFFFFF)), // Primary Text Color
    displayMedium: TextStyle(color: Color(0xFFFFFFFF)), // Primary Text Color
    displaySmall: TextStyle(color: Color(0xFFFFFFFF)), // Primary Text Color
    headlineLarge: TextStyle(color: Color(0xFFFFFFFF)), // Primary Text Color
    headlineMedium: TextStyle(color: Color(0xFFFFFFFF)), // Primary Text Color
    headlineSmall: TextStyle(color: Color(0xFFFFFFFF)), // Primary Text Color
    titleLarge: TextStyle(color: Color(0xFFFFFFFF)), // Primary Text Color
    titleMedium: TextStyle(color: Color(0xFFFFFFFF)), // Primary Text Color
    titleSmall: TextStyle(color: Color(0xFFFFFFFF)), // Primary Text Color
    bodyLarge: TextStyle(color: Color(0xFFBDBDBD)), // Secondary Text Color
    bodyMedium: TextStyle(color: Color(0xFFBDBDBD)), // Secondary Text Color
    bodySmall: TextStyle(color: Color(0xFFBDBDBD)), // Secondary Text Color
    labelLarge: TextStyle(color: Color(0xFFFFFFFF)), // Primary Text Color
    labelMedium: TextStyle(color: Color(0xFFFFFFFF)), // Primary Text Color
    labelSmall: TextStyle(color: Color(0xFFFFFFFF)), // Primary Text Color
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
