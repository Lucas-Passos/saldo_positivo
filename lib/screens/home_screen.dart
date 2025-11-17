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

  // Mantemos as instâncias das telas para preservar estado
  final List<Widget> _telas = const [
    ReceitaScreen(),
    DespesaScreen(),
    ResultadoScreen(),
  ];

  // Função utilitária para trocar a página e fechar o drawer corretamente
  void _onSelect(int index) {
    // 1) Fecha o drawer (pop da rota atual do drawer)
    Navigator.of(context).pop();

    // 2) Atualiza o índice (após o pop, o setState vai trocar o body)
    //    Não precisa de await; o pop fecha a drawer imediatamente.
    setState(() => _selectedIndex = index);
  }

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
              leading: const Icon(Icons.attach_money),
              title: const Text('Receitas'),
              selected: _selectedIndex == 0, // destaca o item ativo
              onTap: () => _onSelect(0), // fecha e seleciona
            ),
            ListTile(
              leading: const Icon(Icons.money_off),
              title: const Text('Despesas'),
              selected: _selectedIndex == 1,
              onTap: () => _onSelect(1),
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('Resultado'),
              selected: _selectedIndex == 2,
              onTap: () => _onSelect(2),
            ),
          ],
        ),
      ),

      // IndexedStack mantém o estado interno de cada tela
      body: IndexedStack(
        index: _selectedIndex,
        children: _telas,
      ),
    );
  }
}
