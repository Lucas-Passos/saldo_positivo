import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/receita.dart';
import 'models/despesa.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

const boxReceitas = 'receitas';
const boxDespesas = 'despesas';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ReceitaAdapter());
  Hive.registerAdapter(DespesaAdapter());

  try {
    await Hive.openBox<Receita>(boxReceitas);
    await Hive.openBox<Despesa>(boxDespesas);
  } catch (e) {
    debugPrint('Erro ao abrir boxes do Hive: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saldo Positivo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
