import 'package:flutter/material.dart';
import 'package:web_repo/core/presentation/pages/login_page.dart';
import 'package:web_repo/core/theme/theme.dart';
import 'package:web_repo/core/presentation/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light; // Changed default to light theme

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web App Login',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeMode,
      darkTheme: AppTheme.darkThemeMode,
      themeMode: _themeMode,
      home: LoginPage(
        onThemeChanged: changeTheme,
      ),
    );
  }
}