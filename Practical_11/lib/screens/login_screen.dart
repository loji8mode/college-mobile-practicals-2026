import 'package:flutter/material.dart';

import '../widgets/account_panel.dart';
import '../api_service.dart';
import 'signup_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.api});
  final AuthApi api;
  @override
  Widget build(BuildContext context) => AccountPanel(
    api: api,
    title: 'Вхід',
    action: 'Login',
    links: [
      OutlinedButton(
        onPressed: () => Navigator.push<void>(
          context,
          MaterialPageRoute(builder: (_) => SignupScreen(api: api)),
        ),
        child: const Text('Sign up'),
      ),
      TextButton(
        onPressed: () => Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(api: api),
          ),
        ),
        child: const Text('Reset Password'),
      ),
    ],
  );
}
