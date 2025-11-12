import 'package:flutter/material.dart';
import 'package:saldo_positivo/widgets/form_despesa.dart';
import '../datasource/hive_datasource.dart';

class DespesaScreen extends StatefulWidget {
  const DespesaScreen({super.key});

  @override
  State<DespesaScreen> createState() => _DespesaScreenState();
}

class _DespesaScreenState extends State<DespesaScreen> {
  final HiveDataSource _data = HiveDataSource();

  @override
  Widget build(BuildContext context) {
    final despesas = _data.getDespesas();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Despesas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const FormDespesa(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: despesas.length,
                itemBuilder: (context, i) {
                  final r = despesas[i];
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
