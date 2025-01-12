import 'package:flutter/material.dart';
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
  late ColorScheme lightColorScheme;
  late ColorScheme darkColorScheme;

  void setColourScheme(AppColors pickedColourTheme) {
    setState(() {
      lightColorScheme = lightColorSchemes[pickedColourTheme]!.themeColorScheme;
      darkColorScheme = darkColorSchemes[pickedColourTheme]!.themeColorScheme;
    });
  }

  @override
  void initState() {
    super.initState();
    lightColorScheme =
        lightColorSchemes[AppColors.indigoSanMarino]!.themeColorScheme;
    darkColorScheme =
        darkColorSchemes[AppColors.indigoSanMarino]!.themeColorScheme;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(lightColorScheme),
      darkTheme: AppTheme.darkTheme(darkColorScheme),
      themeMode: ThemeMode.system,
      home: ShoppingListHomeScreen(
        onThemeChanged: setColourScheme,
      ),
    );
  }
}
