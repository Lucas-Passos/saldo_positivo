import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../datasource/hive_datasource.dart';
import '../models/receita.dart';
import '../models/despesa.dart';
import '../widgets/saldo_card.dart';
import '../widgets/date_filter.dart';
import '../widgets/clear_filter.dart';
import '../models/resultado.dart';

class ResultadoScreen extends StatefulWidget {
  const ResultadoScreen({super.key});

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  final HiveDataSource _data = HiveDataSource();

  DateTime? dataInicial;
  DateTime? dataFinal;

  // 1. LÓGICA DE AGRUPAMENTO
  Map<String, double> agruparPorCategoria(List<dynamic> itens) {
    final Map<String, double> mapa = {};

    for (var item in itens) {
      final categoria = item.categoria;
      final valor = item.valor;

      mapa[categoria] = (mapa[categoria] ?? 0) + valor;
    }

    return mapa;
  }

  bool _filtrarPorPeriodo(dynamic item) {
    if (dataInicial != null && item.data.isBefore(dataInicial!)) {
      return false;
    }

    if (dataFinal != null && item.data.isAfter(dataFinal!)) {
      return false;
    }
    return true;
  }

  ResultadosFinanceiros _calcularResultadosFiltrados(
    List<Receita> receitas,
    List<Despesa> despesas,
  ) {
    final receitasFiltradas = receitas.where(_filtrarPorPeriodo).toList();
    final despesasFiltradas = despesas.where(_filtrarPorPeriodo).toList();

    // 🔹 SOMA DOS VALORES FILTRADOS
    final totalReceitas = receitasFiltradas.fold(
      0.0,
      (sum, r) => sum + r.valor,
    );

    final totalDespesas = despesasFiltradas.fold(
      0.0,
      (sum, d) => sum + d.valor,
    );

    final saldo = totalReceitas - totalDespesas;

    return ResultadosFinanceiros(
      receitasFiltradas: receitasFiltradas,
      despesasFiltradas: despesasFiltradas,
      totalReceitas: totalReceitas,
      totalDespesas: totalDespesas,
      saldo: saldo,
    );
  }

  Widget _buildExpansionCard({
    required Color color,
    required IconData icon,
    required String title,
    required double total,
    required List<dynamic> itens,
    required String subtitleText,
  }) {
    // 1. Agrupar as categorias
    final categoriasAgrupadas = agruparPorCategoria(itens);

    // 2. Mapear as categorias para ListTiles
    final listaDeCategorias = categoriasAgrupadas.entries.map((e) {
      return ListTile(
        contentPadding: const EdgeInsets.only(left: 35, right: 20), // Recuo
        title: Text(e.key),
        trailing: Text(
          "R\$ ${e.value.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }).toList();

    return Card(
      color: color,
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: color == Colors.green.shade50 ? Colors.green : Colors.red,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitleText), // Exibe o total como subtítulo
        trailing: Text(
          "R\$ ${total.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: listaDeCategorias.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text("Nenhuma transação encontrada no período."),
                ),
              ]
            : listaDeCategorias,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final receitaBox = Hive.box<Receita>('receitas');
    final despesaBox = Hive.box<Despesa>('despesas');

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: receitaBox.listenable(),
        builder: (context, _, __) {
          return ValueListenableBuilder(
            valueListenable: despesaBox.listenable(),
            builder: (context, _, __) {
              final receitas = receitaBox.values.toList();
              final despesas = despesaBox.values.toList();

              // 🌟 Chamada da função de cálculo
              final resultados = _calcularResultadosFiltrados(
                receitas,
                despesas,
              );

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // 🔹 FILTRO DE DATA
                    DateFilter(
                      dataInicial: dataInicial,
                      dataFinal: dataFinal,
                      onSelectDataInicial: (d) {
                        setState(() => dataInicial = d);
                      },
                      onSelectDataFinal: (d) {
                        setState(() => dataFinal = d);
                      },
                    ),
                    const SizedBox(height: 25),

                    // 🧹 BOTÃO LIMPAR FILTROS
                    if (dataInicial != null || dataFinal != null) ...[
                      ClearFilterButton(
                        onClear: () {
                          setState(() {
                            dataInicial = null;
                            dataFinal = null;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                    ],

                    const SizedBox(height: 10),

                    // 🟩 CARD TOTAL RECEITAS FILTRADAS
                    _buildExpansionCard(
                      color: Colors.green.shade50,
                      icon: Icons.arrow_upward,
                      title: "Resumo de Receitas ",
                      subtitleText: "Toque para ver detalhes",
                      total: resultados.totalReceitas,
                      itens: resultados.receitasFiltradas,
                    ),

                    // 🟥 CARD TOTAL DESPESAS FILTRADAS
                    _buildExpansionCard(
                      color: Colors.red.shade50,
                      icon: Icons.arrow_downward,
                      title: "Resumo de Despesas ",
                      subtitleText: "Toque para ver detalhes",
                      total: resultados.totalDespesas,
                      itens: resultados.despesasFiltradas,
                    ),
                    // 🟦 SALDO NO PERÍODO
                    SaldoCard(saldo: resultados.saldo),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
