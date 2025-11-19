import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/category_colors.dart';

class PizzaGastos extends StatelessWidget {
  final Map<String, double> porcentagens;

  const PizzaGastos({super.key, required this.porcentagens});

  @override
  Widget build(BuildContext context) {
    if (porcentagens.isEmpty) {
      return const Center(
        child: Text("Nenhum gasto no período para exibir no gráfico."),
      );
    }

    return SizedBox(
      height: 260,
      child: PieChart(
        // 1. Adicione esta chave para forçar o Flutter a identificar mudanças
        key: ValueKey(porcentagens.keys.toString()),

        // 2. Desativa a animação para evitar o erro de cor preta na transição
        swapAnimationDuration: Duration.zero,

        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 40,
          sections: porcentagens.entries.map((entry) {
            final color = CategoryColors.getColor(entry.key);

            return PieChartSectionData(
              color: color,
              value: entry.value,
              title: "${entry.value.toStringAsFixed(1)}%",
              titleStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
              ),
              radius: 60,
            );
          }).toList(),
        ),
      ),
    );
  }
}
