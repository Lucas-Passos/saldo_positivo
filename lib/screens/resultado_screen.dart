import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/receita.dart';
import '../models/despesa.dart';
import '../models/resultado.dart';
import '../widgets/saldo_card.dart';
import '../widgets/date_filter.dart';
import '../widgets/clear_filter.dart';
import '../widgets/pizza_grafico.dart';
import '../utils/category_colors.dart';

class ResultadoScreen extends StatefulWidget {
  const ResultadoScreen({super.key});

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _paginaAtual = 0;

  DateTime? dataInicial;
  DateTime? dataFinal;

  // Agrupa por categoria
  Map<String, double> _agruparPorCategoria(List<dynamic> itens) {
    final Map<String, double> mapa = {};
    for (var item in itens) {
      mapa[item.categoria] = (mapa[item.categoria] ?? 0) + item.valor;
    }
    return mapa;
  }

  // Filtro de período
  bool _filtrarPeriodo(dynamic item) {
    if (dataInicial != null && item.data.isBefore(dataInicial!)) return false;
    if (dataFinal != null && item.data.isAfter(dataFinal!)) return false;
    return true;
  }

  // Calcula totais
  ResultadosFinanceiros _calcularResultados(List<Receita> r, List<Despesa> d) {
    final receitasFiltradas = r.where(_filtrarPeriodo).toList();
    final despesasFiltradas = d.where(_filtrarPeriodo).toList();

    final totalReceitas = receitasFiltradas.fold(
      0.0,
      (sum, item) => sum + item.valor,
    );
    final totalDespesas = despesasFiltradas.fold(
      0.0,
      (sum, item) => sum + item.valor,
    );

    return ResultadosFinanceiros(
      receitasFiltradas: receitasFiltradas,
      despesasFiltradas: despesasFiltradas,
      totalReceitas: totalReceitas,
      totalDespesas: totalDespesas,
      saldo: totalReceitas - totalDespesas,
    );
  }

  // Porcentagens para gráficos
  Map<String, double> _calcularPorcentagens(List<dynamic> itens) {
    final total = itens.fold(0.0, (s, i) => s + i.valor);
    if (total == 0) return {};
    final Map<String, double> mapa = {};
    for (var i in itens) {
      mapa[i.categoria] = (mapa[i.categoria] ?? 0) + i.valor;
    }
    mapa.updateAll((key, value) => (value / total) * 100);
    return mapa;
  }

  // Resumo Card usando cores neutras do tema
  Widget _buildResumoCard({
    required IconData icon,
    required String title,
    required double total,
    required List<dynamic> itens,
  }) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surfaceContainerHighest;

    final categoriasAgrupadas = _agruparPorCategoria(itens);

    return Card(
      color: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: icon == Icons.arrow_upward ? Colors.green : Colors.red,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        trailing: Text(
          "R\$ ${total.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        children: categoriasAgrupadas.entries.map((e) {
          final catColor = CategoryColors.getColor(e.key);
          return ListTile(
            contentPadding: const EdgeInsets.only(left: 30, right: 20),
            leading: CircleAvatar(backgroundColor: catColor, radius: 8),
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

  // Indicador de página
  Widget _buildIndicadorPontos() {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        final bool isActive = _paginaAtual == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
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
              final porcentagensDespesas = _calcularPorcentagens(
                resultados.despesasFiltradas,
              );
              final porcentagensReceitas = _calcularPorcentagens(
                resultados.receitasFiltradas,
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filtro de datas
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DateFilter(
                        dataInicial: dataInicial,
                        dataFinal: dataFinal,
                        onSelectDataInicial: (d) =>
                            setState(() => dataInicial = d),
                        onSelectDataFinal: (d) => setState(() => dataFinal = d),
                      ),
                    ),

                    if (dataInicial != null || dataFinal != null) ...[
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClearFilterButton(
                          onClear: () => setState(() {
                            dataInicial = null;
                            dataFinal = null;
                          }),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Saldo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SaldoCard(saldo: resultados.saldo),
                    ),

                    const SizedBox(height: 20),

                    // GRÁFICOS — sem alteração
                    SizedBox(
                      height: 300,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (i) => setState(() => _paginaAtual = i),
                        children: [
                          PizzaGrafico(
                            titulo: "Distribuição de Gastos",
                            dados: porcentagensDespesas,
                          ),
                          PizzaGrafico(
                            titulo: "Distribuição de Receitas",
                            dados: porcentagensReceitas,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    _buildIndicadorPontos(),
                    const SizedBox(height: 20),

                    // Resumos de Receitas e Despesas
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildResumoCard(
                            icon: Icons.arrow_upward,
                            title: "Resumo de Receitas",
                            total: resultados.totalReceitas,
                            itens: resultados.receitasFiltradas,
                          ),
                          const SizedBox(height: 10),
                          _buildResumoCard(
                            icon: Icons.arrow_downward,
                            title: "Resumo de Despesas",
                            total: resultados.totalDespesas,
                            itens: resultados.despesasFiltradas,
                          ),
                        ],
                      ),
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
