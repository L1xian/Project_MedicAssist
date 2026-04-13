import 'package:flutter/material.dart';
import 'package:blog_app/theme/app_pallete.dart';
import 'package:blog_app/theme/theme.dart';

void showSettingsMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: AppPallete.primaryColor,
              ),
              title: Text(isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode'),
              onTap: () {
                AppTheme.themeNotifier.value = 
                    isDark ? ThemeMode.light : ThemeMode.dark;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text('Logout'),
              onTap: () {
                // Implement logout logic here
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
