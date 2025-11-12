import 'package:hive_flutter/hive_flutter.dart';
import '../models/receita.dart';
import '../models/despesa.dart';

class HiveDataSource {
  final Box<Receita> _receitaBox = Hive.box<Receita>('receitas');
  final Box<Despesa> _despesaBox = Hive.box<Despesa>('despesas');

  void addReceita(Receita receita) {
    _receitaBox.add(receita);
  }

  void addDespesa(Despesa despesa) {
    _despesaBox.add(despesa);
  }

  List<Receita> getReceitas() {
    return _receitaBox.values.toList();
  }

  List<Despesa> getDespesas() {
    return _despesaBox.values.toList();
  }

  double calcularSaldo() {
    final totalReceitas = _receitaBox.values.fold(
      0.0,
      (sum, r) => sum + r.valor,
    );
    final totalDespesas = _despesaBox.values.fold(
      0.0,
      (sum, d) => sum + d.valor,
    );
    return totalReceitas - totalDespesas;
  }

  Future<void> limparTudo() async {
    await _receitaBox.clear();
    await _despesaBox.clear();
  }
}
