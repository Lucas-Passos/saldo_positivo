import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/receita.dart';
import 'models/despesa.dart';
import 'models/user.dart'; // <--- 1. Importar o modelo de usuário
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ReceitaAdapter());
  Hive.registerAdapter(DespesaAdapter());
  Hive.registerAdapter(
    UserModelAdapter(),
  ); // <--- 2. Registrar o adaptador do usuário

  await Hive.openBox<Receita>('receitas');
  await Hive.openBox<Despesa>('despesas');
  await Hive.openBox('userBox'); // <--- 3. Abrir a Box do Usuário

  // IMPORTANTE: Verificação de usuário salvo para decidir qual tela abrir.
  // Por enquanto, mantemos o runApp normal.

  runApp(const SaldoPositivoApp());
}

class SaldoPositivoApp extends StatelessWidget {
  const SaldoPositivoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saldo Positivo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {'/home': (_) => const HomeScreen()},
    );
  }
}
