import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/theme/app_pallete.dart';
import 'package:blog_app/theme/theme.dart';
import 'aiassist_page.dart';
import 'posts_page.dart';
import 'userprofile_page.dart';
import 'scheduler_page.dart';

class HomeScreen extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const _NavigationBar(),
    );
  }
}

class _NavigationBar extends StatefulWidget {
  const _NavigationBar();

  @override
  State<_NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<_NavigationBar> {
  int _tabIndex = 2;

  final List<Widget> _pages = [
    const ProfilePage(),
    const SchedulerPage(),
    const ActivityDashboard(),
    const PostsPage(),
    const AiAssistPage(),
  ];

  void _showSettingsMenu(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;

    return Column(
      children: [
        // Header shown ONLY when on the Dashboard (tab index 2)
        if (_tabIndex == 2)
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu_rounded, color: textColor),
                    onPressed: () => _showSettingsMenu(context),
                  ),
                  Container(
                    height: 24,
                    width: 1,
                    color: AppPallete.borderColor.withOpacity(0.5),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  Expanded(
                    child: Text(
                      'MedicAssist',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: _pages[_tabIndex],
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomItem(
                icon: Icons.person_outline_rounded,
                selected: _tabIndex == 0,
                onTap: () => setState(() => _tabIndex = 0),
              ),
              _BottomItem(
                icon: Icons.calendar_month_rounded,
                selected: _tabIndex == 1,
                onTap: () => setState(() => _tabIndex = 1),
              ),
              _BottomItem(
                icon: Icons.home_rounded,
                selected: _tabIndex == 2,
                onTap: () => setState(() => _tabIndex = 2),
              ),
              _BottomItem(
                icon: Icons.article_outlined,
                selected: _tabIndex == 3,
                onTap: () => setState(() => _tabIndex = 3),
              ),
              _BottomItem(
                icon: Icons.auto_awesome_rounded,
                selected: _tabIndex == 4,
                onTap: () => setState(() => _tabIndex = 4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActivityDashboard extends StatelessWidget {
  const ActivityDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(
                    ink: Theme.of(context).textTheme.bodyLarge!.color!,
                    muted: AppPallete.greyColor,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 14)),
                SliverToBoxAdapter(
                  child: Row(
                    children: const [
                      Expanded(child: _MetricTile.heartRate()),
                      SizedBox(width: 12),
                      Expanded(child: _MetricTile.calories()),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: _SectionShell(
                    title: 'Steps Activity',
                    subtitle: Text(
                      'Total weekly steps : 58,432',
                      style: TextStyle(
                        color: AppPallete.greyColor,
                        fontSize: 14,
                      ),
                    ),
                    trailing: const _Pill(label: 'Last 7 days', icon: Icons.calendar_today_rounded),
                    child: SizedBox(
                      height: math.max(140, w * .36),
                      child: const _WeeklyBars(),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: _SectionShell(
                    title: 'Sleep Analysis',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        _SleepStat(label: '8', unit: 'h'),
                        SizedBox(width: 4),
                        _SleepStat(label: '35', unit: 'm'),
                      ],
                    ),
                    child: const SizedBox(height: 160, child: _SleepArea()),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.ink, required this.muted});
  final Color ink;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<AppUserCubit>().state;
    String name = 'User';
    if (userState is AppUserLoggedIn) {
      name = userState.user.name.split(' ').first;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, $name',
          style: TextStyle(
            color: ink,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Welcome back to your health dashboard',
          style: TextStyle(color: muted, fontSize: 16),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppPallete.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppPallete.primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppPallete.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.spark,
  });

  const _MetricTile.heartRate()
      : title = 'Heart Rate',
        value = '125',
        subtitle = 'bpm',
        icon = Icons.favorite_rounded,
        spark = const [0.30, 0.42, 0.35, 0.62, 0.38, 0.56, 0.44, 0.52];

  const _MetricTile.calories()
      : title = 'Calories',
        value = '325',
        subtitle = 'kcal',
        icon = Icons.local_fire_department_rounded,
        spark = const [0.20, 0.28, 0.22, 0.34, 0.30, 0.40, 0.33, 0.46];

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final List<double> spark;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppPallete.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPallete.borderColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: AppPallete.primaryColor),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: AppPallete.greyColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isDark ? AppPallete.whiteColor : AppPallete.backgroundColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: TextStyle(color: AppPallete.greyColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 30,
            child: CustomPaint(
              painter: _SparkPainter(values: spark),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  _SparkPainter({required this.values});
  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppPallete.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    final pts = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * w;
      final y = (1 - values[i]) * h;
      pts.add(Offset(x, y));
    }

    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparkPainter oldDelegate) => oldDelegate.values != values;
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.title,
    this.subtitle,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget? subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppPallete.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPallete.borderColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? AppPallete.whiteColor : AppPallete.backgroundColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    subtitle!,
                  ],
                ],
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _WeeklyBars extends StatelessWidget {
  const _WeeklyBars();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        _Bar(height: 0.4, label: '6,432'),
        _Bar(height: 0.7, label: '8,123'),
        _Bar(height: 0.5, label: '7,554'),
        _Bar(height: 0.6, label: '9,231'),
        _Bar(height: 0.4, label: '5,882'),
        _Bar(height: 0.3, label: '4,122'),
        _Bar(height: 0.9, label: '10,231', isActive: true),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final String label;
  final bool isActive;
  const _Bar({required this.height, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 100 * height,
          width: 30,
          decoration: BoxDecoration(
            color: isActive ? AppPallete.primaryColor : AppPallete.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppPallete.primaryColor : AppPallete.greyColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _SleepStat extends StatelessWidget {
  const _SleepStat({required this.label, required this.unit});
  final String label;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppPallete.whiteColor : AppPallete.backgroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          unit,
          style: TextStyle(color: AppPallete.greyColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _SleepArea extends StatelessWidget {
  const _SleepArea();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SleepPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _SleepPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppPallete.primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..color = AppPallete.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.3, size.width * 0.5, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9, size.width, size.height * 0.4);

    final area = Path.from(path);
    area.lineTo(size.width, size.height);
    area.lineTo(0, size.height);
    area.close();

    canvas.drawPath(area, paint);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _SleepPainter oldDelegate) => false;
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        color: selected ? AppPallete.primaryColor : AppPallete.greyColor.withOpacity(0.4),
        size: 28,
      ),
    );
  }
}
