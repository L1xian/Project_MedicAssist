import 'package:blog_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/theme/theme.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/pages/login_page.dart';
import 'package:blog_app/features/posts/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/features/ai_assistant/presentation/bloc/ai_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<PostsBloc>()),
        BlocProvider(create: (_) => serviceLocator<AiBloc>()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: AppTheme.themeNotifier,
        builder: (context, ThemeMode currentMode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MedicAssist',
            theme: AppTheme.lightThemeMode,
            darkTheme: AppTheme.darkThemeMode,
            themeMode: currentMode,
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
