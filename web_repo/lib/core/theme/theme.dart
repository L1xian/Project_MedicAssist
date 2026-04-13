import 'package:web_repo/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = Colors.grey]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(30),
      );

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.lightBackgroundColor,
    primaryColor: AppPallete.lightAccentColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPallete.lightAccentColor,
      primary: AppPallete.lightAccentColor,
      secondary: AppPallete.lightTextColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.lightAccentColor),
      errorBorder: _border(AppPallete.errorColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.lightAccentColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.darkBackgroundColor,
    primaryColor: AppPallete.darkAccentColor,
    colorScheme: const ColorScheme.dark(
      primary: AppPallete.darkAccentColor,
      secondary: AppPallete.darkTextColor,
      // surface: AppPallete.surfaceColor, // Removed as surfaceColor is not defined in AppPallete
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.darkBackgroundColor,
    ),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(
        AppPallete.darkBackgroundColor,
      ),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.darkAccentColor),
      errorBorder: _border(AppPallete.errorColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.darkAccentColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}
