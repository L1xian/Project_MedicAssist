import 'package:blog_app/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(30),
      );

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.lightBlueWhite,
    primaryColor: AppPallete.primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPallete.primaryColor,
      primary: AppPallete.primaryColor,
      secondary: AppPallete.secondaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.lightBlueWhite,
    ),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll<Color>(
        AppPallete.whiteColor,
      ),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.primaryColor),
      errorBorder: _border(AppPallete.errorColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    primaryColor: AppPallete.primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: AppPallete.primaryColor,
      secondary: AppPallete.secondaryColor,
      surface: AppPallete.surfaceColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
    ),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll<Color>(
        AppPallete.surfaceColor,
      ),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.primaryColor),
      errorBorder: _border(AppPallete.errorColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}
