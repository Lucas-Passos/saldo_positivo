import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saldo_positivo/hive/hive_config.dart';
import 'package:saldo_positivo/models/user_model.dart';
import 'models/receita.dart';
import 'models/despesa.dart';
import 'models/user.dart'; // <--- 1. Importar o modelo de usuário
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

const boxReceitas = 'receitas';
const boxDespesas = 'despesas';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ReceitaAdapter());
  Hive.registerAdapter(DespesaAdapter());
  Hive.registerAdapter(UserAdapter());
  try {
    await Hive.openBox<Receita>(boxReceitas);
    await Hive.openBox<Despesa>(boxDespesas);
    await HiveConfig.openBoxes();
    await Hive.openBox('settings');
  } catch (e) {
    debugPrint('Erro ao abrir boxes do Hive: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box('settings');

    return ValueListenableBuilder(
      valueListenable: settingsBox.listenable(),
      builder: (context, box, _) {
        final isDark = box.get('isDark', defaultValue: false);

        return MaterialApp(
          title: 'Saldo Positivo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
          routes: {
            '/login': (_) => const LoginScreen(),
            '/home': (_) => const HomeScreen(),
          },
        );
      },
    );
  }
}
