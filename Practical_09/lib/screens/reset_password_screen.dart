import 'package:flutter/material.dart';

import '../widgets/account_panel.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) => AccountPanel(
    title: 'Відновлення пароля',
    action: 'Reset',
    showPassword: false,
    links: [
      OutlinedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Back'),
      ),
    ],
  );
}
