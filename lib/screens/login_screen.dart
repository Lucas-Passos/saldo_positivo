import 'package:flutter/material.dart';
import '../hive/hive_config.dart';
import '../models/user_model.dart';
import 'register_screen.dart';
import 'recover_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
  }

  void _checkSession() {
    final session = HiveConfig.getSessionBox();
    final loggedEmail = session.get('loggedEmail');
    if (loggedEmail != null) {
      _showMessage('Bem-vindo de volta, $loggedEmail!');
    }
  }

  void _login() {
    final usersBox = HiveConfig.getUsersBox();
    final email = emailController.text.trim();
    final password = passwordController.text;

    final user = usersBox.values.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => User(name: '', email: '', password: ''),
    );

    if (user.email.isNotEmpty) {
      HiveConfig.getSessionBox().put('loggedEmail', user.email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      _showMessage('Usuário ou senha inválidos.');
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Entrar')),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              ),
              child: const Text('Criar conta'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecoverScreen()),
              ),
              child: const Text('Esqueci minha senha'),
            ),
          ],
        ),
      ),
    );
  }
}
