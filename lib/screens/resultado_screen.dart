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

  // 1. LÓGICA DE AGRUPAMENTO (Mantida)
  Map<String, double> agruparPorCategoria(List<dynamic> itens) {
    final Map<String, double> mapa = {};

    for (var item in itens) {
      final categoria = item.categoria;
      final valor = item.valor;

      mapa[categoria] = (mapa[categoria] ?? 0) + valor;
    }

    return mapa;
  }

  // 2. LÓGICA DE EXIBIÇÃO DE MODAL (Mantida)
  void mostrarCategorias(String titulo, Map<String, double> categorias) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              // Usando um ListView.builder para melhor eficiência e scannability
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final entry = categorias.entries.elementAt(index);
                    return ListTile(
                      title: Text(entry.key),
                      trailing: Text(
                        "R\$ ${entry.value.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. NOVO: Lógica de filtragem de item por período (Reutilização de código)
  bool _filtrarPorPeriodo(dynamic item) {
    if (dataInicial != null && item.data.isBefore(dataInicial!)) {
      return false;
    }
    // Note: Usamos `isAfter` do dataFinal para incluir o dia final.
    // Se o DateTime do item tiver hora, pode ser que o último dia seja excluído.
    // Para precisão total, precisaríamos zerar a hora. Por simplicidade, mantivemos a lógica original.
    if (dataFinal != null && item.data.isAfter(dataFinal!)) {
      return false;
    }
    return true;
  }

  // 4. NOVO: Cálculo dos resultados filtrados (Separação de lógica)
  ResultadosFinanceiros _calcularResultadosFiltrados(
    List<Receita> receitas,
    List<Despesa> despesas,
  ) {
    // 🔹 FILTRANDO PELO PERÍODO (Reutilizando _filtrarPorPeriodo)
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

  // 5. NOVO: Construtor de Card reutilizável (Limpeza da UI)
  Widget _buildResultadoCard({
    required Color color,
    required IconData icon,
    required String title,
    required double total,
    required List<dynamic> itens,
    required String modalTitle,
  }) {
    return GestureDetector(
      onTap: () {
        final mapa = agruparPorCategoria(itens);
        mostrarCategorias(modalTitle, mapa);
      },
      child: Card(
        color: color,
        child: ListTile(
          leading: Icon(
            icon,
            color: color == Colors.green.shade50 ? Colors.green : Colors.red,
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            "R\$ ${total.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
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

                    // 🟩 CARD TOTAL RECEITAS FILTRADAS (UI Limpa)
                    _buildResultadoCard(
                      color: Colors.green.shade50,
                      icon: Icons.arrow_upward,
                      title: "Receitas no período",
                      total: resultados.totalReceitas,
                      itens: resultados.receitasFiltradas,
                      modalTitle: "Receitas por categoria",
                    ),

                    // 🟥 CARD TOTAL DESPESAS FILTRADAS (UI Limpa)
                    _buildResultadoCard(
                      color: Colors.red.shade50,
                      icon: Icons.arrow_downward,
                      title: "Despesas no período",
                      total: resultados.totalDespesas,
                      itens: resultados.despesasFiltradas,
                      modalTitle: "Despesas por categoria",
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
