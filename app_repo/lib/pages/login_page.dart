import 'package:blog_app/core/widgets/loader.dart';
import 'package:blog_app/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/pages/homescreen_page.dart';
import 'package:blog_app/pages/signup_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Removed: import 'package:blog_app/core/widgets/custom_app_bar.dart'; // Import CustomAppBar

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: isDark ? AppPallete.backgroundColor : AppPallete.lightBlueWhite,
      // Removed: appBar: const CustomAppBar(title: 'Login', hideAssistantIcon: false),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  showSnackBar(context, state.message);
                } else if (state is AuthSuccess) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    HomeScreen.route(),
                    (route) => false,
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Loader();
                }

                return Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    color: isDark ? AppPallete.surfaceColor : Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: AppPallete.borderColor.withOpacity(isDark ? 0.1 : 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'MedicAssist',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppPallete.greyColor : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32),
                        AuthField(
                          hintText: 'Email',
                          controller: emailController,
                        ),
                        const SizedBox(height: 16),
                        AuthField(
                          hintText: 'Password',
                          controller: passwordController,
                          isObscureText: true,
                        ),
                        const SizedBox(height: 24),
                        AuthGradientButton(
                          buttonText: 'Login',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    AuthLogin(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ),
                                  );
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, SignUpPage.route());
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('OR', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                HomeScreen.route(),
                                (route) => false,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'Skip for now',
                              style: TextStyle(
                                color: isDark ? Colors.white60 : Colors.black45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}