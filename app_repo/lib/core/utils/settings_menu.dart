import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Needed for AppUserCubit if logout is implemented
import 'package:blog_app/core/cubits/app_user/app_user_cubit.dart'; // Needed for AppUserCubit if logout is implemented
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
              leading: const Icon(Icons.watch_rounded, color: AppPallete.primaryColor),
              title: const Text('Manage Wearable Devices'),
              onTap: () {
                // Implement manage wearable devices logic here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.switch_account_rounded, color: AppPallete.primaryColor),
              title: const Text('Switch Accounts'),
              onTap: () {
                // Implement switch accounts logic here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text('Logout'),
              onTap: () {
                // Implement logout logic here
                // Example: context.read<AppUserCubit>().userSignedOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}