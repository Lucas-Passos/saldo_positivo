import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/receita.dart';
import '../models/despesa.dart';
import 'receita_screen.dart';
import 'despesa_screen.dart';
import 'resultado_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _telas = const [
    ReceitaScreen(),
    DespesaScreen(),
    ResultadoScreen(),
  ];

  final List<String> _titulos = const [
    'Receitas',
    'Despesas',
    'Resumo Financeiro',
  ];

  final List<Color> _coresAppBar = const [
    Colors.green,
    Colors.red,
    Colors.blue,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Box que armazena a preferência do tema
    final settingsBox = Hive.box('settings');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Header do Drawer adaptado ao tema
    final drawerHeaderColor = isDark
        ? const Color.fromARGB(255, 7, 92, 12)
        : const Color.fromARGB(255, 39, 179, 44);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _coresAppBar[_selectedIndex],
        title: Text(
          _titulos[_selectedIndex],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: settingsBox.listenable(),
            builder: (context, box, _) {
              final isDarkMode = box.get('isDark', defaultValue: false);
              return IconButton(
                icon: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.white,
                ),
                onPressed: () {
                  box.put('isDark', !isDarkMode);
                },
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: drawerHeaderColor),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Receitas'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.money_off),
              title: const Text('Despesas'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.pie_chart),
              title: const Text('Resultado'),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Limpar todos os registros',
                style: TextStyle(color: Colors.red),
              ),
              onTap: limparDados,
            ),
          ],
        ),
      ),

      body: _telas[_selectedIndex],
    );
  }

  void limparDados() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Apagar todos os registros?"),
          content: const Text(
            "Esta ação é permanente e não pode ser desfeita.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                final receitasBox = Hive.box<Receita>('receitas');
                final despesasBox = Hive.box<Despesa>('despesas');

                await receitasBox.clear();
                await despesasBox.clear();

                Navigator.pop(context);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Todos os registros foram apagados!"),
                    backgroundColor: Colors.red,
                  ),
                );

                setState(() {});
              },
              child: const Text(
                "Apagar tudo",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
