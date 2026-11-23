import 'package:flutter/material.dart';

import '../widgets/account_panel.dart';
import '../api_service.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key, required this.api});
  final AuthApi api;
  @override
  Widget build(BuildContext context) => AccountPanel(
    api: api,
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
