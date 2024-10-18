import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
    primarySwatch: Colors.green,
    fontFamily: 'Sans-serif',
    scaffoldBackgroundColor: Colors.green.shade100,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.green,
      foregroundColor: Colors.yellow,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.yellow,
        textStyle: TextStyle(fontFamily: 'Sans-serif'),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'Sans-serif',
        color: Colors.green.shade900,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Sans-serif',
        color: Colors.green.shade900,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Sans-serif',
        color: Colors.yellow,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green,
      foregroundColor: Colors.yellow,
    ),
    iconTheme: IconThemeData(
      color: Colors.green.shade900,
    ),
    highlightColor: Colors.yellow,
  );
}
