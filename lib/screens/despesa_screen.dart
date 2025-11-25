import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saldo_positivo/widgets/form_despesa.dart';
import '../models/despesa.dart';

class DespesaScreen extends StatefulWidget {
  const DespesaScreen({super.key});

  @override
  State<DespesaScreen> createState() => _DespesaScreenState();
}

class _DespesaScreenState extends State<DespesaScreen> {
  @override
  Widget build(BuildContext context) {
    final despesasBox = Hive.box<Despesa>('despesas');
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cadastro de Despesas",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                const FormDespesa(),
                const SizedBox(height: 20),

                ValueListenableBuilder(
                  valueListenable: despesasBox.listenable(),
                  builder: (context, box, _) {
                    final despesas = box.values.toList();
                    final despesasOrdenadas = despesas.reversed.toList();
                    final ultima = despesasOrdenadas.isNotEmpty
                        ? despesasOrdenadas.first
                        : null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (ultima != null)
                          Card(
                            elevation: 0,
                            color: colors.surfaceContainerHigh,
                            child: ListTile(
                              title: Text(
                                "Última despesa: ${ultima.descricao}",
                                style: theme.textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                "${ultima.categoria} — R\$ ${ultima.valor.toStringAsFixed(2)}\n"
                                "📅 ${ultima.data.day}/${ultima.data.month}/${ultima.data.year}",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        Text(
                          "Lista de Despesas",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Lista interna não-rolável
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: despesasOrdenadas.length,
                          itemBuilder: (context, i) {
                            final d = despesasOrdenadas[i];

                            return Card(
                              elevation: 0,
                              color: colors.surfaceContainerHigh,
                              child: ListTile(
                                title: Text(
                                  d.descricao,
                                  style: theme.textTheme.bodyLarge,
                                ),
                                subtitle: Text(
                                  '${d.categoria} — R\$ ${d.valor.toStringAsFixed(2)}\n'
                                  '📅 ${d.data.day}/${d.data.month}/${d.data.year}',
                                  style: theme.textTheme.bodyMedium,
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
                                        title: const Text("Excluir Despesa"),
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
                                              box.delete(d.key);
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
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
