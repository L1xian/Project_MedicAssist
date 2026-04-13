import 'package:blog_app/theme/app_pallete.dart';
import 'package:flutter/material.dart';

void showEditUserEmailDialog(BuildContext context, {required Function(String) onSave}) {
  String email = '';
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;

      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Edit Email', style: TextStyle(color: textColor)),
        content: TextField(
          controller: controller,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: const TextStyle(color: AppPallete.greyColor),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppPallete.borderColor),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppPallete.primaryColor),
            ),
          ),
          onChanged: (value) => email = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppPallete.greyColor)),
          ),
          TextButton(
            onPressed: () {
              onSave(email);
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: AppPallete.primaryColor)),
          ),
        ],
      );
    },
  );
}
