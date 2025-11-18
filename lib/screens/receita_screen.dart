import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/form_receita.dart';
import '../models/receita.dart';

class ReceitaScreen extends StatefulWidget {
  const ReceitaScreen({super.key});

  @override
  State<ReceitaScreen> createState() => _ReceitaScreenState();
}

class _ReceitaScreenState extends State<ReceitaScreen> {
  @override
  Widget build(BuildContext context) {
    final receitasBox = Hive.box<Receita>('receitas');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          // ⬅️ COLUMN PRINCIPAL
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Conteúdo de altura fixa (Topo da Tela)
            const Text(
              "Cadastro de Receitas",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            const FormReceita(),
            const SizedBox(height: 20),

            // 🌟 CORREÇÃO DO ERRO: ValueListenableBuilder ENVOLVIDO POR Expanded
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: receitasBox.listenable(),
                builder: (context, box, _) {
                  final receitas = box.values.toList();
                  final receitasOrdenadas = receitas.reversed.toList();
                  final ultima = receitasOrdenadas.isNotEmpty
                      ? receitasOrdenadas.first
                      : null;

                  return Column(
                    // ⬅️ COLUMN INTERNA (Limitada pelo Expanded acima)
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Conteúdo de altura fixa (Card Última Receita)
                      if (ultima != null)
                        Card(
                          color: Colors.green.shade50,
                          child: ListTile(
                            title: Text("Última receita: ${ultima.descricao}"),
                            subtitle: Text(
                              "${ultima.categoria} — R\$ ${ultima.valor.toStringAsFixed(2)}",
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      const Text(
                        "Lista de Receitas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 4. Lista de Receitas: precisa de Expanded aqui para pegar o restante do espaço da COLUMN INTERNA
                      Expanded(
                        child: ListView.builder(
                          itemCount: receitasOrdenadas.length,
                          itemBuilder: (context, i) {
                            final r = receitasOrdenadas[i];
                            return Card(
                              child: ListTile(
                                title: Text(r.descricao),
                                subtitle: Text(
                                  '${r.categoria} - R\$ ${r.valor.toStringAsFixed(2)}',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => box.delete(r.key),
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
