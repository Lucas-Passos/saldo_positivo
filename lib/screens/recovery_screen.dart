import 'package:flutter/material.dart';
import '../datasource/auth_service.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  String? _message;

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    // 1. Validação básica
    if (email.isEmpty || newPassword.isEmpty) {
      setState(() {
        _message = 'Por favor, preencha todos os campos.';
      });
      return;
    }

    // 2. Chama a função de reset de senha do AuthService
    final success = await _authService.resetPassword(email, newPassword);

    if (success) {
      // 3. Sucesso: Define a mensagem e navega de volta para o login
      setState(() {
        _message = 'Senha alterada com sucesso! Redirecionando...';
      });
      // Espera um pouco e volta para a tela de login
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      // 4. Falha: O e-mail não foi encontrado no cadastro local
      setState(() {
        _message =
            'Erro: O e-mail informado não corresponde ao usuário cadastrado.';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o esquema de cores correto
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperação de Senha'),
        // CORREÇÃO 1: Usando primaryColor do ColorScheme
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Para redefinir sua senha, informe seu e-mail de cadastro e a nova senha desejada.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // --- Campo de E-mail ---
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                // CORREÇÃO 2: Adicionando 'const'
                labelText: 'E-mail de Cadastro',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 15),

            // --- Campo de Nova Senha ---
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                // CORREÇÃO 3: Adicionando 'const'
                labelText: 'Nova Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 25),

            // --- Botão de Redefinir Senha ---
            ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                // CORREÇÃO 1: Usando primaryColor
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Redefinir Senha',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),

            // --- Mensagem de Status (Sucesso ou Erro) ---
            if (_message != null)
              Text(
                _message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _message!.contains('sucesso')
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
