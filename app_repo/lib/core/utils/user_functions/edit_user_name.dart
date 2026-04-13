import 'package:blog_app/theme/app_pallete.dart';
import 'package:flutter/material.dart';

void showEditUserNameDialog(BuildContext context, {required Function(String) onSave}) {
  String name = '';
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;

      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Edit Name', style: TextStyle(color: textColor)),
        content: TextField(
          controller: controller,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: const TextStyle(color: AppPallete.greyColor),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppPallete.borderColor),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppPallete.primaryColor),
            ),
          ),
          onChanged: (value) => name = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppPallete.greyColor)),
          ),
          TextButton(
            onPressed: () {
              onSave(name);
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: AppPallete.primaryColor)),
          ),
        ],
      );
    },
  );
}
