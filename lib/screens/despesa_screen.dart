import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saldo_positivo/widgets/form_despesa.dart';
import '../models/despesa.dart';
// Acessando Hive Box diretamente, HiveDataSource não é necessário aqui.

class DespesaScreen extends StatefulWidget {
  const DespesaScreen({super.key});

  @override
  State<DespesaScreen> createState() => _DespesaScreenState();
}

class _DespesaScreenState extends State<DespesaScreen> {
  @override
  Widget build(BuildContext context) {
    final despesasBox = Hive.box<Despesa>('despesas');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          // ⬅️ COLUMN PRINCIPAL
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Conteúdo de altura fixa (Topo da Tela)
            const Text(
              "Cadastro de Despesas",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const FormDespesa(),
            const SizedBox(height: 20),

            // 🌟 CORREÇÃO DO ERRO: ValueListenableBuilder ENVOLVIDO POR Expanded
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: despesasBox.listenable(),
                builder: (context, box, _) {
                  final despesas = box.values.toList();
                  final despesasOrdenadas = despesas.reversed.toList();
                  final ultima = despesasOrdenadas.isNotEmpty
                      ? despesasOrdenadas.first
                      : null;

                  return Column(
                    // ⬅️ COLUMN INTERNA (Limitada pelo Expanded acima)
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Conteúdo de altura fixa (Card Última Despesa)
                      if (ultima != null)
                        Card(
                          color: Colors.red.shade50,
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 4. Lista de Despesas: precisa de Expanded aqui para pegar o restante do espaço da COLUMN INTERNA
                      Expanded(
                        child: ListView.builder(
                          itemCount: despesasOrdenadas.length,
                          itemBuilder: (context, i) {
                            final d = despesasOrdenadas[i];
                            return Card(
                              child: ListTile(
                                title: Text(d.descricao),
                                subtitle: Text(
                                  '${d.categoria} - R\$ ${d.valor.toStringAsFixed(2)}',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => box.delete(d.key),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
