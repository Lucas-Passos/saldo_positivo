import 'package:flutter/material.dart';
import '../datasource/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // 2. INSTANCIAR O SERVIÇO DE AUTENTICAÇÃO
  final AuthService _authService = AuthService();
  String? _errorMessage; // Variável para exibir mensagens de erro/sucesso

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha todos os campos.';
      });
      return;
    }

    // 3. TENTAR LOGIN
    final bool loginSuccess = await _authService.verificarLogin(email, senha);

    if (loginSuccess) {
      // Login Válido: Navegar para a Home
      setState(() {
        _errorMessage = null; // Limpa o erro
      });
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Login Inválido: Tentar o CADASTRO (Se for o primeiro usuário)
      final userBox = _authService.currentUserBox;
      final bool userExists = userBox.isNotEmpty;

      if (!userExists) {
        // --- ESTE É O PRIMEIRO CADASTRO ---
        await _authService.cadastrarUsuario(email, senha);

        // Tenta logar de novo para garantir que a Box foi salva
        final bool secondAttempt = await _authService.verificarLogin(
          email,
          senha,
        );

        if (secondAttempt) {
          setState(() {
            _errorMessage = 'Cadastro realizado com sucesso! Entrando...';
          });
          // Espera 1 segundo para o usuário ver a mensagem
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Falha inesperada no cadastro.
          setState(() {
            _errorMessage = 'Erro interno ao salvar usuário.';
          });
        }
      } else {
        // Usuário já existe, mas senha/email estão errados.
        setState(() {
          _errorMessage = 'E-mail ou senha incorretos.';
        });
      }
    }
  }

  // Ligar esta tela a RecoveryScreen
  void _goToRecovery() {
    Navigator.pushNamed(context, '/recovery');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Saldo Positivo',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // --- CAMPO EMAIL ---
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress, // Teclado otimizado
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(), // Estilo mais limpo
                ),
              ),
              const SizedBox(height: 16),

              // --- CAMPO SENHA ---
              TextField(
                controller: _senhaController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),

              // --- MENSAGEM DE ERRO/SUCESSO ---
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: _errorMessage!.contains('sucesso')
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 10),

              // --- BOTÃO ENTRAR ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Entrar', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 10),

              // --- BOTÃO RECUPERAÇÃO DE SENHA ---
              TextButton(
                onPressed:
                    _goToRecovery, // Chama a navegação para a RecoveryScreen
                child: const Text(
                  'Esqueci minha senha',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
