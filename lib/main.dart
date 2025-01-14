import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/screens/shopping_list_home.dart';
import 'package:shopping_list/theme/color_scheme.dart';
import 'package:shopping_list/theme/theme.dart';

void main() {
  runApp(
    const ShoppingList(),
  );
}

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  late ColorScheme lightColorScheme =
      lightColorSchemes[AppColors.indigoSanMarino]!.themeColorScheme;
  late ColorScheme darkColorScheme =
      darkColorSchemes[AppColors.indigoSanMarino]!.themeColorScheme;
  late SharedPreferences prefs;

  Future<void> _savePreferences(AppColors currentThemeEnum) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'savedThemeName', lightColorSchemes[currentThemeEnum]!.themeName);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('savedThemeName');
    final themeEnum = lightColorSchemes.entries.firstWhere((entry) {
      return entry.value.themeName == savedTheme!;
    }).key;
    _setColourScheme(themeEnum);
  }

  void _setColourScheme(AppColors pickedColourTheme) {
    setState(() {
      lightColorScheme = lightColorSchemes[pickedColourTheme]!.themeColorScheme;
      darkColorScheme = darkColorSchemes[pickedColourTheme]!.themeColorScheme;
    });
    _savePreferences(pickedColourTheme);
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(lightColorScheme),
      darkTheme: AppTheme.darkTheme(darkColorScheme),
      themeMode: ThemeMode.system,
      home: ShoppingListHomeScreen(
        onThemeChanged: _setColourScheme,
      ),
    );
  }
}
