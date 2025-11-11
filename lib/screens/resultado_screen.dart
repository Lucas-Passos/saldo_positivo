import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../datasource/hive_datasource.dart';
import '../models/receita.dart';
import '../models/despesa.dart';
import '../widgets/saldo_card.dart';

class ResultadoScreen extends StatefulWidget {
  const ResultadoScreen({super.key});

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  final HiveDataSource _data = HiveDataSource();

  @override
  Widget build(BuildContext context) {
    final receitaBox = Hive.box<Receita>('receitas');
    final despesaBox = Hive.box<Despesa>('despesas');

    return Scaffold(
      appBar: AppBar(title: const Text('Saldo Atual')),
      body: ValueListenableBuilder(
        valueListenable: receitaBox.listenable(),
        builder: (context, Box<Receita> receitas, _) {
          return ValueListenableBuilder(
            valueListenable: despesaBox.listenable(),
            builder: (context, Box<Despesa> despesas, _) {
              final saldo = _data.calcularSaldo();
              return Center(child: SaldoCard(saldo: saldo));
            },
          );
        },
      ),
    );
  }
}
