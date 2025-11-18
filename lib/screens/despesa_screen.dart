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
    final ultima = despesas.isNotEmpty ? despesas.last : null;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Cadastro de Despesas",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const FormDespesa(),
            const SizedBox(height: 20),

            // 🔥 Última despesa cadastrada
            if (ultima != null)
              Card(
                color: Colors.green.shade50,
                child: ListTile(
                  title: Text("Última despesa: ${ultima.descricao}"),
                  subtitle: Text(
                    "${ultima.categoria} — R\$ ${ultima.valor.toStringAsFixed(2)}",
                  ),
                ),
              ),

            const SizedBox(height: 20),

            const Text(
              "Lista de Despesas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

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
