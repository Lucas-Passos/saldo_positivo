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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saldo Positivo')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              title: const Text('Receitas'),
              onTap: () => setState(() => _selectedIndex = 0),
            ),
            ListTile(
              title: const Text('Despesas'),
              onTap: () => setState(() => _selectedIndex = 1),
            ),
            ListTile(
              title: const Text('Resultado'),
              onTap: () => setState(() => _selectedIndex = 2),
            ),
          ],
        ),
      ),
      body: _telas[_selectedIndex],
    );
  }
}
