// lib/datasource/auth_service.dart <-- Comentário corrigido

import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart'; // Mantido, pois é o caminho correto para sua estrutura

// 1. A Box de usuário que você abriu no main.dart
// Usamos o 'late' porque a Box é aberta antes da classe ser usada.
late final Box userBox = Hive.box('userBox');

class AuthService {
  // NOVO GETTER: Permite que a LoginScreen acesse a Box e verifique se está vazia
  Box get currentUserBox => userBox; // <--- CORREÇÃO CRÍTICA PARA A LoginScreen

  // --- 1. CADASTRO / REGISTRO INICIAL ---
  Future<void> cadastrarUsuario(String email, String senha) async {
    final newUser = UserModel(email: email, senha: senha);
    await userBox.put('currentUser', newUser);
  }

  // --- 2. VERIFICAÇÃO DE LOGIN ---
  Future<bool> verificarLogin(
    String emailDigitado,
    String senhaDigitada,
  ) async {
    final user = userBox.get('currentUser') as UserModel?;

    // Verifica se o usuário existe E se as credenciais batem
    return user != null &&
        user.email == emailDigitado &&
        user.senha == senhaDigitada;
  }

  // --- 3. RECUPERAÇÃO / RESET DE SENHA ---
  Future<bool> resetPassword(String email, String novaSenha) async {
    final user = userBox.get('currentUser') as UserModel?;

    // 1. Verifica se o usuário existe E se o e-mail bate com o cadastrado
    if (user != null && user.email == email) {
      // 2. Atualiza a senha e salva o objeto modificado
      user.senha = novaSenha;
      await user.save(); // Salva as mudanças no disco
      return true; // Senha alterada com sucesso
    }

    return false; // E-mail não corresponde ao usuário cadastrado
  }
}
