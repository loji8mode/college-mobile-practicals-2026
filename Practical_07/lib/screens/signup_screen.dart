import 'package:flutter/material.dart';

import '../widgets/account_panel.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  @override
  Widget build(BuildContext context) => AccountPanel(
    title: 'Реєстрація',
    action: 'Register',
    showName: true,
    links: [
      OutlinedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Back'),
      ),
    ],
  );
}
