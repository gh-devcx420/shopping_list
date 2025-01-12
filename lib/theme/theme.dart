import 'package:flutter/material.dart';

abstract final class AppTheme {
  static lightTheme(ColorScheme colorScheme) {
    return ThemeData(useMaterial3: true, colorScheme: colorScheme).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.onPrimaryFixedVariant,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: colorScheme.primaryFixed,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.primaryFixed,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.onPrimaryFixedVariant,
        foregroundColor: colorScheme.primaryFixed,
      ),
      listTileTheme:
          ListTileThemeData(tileColor: colorScheme.secondaryFixedDim),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colorScheme.secondaryFixedDim,
        filled: true,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colorScheme.shadow,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondaryFixedDim,
          foregroundColor: colorScheme.shadow,
        ),
      ),
    );
  }

  static darkTheme(ColorScheme colorScheme) {
    return ThemeData(useMaterial3: true, colorScheme: colorScheme).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.onPrimaryFixedVariant,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: colorScheme.primaryFixed,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.primaryFixed,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.onPrimaryFixedVariant,
        foregroundColor: colorScheme.primaryFixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colorScheme.onSecondaryFixed,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.secondaryFixedDim,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.secondaryFixedDim,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondaryFixedDim,
          foregroundColor: colorScheme.shadow,
        ),
      ),
    );
  }
}
