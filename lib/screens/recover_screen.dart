import 'package:flutter/material.dart';
import '../hive/hive_config.dart';
import '../models/user_model.dart';

class RecoverScreen extends StatefulWidget {
  const RecoverScreen({super.key});

  @override
  State<RecoverScreen> createState() => _RecoverScreenState();
}

class _RecoverScreenState extends State<RecoverScreen> {
  final emailController = TextEditingController();

  void _recoverPassword() {
    final email = emailController.text.trim();
    final usersBox = HiveConfig.getUsersBox();

    final user = usersBox.values.firstWhere(
      (u) => u.email == email,
      orElse: () => User(name: '', email: '', password: ''),
    );

    if (user.email.isNotEmpty) {
      _showMessage('Senha de ${user.email}: ${user.password}');
    } else {
      _showMessage('E-mail não encontrado.');
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _recoverPassword,
              child: const Text('Recuperar'),
            ),
          ],
        ),
      ),
    );
  }
}
