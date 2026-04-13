import 'package:flutter/material.dart';

class AppPallete {
  // Brand Colors
  static const Color primaryColor = Color(0xFF2850C6);
  static const Color secondaryColor = Color(0xFF0E22E8);

  // Background & Surface Colors
  static const Color lightBlueWhite = Color(0xFFF0F5FF);
  static const Color backgroundColor = Color(0xFF121212); // Primary dark background
  static const Color surfaceColor = Color(0xFF1E1E1E);    // Dark surface (cards/sheets)
  static const Color whiteColor = Color(0xFFFFFFFF);

  // UI Element Colors
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color errorColor = Colors.redAccent;
  static const Color transparentColor = Color(0x00000000);
  static const Color greyColor = Color(0xFF9E9E9E);

  // Compatibility aliases (if needed by older code)
  static const Color darkBackgroundColor = backgroundColor;
  static const Color darkTextColor = whiteColor;
  static const Color darkBorderColor = Color(0xFF333333);
  static const Color darkGreyColor = greyColor;
  static const Color lightBackgroundColor = whiteColor;
  static const Color lightTextColor = backgroundColor;
  static const Color lightBorderColor = borderColor;
  static const Color lightGreyColor = greyColor;
  static const Color gradient1 = primaryColor;
  static const Color gradient2 = secondaryColor;
}
