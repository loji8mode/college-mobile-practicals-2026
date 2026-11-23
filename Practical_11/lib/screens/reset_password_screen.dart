import 'package:flutter/material.dart';

import '../widgets/account_panel.dart';
import '../api_service.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.api});
  final AuthApi api;
  @override
  Widget build(BuildContext context) => AccountPanel(
    api: api,
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
