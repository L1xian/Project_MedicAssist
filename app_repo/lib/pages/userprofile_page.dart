import 'dart:ui';
import 'package:blog_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/cubits/app_user/user.dart';
import 'package:blog_app/theme/app_pallete.dart';
import 'package:blog_app/core/utils/user_functions/edit_user_email.dart';
import 'package:blog_app/core/utils/user_functions/edit_user_name.dart';
import 'package:blog_app/core/utils/user_functions/edit_user_phone_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimelineEvent {
  final String date;
  final String title;
  final String description;
  final IconData icon;

  TimelineEvent({
    required this.date,
    required this.title,
    required this.description,
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
      description: 'Annual health assessment. All vitals normal.',
      icon: Icons.check_circle_outline,
    ),
    TimelineEvent(
      date: 'Aug 10, 2023',
      title: 'Blood Test',
      description: 'Routine blood panel. Cholesterol levels slightly elevated.',
      icon: Icons.science_outlined,
    ),
    TimelineEvent(
      date: 'Jun 22, 2023',
      title: 'Dental Cleaning',
      description: 'Bi-annual scaling and polishing.',
      icon: Icons.health_and_safety_outlined,
    ),
    TimelineEvent(
      date: 'Mar 05, 2023',
      title: 'Flu Vaccination',
      description: 'Annual influenza vaccine administered.',
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
            email: newEmail,
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
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Background radial gradient glow
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.5, -1.0),
                    radius: 1.2,
                    colors: [
                      AppPallete.primaryColor.withOpacity(isDark ? .28 : .1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 28),
              child: Column(
                children: [
                  _TopHeader(violet: AppPallete.primaryColor, violet2: AppPallete.secondaryColor),
                  Transform.translate(
                    offset: const Offset(0, -26),
                    child: Container(
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
                                  onChanged: (v) => setState(() => tab = v),
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
                  ),
                ],
              ),
            ),
          ],
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

class _TimelineItem extends StatelessWidget {
  final TimelineEvent event;
  final bool isLast;

  const _TimelineItem({required this.event, required this.isLast});

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
                child: Icon(event.icon, color: AppPallete.primaryColor, size: 20),
              ),
              if (!isLast)
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.date,
                  style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12),
                ),
                Text(
                  event.title,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  event.description,
                  style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.violet, required this.violet2});

  final Color violet;
  final Color violet2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.6, -1.0),
                  radius: 1.35,
                  colors: [
                    violet,
                    violet2,
                    Colors.blue.shade900,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -140,
            top: -140,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(.25), width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
