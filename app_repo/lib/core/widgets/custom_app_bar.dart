import 'package:blog_app/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/pages/aiassist_page.dart'; // Import the AiAssistPage
import 'package:blog_app/core/utils/settings_menu.dart'; // Import the new settings menu utility

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
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
    // Reverting to default menu icon for settings
    final Widget effectiveLeading = leading ??
        IconButton(
          icon: Icon(Icons.menu_rounded, color: textColor), // Reverted to menu icon
          onPressed: () => showSettingsMenu(context), // Reverted to showSettingsMenu
        );

    // Build the actions list
    final List<Widget> effectiveActions = [
      ...?actions, // Add existing actions if any
      // If a custom leading is provided, and it's not the default settings menu,
      // we might still want a settings icon in actions.
      // However, the request implies the settings icon should only be on SchedulerPage's leading.
      // So, I'll remove the conditional settings icon from actions here.
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

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor, // Background color of the AppBar
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            blurRadius: 4,
            offset: const Offset(0, 2), // Shadow offset
          ),
        ],
      ),
      child: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Divider/shadow between the settings (leading) icon and the title
            Container(
              width: 1,
              height: 22,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: textColor.withOpacity(0.35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.20 : 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        leading: effectiveLeading,
        actions: effectiveActions,
        backgroundColor: Colors.transparent, // Make AppBar background transparent to show Container's color
        elevation: 0, // Remove default AppBar shadow
        centerTitle: false, // Align title to the left
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}