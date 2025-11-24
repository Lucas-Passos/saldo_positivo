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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título adaptado ao tema
            Text(
              "Cadastro de Receitas",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 20),

            const FormReceita(),
            const SizedBox(height: 20),

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Última receita — card adaptado ao tema
                      if (ultima != null)
                        Card(
                          color: colorScheme.surfaceContainerHigh,
                          child: ListTile(
                            title: Text(
                              "Última receita: ${ultima.descricao}",
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                            subtitle: Text(
                              "${ultima.categoria} — R\$ ${ultima.valor.toStringAsFixed(2)}\n"
                              "📅 ${ultima.data.day}/${ultima.data.month}/${ultima.data.year}",
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      Text(
                        "Lista de Receitas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Expanded(
                        child: ListView.builder(
                          itemCount: receitasOrdenadas.length,
                          itemBuilder: (context, i) {
                            final r = receitasOrdenadas[i];
                            return Card(
                              color: colorScheme.surfaceContainerLow,
                              child: ListTile(
                                title: Text(
                                  r.descricao,
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                subtitle: Text(
                                  '${r.categoria} — R\$ ${r.valor.toStringAsFixed(2)}\n'
                                  '📅 ${r.data.day}/${r.data.month}/${r.data.year}',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Excluir Receita"),
                                        content: const Text(
                                          "Tem certeza que deseja remover este item permanentemente?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(),
                                            child: const Text("Cancelar"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              box.delete(r.key);
                                              Navigator.of(ctx).pop();
                                            },
                                            child: const Text(
                                              "Excluir",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
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
