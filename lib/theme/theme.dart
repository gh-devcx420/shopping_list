import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const baseTextStyle = GoogleFonts.urbanist;

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
      iconTheme: IconThemeData(color: colorScheme.primaryFixed),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.onPrimaryFixedVariant,
        foregroundColor: colorScheme.primaryFixed,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.secondaryFixedDim,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: baseTextStyle(
          color: colorScheme.primary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: baseTextStyle(
          color: colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: colorScheme.primaryFixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colorScheme.secondaryFixedDim,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12.0,
        ),
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.shadow,
        ),
        border: const OutlineInputBorder(),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.primaryContainer,
          textStyle: baseTextStyle(
            color: colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: baseTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textTheme: setTextTheme(colorScheme),
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
      iconTheme: IconThemeData(color: colorScheme.primaryFixed),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.onPrimaryFixedVariant,
        foregroundColor: colorScheme.primaryFixed,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.secondaryFixedDim,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: baseTextStyle(
          color: colorScheme.primary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: baseTextStyle(
          color: colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: colorScheme.primaryFixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colorScheme.onSecondaryFixed,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12.0,
        ),
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.primaryFixed,
        ),
        border: const OutlineInputBorder(),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.primaryContainer,
          textStyle: baseTextStyle(
            color: colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: baseTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textTheme: setTextTheme(colorScheme),
    );
  }

  static setTextTheme(colorScheme) {
    return TextTheme(
      titleLarge: baseTextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
      ),
      titleMedium: baseTextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      titleSmall: baseTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
      labelLarge: baseTextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: baseTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: baseTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: baseTextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: baseTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: baseTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
