import 'package:flutter/material.dart';

import '../widgets/account_panel.dart';
import 'signup_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => AccountPanel(
    title: 'Вхід',
    action: 'Login',
    links: [
      OutlinedButton(
        onPressed: () => Navigator.push<void>(
          context,
          MaterialPageRoute(builder: (_) => const SignupScreen()),
        ),
        child: const Text('Sign up'),
      ),
      TextButton(
        onPressed: () => Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (_) => const ResetPasswordScreen(),
          ),
        ),
        child: const Text('Reset Password'),
      ),
    ],
  );
}
