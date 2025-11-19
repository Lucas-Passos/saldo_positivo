import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../datasource/hive_datasource.dart';
import '../models/receita.dart';
import '../models/despesa.dart';
import '../models/resultado.dart';

import '../widgets/saldo_card.dart';
import '../widgets/date_filter.dart';
import '../widgets/clear_filter.dart';
import '../widgets/pizza_gastos.dart';
import '../utils/category_colors.dart';

class ResultadoScreen extends StatefulWidget {
  const ResultadoScreen({super.key});

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  final HiveDataSource _data = HiveDataSource();

  DateTime? dataInicial;
  DateTime? dataFinal;

  // AGRUPA RECEITAS OU DESPESAS POR CATEGORIA
  Map<String, double> _agruparPorCategoria(List<dynamic> itens) {
    final Map<String, double> mapa = {};

    for (var item in itens) {
      mapa[item.categoria] = (mapa[item.categoria] ?? 0) + item.valor;
    }

    return mapa;
  }

  // FILTRO DE DATA
  bool _filtrarPeriodo(dynamic item) {
    if (dataInicial != null && item.data.isBefore(dataInicial!)) return false;
    if (dataFinal != null && item.data.isAfter(dataFinal!)) return false;
    return true;
  }

  // RESULTADOS FILTRADOS
  ResultadosFinanceiros _calcularResultados(
    List<Receita> receitas,
    List<Despesa> despesas,
  ) {
    final receitasFiltradas = receitas.where(_filtrarPeriodo).toList();
    final despesasFiltradas = despesas.where(_filtrarPeriodo).toList();

    final totalReceitas = receitasFiltradas.fold(
      0.0,
      (sum, r) => sum + r.valor,
    );
    final totalDespesas = despesasFiltradas.fold(
      0.0,
      (sum, d) => sum + d.valor,
    );

    return ResultadosFinanceiros(
      receitasFiltradas: receitasFiltradas,
      despesasFiltradas: despesasFiltradas,
      totalReceitas: totalReceitas,
      totalDespesas: totalDespesas,
      saldo: totalReceitas - totalDespesas,
    );
  }

  // PORCENTAGEM DOS GASTOS PARA O GRÁFICO
  Map<String, double> _calcularPorcentagens(List<Despesa> despesas) {
    final total = despesas.fold(0.0, (s, d) => s + d.valor);

    if (total == 0) return {};

    final Map<String, double> mapa = {};
    for (var d in despesas) {
      mapa[d.categoria] = (mapa[d.categoria] ?? 0) + d.valor;
    }

    mapa.updateAll((key, value) => (value / total) * 100);
    return mapa;
  }

  // CARD EXPANSÍVEL COM CATEGORIAS
  Widget _buildResumoCard({
    required Color color,
    required IconData icon,
    required String title,
    required double total,
    required List<dynamic> itens,
  }) {
    final categoriasAgrupadas = _agruparPorCategoria(itens);

    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: icon == Icons.arrow_upward ? Colors.green : Colors.red,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          "R\$ ${total.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: categoriasAgrupadas.entries.map((e) {
          final color = CategoryColors.getColor(e.key);

          return ListTile(
            contentPadding: const EdgeInsets.only(left: 30, right: 20),
            leading: CircleAvatar(backgroundColor: color, radius: 8),
            title: Text(e.key),
            trailing: Text(
              "R\$ ${e.value.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final receitasBox = Hive.box<Receita>('receitas');
    final despesasBox = Hive.box<Despesa>('despesas');

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: receitasBox.listenable(),
        builder: (context, _, __) {
          return ValueListenableBuilder(
            valueListenable: despesasBox.listenable(),
            builder: (context, _, __) {
              final receitas = receitasBox.values.toList();
              final despesas = despesasBox.values.toList();

              final resultados = _calcularResultados(receitas, despesas);

              final porcentagensGastos = _calcularPorcentagens(
                resultados.despesasFiltradas,
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ======= FILTRO DE DATAS =======
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

                    if (dataInicial != null || dataFinal != null) ...[
                      const SizedBox(height: 10),
                      ClearFilterButton(
                        onClear: () {
                          setState(() {
                            dataInicial = null;
                            dataFinal = null;
                          });
                        },
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ======= SALDO =======
                    SaldoCard(saldo: resultados.saldo),

                    const SizedBox(height: 20),

                    // ======= GRÁFICO DE PIZZA =======
                    const Text(
                      "Distribuição dos Gastos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    PizzaGastos(porcentagens: porcentagensGastos),

                    const SizedBox(height: 20),

                    // ======= RESUMO RECEITAS =======
                    _buildResumoCard(
                      color: Colors.green.shade50,
                      icon: Icons.arrow_upward,
                      title: "Resumo de Receitas",
                      total: resultados.totalReceitas,
                      itens: resultados.receitasFiltradas,
                    ),

                    const SizedBox(height: 10),

                    // ======= RESUMO DESPESAS =======
                    _buildResumoCard(
                      color: Colors.red.shade50,
                      icon: Icons.arrow_downward,
                      title: "Resumo de Despesas",
                      total: resultados.totalDespesas,
                      itens: resultados.despesasFiltradas,
                    ),

                    const SizedBox(height: 20),
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
