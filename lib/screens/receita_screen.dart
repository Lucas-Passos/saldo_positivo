import 'package:flutter/material.dart';
import '../widgets/form_receita.dart';
import '../datasource/hive_datasource.dart';

class ReceitaScreen extends StatefulWidget {
  const ReceitaScreen({super.key});

  @override
  State<ReceitaScreen> createState() => _ReceitaScreenState();
}

class _ReceitaScreenState extends State<ReceitaScreen> {
  final HiveDataSource _data = HiveDataSource();

  @override
  Widget build(BuildContext context) {
    final receitas = _data.getReceitas();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const FormReceita(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: receitas.length,
                itemBuilder: (context, i) {
                  final r = receitas[i];
                  return Card(
                    child: ListTile(
                      title: Text(r.descricao),
                      subtitle: Text(
                        '${r.categoria} - R\$ ${r.valor.toStringAsFixed(2)}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
