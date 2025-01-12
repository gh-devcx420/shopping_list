import 'package:flutter/material.dart';

class ThemeModel {
  ThemeModel({
    required this.previewColor,
    required this.themeName,
    required this.themeColorScheme,
  });

  Color previewColor;
  String themeName;
  ColorScheme themeColorScheme;
}
