import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Adicionado
import '../models/receita.dart'; // Adicionado (Assumindo caminho)
import '../models/despesa.dart'; // Adicionado (Assumindo caminho)
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
    // Fecha o drawer após a navegação
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final Color drawerHeaderColor = Theme.of(
      context,
    ).colorScheme.primary; // Cor fixa para o Header

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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 💡 DrawerHeader com cor fixa para melhor consistência
            DrawerHeader(
              decoration: BoxDecoration(color: drawerHeaderColor),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              title: const Text('Receitas'),
              selected: _selectedIndex == 0, // Destaque para o item selecionado
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              title: const Text('Despesas'),
              selected: _selectedIndex == 1, // Destaque para o item selecionado
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              title: const Text('Resultado'),
              selected: _selectedIndex == 2, // Destaque para o item selecionado
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
          title: const Text(
            "Apagar todos os registros?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                // Certifique-se de que os modelos Receita e Despesa estão importados
                final receitasBox = Hive.box<Receita>('receitas');
                final despesasBox = Hive.box<Despesa>('despesas');

                await receitasBox.clear();
                await despesasBox.clear();

                Navigator.pop(context); // 1. Fecha o diálogo
                Navigator.pop(context); // 2. Fecha o drawer

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Todos os registros foram apagados!"),
                    backgroundColor: Colors.red,
                  ),
                );

                // Força a reconstrução para refletir os dados apagados (se necessário)
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
