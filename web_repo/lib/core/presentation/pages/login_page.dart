import 'package:flutter/material.dart';
import 'main_page.dart';
import 'signup_page.dart'; // Import the new signup page

class LoginPage extends StatelessWidget {
  final ValueChanged<ThemeMode> onThemeChanged;

  const LoginPage({super.key, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context); // Get the current theme
    final isDark = theme.brightness == Brightness.dark;

    // Determine text color based on theme for the links
    final linkTextColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: Container(
        color: theme.primaryColor, // Background blue color
        child: Center(
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.7,
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left white panel
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF22222D) : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo and text
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: Colors.white24,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'lib/core/theme/img/logo.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, color: Colors.red, size: 24);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Medic\nAssist',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // User icon
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.primaryColor,
                          child: const Icon(
                            Icons.person_outline,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),

                        // Username and password fields + login button
                        Column(
                          children: [
                            const TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline),
                                hintText: 'USERNAME',
                              ),
                            ),
                            const SizedBox(height: 15),
                            const TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline),
                                hintText: 'PASSWORD',
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: theme.primaryColor,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainPage(
                                        onThemeChanged: onThemeChanged,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Skip Login',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Forgot password and Sign up in the same line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text( // Changed to Text widget to apply dynamic color
                                'Forgot password?',
                                style: TextStyle(fontSize: 12, color: linkTextColor), // Use dynamic color
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Not a member? ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: linkTextColor, // Use dynamic color
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Sign up',
                                      style: TextStyle(
                                        color: linkTextColor, // Use dynamic color
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                // Right blue panel
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Navigation menu
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _navText('DOWNLOAD'),
                            _navText('CONTACT'),
                            const SizedBox(width: 10),
                            const Icon(Icons.menu, color: Colors.white),
                          ],
                        ),

                        const Spacer(),

                        // Welcome text
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Welcome.',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  'This is a platfrom for doctors to schedule and keep track of their patient medical history.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
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
        ),
      ),
    );
  }

  Widget _navText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}