import 'package:flutter/material.dart';
import 'package:web_repo/core/presentation/pages/login_page.dart';
import 'package:web_repo/core/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web App Login',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeMode,
      darkTheme: AppTheme.darkThemeMode,
      themeMode: ThemeMode.system, // Switches based on system settings
      home: const LoginPage(),
    );
  }
}
