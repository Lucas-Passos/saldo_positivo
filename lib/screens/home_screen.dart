import 'package:flutter/material.dart';
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

  // 🔹 Títulos dinâmicos
  final List<String> _titulos = const [
    'Receitas',
    'Despesas',
    'Resumo Financeiro',
  ];

  // 🔹 Cores dinâmicas do AppBar
  final List<Color> _coresAppBar = const [
    Colors.green,
    Colors.red,
    Colors.blue,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Fecha o drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _coresAppBar[_selectedIndex], // COR MUDA AQUI
        title: Text(
          _titulos[_selectedIndex], // TÍTULO MUDA AQUI
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: _coresAppBar[_selectedIndex]),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              title: const Text('Receitas'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              title: const Text('Despesas'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              title: const Text('Resultado'),
              onTap: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
      body: _telas[_selectedIndex],
    );
  }
}
