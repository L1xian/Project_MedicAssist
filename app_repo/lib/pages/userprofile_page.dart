import 'dart:ui';
import 'package:blog_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/cubits/app_user/user.dart';
import 'package:blog_app/theme/app_pallete.dart';
import 'package:blog_app/core/utils/user_functions/edit_user_email.dart';
import 'package:blog_app/core/utils/user_functions/edit_user_name.dart';
import 'package:blog_app/core/utils/user_functions/edit_user_phone_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Corrected import statement
import 'package:blog_app/core/widgets/custom_app_bar.dart'; // Import CustomAppBar

class TimelineEvent {
  final String date;
  final String title;
  final String doctorName; // New field
  final String doctorNotes; // New field
  final List<String> prescriptions; // New field
  final IconData icon;

  TimelineEvent({
    required this.date,
    required this.title,
    required this.doctorName,
    required this.doctorNotes,
    required this.prescriptions,
    required this.icon,
  });
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int tab = 0; // 0 = User Info, 1 = Time Line

  final List<TimelineEvent> _mockTimeline = [
    TimelineEvent(
      date: 'Oct 15, 2023',
      title: 'General Checkup',
      doctorName: 'Dr. Emily White',
      doctorNotes: 'Patient presented with mild fatigue. Vitals are stable. Advised for regular exercise and balanced diet. No immediate concerns.',
      prescriptions: ['Multivitamin (daily)', 'Vitamin D (weekly)'],
      icon: Icons.check_circle_outline,
    ),
    TimelineEvent(
      date: 'Aug 10, 2023',
      title: 'Blood Test',
      doctorName: 'Dr. John Doe',
      doctorNotes: 'Routine blood panel. Cholesterol levels slightly elevated. Recommended dietary adjustments and follow-up in 3 months.',
      prescriptions: ['Atorvastatin 10mg (daily) - if diet ineffective'],
      icon: Icons.science_outlined,
    ),
    TimelineEvent(
      date: 'Jun 22, 2023',
      title: 'Dental Cleaning',
      doctorName: 'Dr. Sarah Lee',
      doctorNotes: 'Bi-annual scaling and polishing completed. No cavities found. Advised on proper flossing techniques.',
      prescriptions: [],
      icon: Icons.health_and_safety_outlined,
    ),
    TimelineEvent(
      date: 'Mar 05, 2023',
      title: 'Flu Vaccination',
      doctorName: 'Dr. Michael Brown',
      doctorNotes: 'Annual influenza vaccine administered. Patient tolerated well. Advised to monitor for side effects.',
      prescriptions: [],
      icon: Icons.vaccines_outlined,
    ),
  ];

  void _editUserName() {
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      showEditUserNameDialog(
        context,
        onSave: (newName) {
          final updatedUser = User(
            id: userState.user.id,
            email: userState.user.email,
            name: newName,
            phoneNumber: userState.user.phoneNumber,
          );
          context.read<AppUserCubit>().updateUser(updatedUser);
        },
      );
    }
  }

  void _editUserEmail() {
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      showEditUserEmailDialog(
        context,
        onSave: (newEmail) {
          final updatedUser = User(
            id: userState.user.id,
            email: userState.user.email,
            name: userState.user.name,
            phoneNumber: userState.user.phoneNumber,
          );
          context.read<AppUserCubit>().updateUser(updatedUser);
        },
      );
    }
  }

  void _editUserPhoneNumber() {
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      showEditUserPhoneNumberDialog(
        context,
        onSave: (newPhoneNumber) {
          final updatedUser = User(
            id: userState.user.id,
            email: userState.user.email,
            name: userState.user.name,
            phoneNumber: newPhoneNumber,
          );
          context.read<AppUserCubit>().updateUser(updatedUser);
        },
      );
    }
  }

  void _editUserPassword() {
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmNewPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;
        final dialogBackgroundColor = isDark ? AppPallete.backgroundColor : Colors.white;

        return AlertDialog(
          backgroundColor: dialogBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Change Password', style: TextStyle(color: textColor)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: currentPasswordController,
                    obscureText: true,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppPallete.borderColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppPallete.primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      // Mock validation: Replace with actual authentication check
                      if (value != 'password123') { // Replace with actual current password check
                        return 'Incorrect current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppPallete.borderColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppPallete.primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: confirmNewPasswordController,
                    obscureText: true,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppPallete.borderColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppPallete.primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: AppPallete.greyColor)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Mock password update logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password updated successfully!')),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Save', style: TextStyle(color: AppPallete.whiteColor)),
            ),
          ],
        );
      },
    ).then((_) { // Dispose controllers after dialog is dismissed
      currentPasswordController.dispose();
      newPasswordController.dispose();
      confirmNewPasswordController.dispose();
    });
  }

  Future<bool> _verifyPasswordForTimeline() async {
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();

    bool? verified = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;
        final dialogBackgroundColor = isDark ? AppPallete.backgroundColor : Colors.white;

        return AlertDialog(
          backgroundColor: dialogBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Verify Password', style: TextStyle(color: textColor)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Enter your password to view Timeline',
                labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppPallete.borderColor.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppPallete.primaryColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                // Mock validation: Replace with actual authentication check
                if (value != 'password123') { // Replace with actual current password check
                  return 'Incorrect password';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Return false on cancel
              },
              child: Text('Cancel', style: TextStyle(color: AppPallete.greyColor)),
            ),
            TextButton( // Added Skip button
              onPressed: () {
                Navigator.pop(context, true); // Return true to skip verification
              },
              child: Text('Skip', style: TextStyle(color: AppPallete.primaryColor)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, true); // Return true on success
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Verify', style: TextStyle(color: AppPallete.whiteColor)),
            ),
          ],
        );
      },
    );
    passwordController.dispose(); // Dispose controller after dialog is dismissed
    return verified ?? false; // Return false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<AppUserCubit>().state;
    String userName = 'User';
    String userId = '@userID';
    String userEmail = 'user@example.com';
    String userPhoneNumber = '123-456-7890';

    if (userState is AppUserLoggedIn) {
      userName = userState.user.name;
      userId = '@${userState.user.id}';
      userEmail = userState.user.email;
      userPhoneNumber = userState.user.phoneNumber;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;
    final borderColor = AppPallete.borderColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(title: 'Profile'), // Added CustomAppBar
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            children: [
              // Add a SizedBox to push content down below the AppBar
              const SizedBox(height: kToolbarHeight + 10), // kToolbarHeight is AppBar's default height
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                userId,
                                style: TextStyle(
                                  color: textColor.withOpacity(0.7),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Avatar
                        const _Avatar(),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Content Panel
                    _GlassPanel(
                      child: Column(
                        children: [
                          _SegmentedTabs(
                            value: tab,
                            onChanged: (v) async {
                              if (v == 1) { // If 'Time Line' tab is selected
                                bool verified = await _verifyPasswordForTimeline();
                                if (verified) {
                                  setState(() => tab = v);
                                } else {
                                  // Optionally show a message if verification fails
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Password verification failed.')),
                                  );
                                }
                              } else {
                                setState(() => tab = v);
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          tab == 0
                              ? Column(
                                  children: [
                                    _UserInfoRow(
                                      title: 'User Name',
                                      subtitle: userName,
                                      onEdit: _editUserName,
                                    ),
                                    const SizedBox(height: 10),
                                    _UserInfoRow(
                                      title: 'Email',
                                      subtitle: userEmail,
                                      onEdit: _editUserEmail,
                                    ),
                                    const SizedBox(height: 10),
                                    _UserInfoRow(
                                      title: 'Phone Number',
                                      subtitle: userPhoneNumber,
                                      onEdit: _editUserPhoneNumber,
                                    ),
                                    const SizedBox(height: 10),
                                    _UserInfoRow(
                                      title: 'Password',
                                      subtitle: '********', // Masked password
                                      onEdit: _editUserPassword,
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _mockTimeline.length,
                                  itemBuilder: (context, index) {
                                    return _TimelineItem(
                                      event: _mockTimeline[index],
                                      isLast: index == _mockTimeline.length - 1,
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserInfoRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onEdit;

  const _UserInfoRow({required this.title, required this.subtitle, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(.20) : Colors.blueAccent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPallete.borderColor.withOpacity(isDark ? 0.5 : 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, size: 20, color: AppPallete.primaryColor),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatefulWidget { // Changed to StatefulWidget
  final TimelineEvent event;
  final bool isLast;

  const _TimelineItem({required this.event, required this.isLast});

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _isExpanded = false; // State to manage expansion

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppPallete.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.event.icon, color: AppPallete.primaryColor, size: 20),
              ),
              if (!widget.isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppPallete.primaryColor.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector( // Make the item tappable for expansion
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.date,
                    style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12),
                  ),
                  Text(
                    widget.event.title,
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text( // Display doctor's name here
                    'Dr. ${widget.event.doctorName}',
                    style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14),
                  ),
                  if (_isExpanded) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Doctor\'s Notes:',
                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      widget.event.doctorNotes,
                      style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14),
                    ),
                    if (widget.event.prescriptions.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Prescriptions:',
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      ...widget.event.prescriptions.map((p) => Text(
                        '- $p',
                        style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14),
                      )),
                    ],
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Removed _TopHeader class as it's replaced by CustomAppBar

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppPallete.primaryColor, width: 2),
        image: const DecorationImage(
          image: NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=Felix'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.black.withOpacity(0.3) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppPallete.borderColor.withOpacity(0.5)),
        ),
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(.25) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegButton(
              label: 'User Info',
              selected: value == 0,
              onTap: () => onChanged(0),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SegButton(
              label: 'Time Line',
              selected: value == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegButton extends StatelessWidget {
  const _SegButton({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppPallete.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : (isDark ? Colors.white.withOpacity(.72) : Colors.black54),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}