import 'package:flutter/material.dart';
import '../widgets/saldo_card.dart';

class ResultadoScreen extends StatelessWidget {
  const ResultadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: SaldoCard(saldo: 0.0)), // saldo calculado futuramente
    );
  }
}
