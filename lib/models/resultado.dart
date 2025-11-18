import '../models/receita.dart';
import '../models/despesa.dart';

// Classe auxiliar para encapsular os resultados da filtragem e soma.
class ResultadosFinanceiros {
  final List<Receita> receitasFiltradas;
  final List<Despesa> despesasFiltradas;
  final double totalReceitas;
  final double totalDespesas;
  final double saldo;

  ResultadosFinanceiros({
    required this.receitasFiltradas,
    required this.despesasFiltradas,
    required this.totalReceitas,
    required this.totalDespesas,
    required this.saldo,
  });
}
