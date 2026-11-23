import 'package:flutter/material.dart';

import '../validators.dart';

class AccountPanel extends StatefulWidget {
  const AccountPanel({
    super.key,
    required this.title,
    required this.action,
    this.showName = false,
    this.showPassword = true,
    this.links = const [],
  });
  final String title;
  final String action;
  final bool showName;
  final bool showPassword;
  final List<Widget> links;
  @override
  State<AccountPanel> createState() => _AccountPanelState();
}

class _AccountPanelState extends State<AccountPanel> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirmation = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Дані перевірено'),
        content: Text(_email.text.trim()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _passwordInput({bool confirm = false}) {
    final hidden = confirm ? _hideConfirmation : _hidePassword;
    final label = confirm ? 'Підтвердження пароля' : 'Пароль';
    final hint = confirm ? 'підтвердження' : 'пароль';
    return TextFormField(
      key: ValueKey(confirm ? 'confirmation' : 'password'),
      controller: confirm ? _confirmation : _password,
      obscureText: hidden,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          tooltip: hidden ? 'Показати $hint' : 'Приховати $hint',
          icon: Icon(
            hidden ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => setState(() {
            if (confirm) {
              _hideConfirmation = !_hideConfirmation;
            } else {
              _hidePassword = !_hidePassword;
            }
          }),
        ),
      ),
      validator: confirm
          ? (value) => confirmationValidator(value, _password.text)
          : passwordValidator,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/logo.png', height: 40),
                  const SizedBox(height: 12),
                  if (widget.showName) ...[
                    TextFormField(
                      key: const ValueKey('name'),
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: 'Ім’я користувача',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: requiredValue,
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextFormField(
                    key: const ValueKey('email'),
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: emailValidator,
                  ),
                  const SizedBox(height: 12),
                  if (widget.showPassword) ...[
                    _passwordInput(),
                    const SizedBox(height: 12),
                  ],
                  if (widget.showName) ...[
                    _passwordInput(confirm: true),
                    const SizedBox(height: 12),
                  ],
                  ElevatedButton(
                    onPressed: _confirm,
                    child: Text(widget.action),
                  ),
                  ...widget.links,
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
