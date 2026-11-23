import 'package:flutter/material.dart';

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
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _confirm() => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Повідомлення'),
      content: Text(
        'Навчальна дія: ${widget.action}\n'
        '${widget.showName ? 'Ім’я: ${_name.text}\n' : ''}'
        'Логін: ${_email.text}',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('OK'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/logo.png', height: 64),
                const SizedBox(height: 24),
                if (widget.showName) ...[
                  TextField(
                    key: const ValueKey('name'),
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Ім’я користувача',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(
                  key: const ValueKey('email'),
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Логін або email',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.showPassword) ...[
                  TextField(
                    key: const ValueKey('password'),
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Пароль',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                ElevatedButton(
                  onPressed: _confirm,
                  child: Text(widget.action),
                ),
                ...widget.links,
                const SizedBox(height: 12),
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.school_outlined),
                    title: Text('Демонстрація екранів'),
                    subtitle: Text('Практична робота № 6'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
