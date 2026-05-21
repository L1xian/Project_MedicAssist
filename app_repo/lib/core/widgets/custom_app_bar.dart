import 'package:blog_app/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/pages/aiassist_page.dart'; // Import the AiAssistPage
import 'package:blog_app/core/utils/settings_menu.dart'; // Import the settings menu utility

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading; // Keep leading for custom overrides
  final bool hideAssistantIcon; // New property to optionally hide the AI assistant icon

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.hideAssistantIcon = false, // Default to false, so icon is shown by default
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;

    // Determine the leading widget
    final Widget effectiveLeading = leading ??
        IconButton(
          icon: Icon(Icons.menu_rounded, color: textColor),
          onPressed: () => showSettingsMenu(context),
        );

    // Build the actions list
    final List<Widget> effectiveActions = [
      ...?actions, // Add existing actions if any
      if (leading != null) // If a custom leading is provided, add settings to actions
        IconButton(
          icon: Icon(Icons.menu_rounded, color: textColor),
          onPressed: () => showSettingsMenu(context),
        ),
      if (!hideAssistantIcon) // Conditionally add the AI assistant icon
        IconButton(
          icon: Icon(
            Icons.assistant_outlined,
            color: textColor,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true, // Allows the modal to take up full height
              backgroundColor: Colors.transparent, // Make background transparent to show custom shape
              builder: (BuildContext context) {
                return FractionallySizedBox(
                  heightFactor: 0.9, // Adjust height as needed, e.g., 90% of screen height
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: AiAssistPage(), // Display the AiAssistPage
                  ),
                );
              },
            );
          },
        ),
    ];

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
      ),
      leading: effectiveLeading,
      actions: effectiveActions,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Use scaffold background color
      elevation: 0, // Remove shadow
      centerTitle: false, // Align title to the left
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}