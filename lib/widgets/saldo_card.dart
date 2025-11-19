// saldo_card.dart
import 'package:flutter/material.dart';

class SaldoCard extends StatelessWidget {
  final double saldo;
  const SaldoCard({super.key, required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      // 🌟 Centraliza horizontalmente o SaldoCard na tela,
      // fazendo-o ocupar toda a largura disponível.
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          // 💡 ALTERAÇÃO 1: Fazer o Column esticar a largura máxima.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // 💡 ALTERAÇÃO 2: Garantir que a coluna só ocupe o espaço necessário verticalmente.
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Saldo Atual',
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ), // 💡 ALTERAÇÃO 3: Centraliza o texto
            const SizedBox(height: 10),
            Text(
              'R\$ ${saldo.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 36,
                color: saldo >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // 💡 ALTERAÇÃO 4: Centraliza o texto
            ),
          ],
        ),
      ),
    );
  }
}
