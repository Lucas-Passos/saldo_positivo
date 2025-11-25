import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/category_colors.dart';

class PizzaGrafico extends StatelessWidget {
  final Map<String, double> dados;
  final String titulo;

  const PizzaGrafico({
    super.key,
    required this.dados,
    this.titulo = "Distribuição das Categorias",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onSurface;
    final cardColor = theme.colorScheme.surfaceContainerHigh;

    return Card(
      color: cardColor,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              titulo,
              style: theme.textTheme.titleMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 35,
                  sectionsSpace: 2,
                  // Labels respeitam o tema
                  sections: dados.entries.map((e) {
                    return PieChartSectionData(
                      color: CategoryColors.getColor(e.key),
                      value: e.value,
                      title: "${e.value.toStringAsFixed(1)}%",
                      radius: 50,
                      titleStyle: theme.textTheme.bodySmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLegenda(theme),
          ],
        ),
      ),
    );
  }

  /// Legenda com tema automático, mas mantendo as cores das categorias.
  Widget _buildLegenda(ThemeData theme) {
    final textColor = theme.colorScheme.onSurface;

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: dados.keys.map((categoria) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: CategoryColors.getColor(categoria),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              categoria,
              style: theme.textTheme.bodySmall?.copyWith(color: textColor),
            ),
          ],
        );
      }).toList(),
    );
  }
}
