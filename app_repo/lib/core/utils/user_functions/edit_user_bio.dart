import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

void showEditUserBioDialog(BuildContext context, {required Function(String) onSave}) {
  String bio = '';
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppPallete.darkBackgroundColor,
        title: const Text('Edit Bio', style: TextStyle(color: AppPallete.darkTextColor)),
        content: TextField(
          controller: controller,
          maxLines: 5,
          style: const TextStyle(color: AppPallete.darkTextColor),
          decoration: const InputDecoration(
            hintText: 'Enter your bio',
            hintStyle: TextStyle(color: AppPallete.darkGreyColor),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppPallete.darkBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppPallete.gradient1),
            ),
          ),
          onChanged: (value) => bio = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppPallete.darkGreyColor)),
          ),
          TextButton(
            onPressed: () {
              onSave(bio);
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: AppPallete.gradient1)),
          ),
        ],
      );
    },
  );
}
