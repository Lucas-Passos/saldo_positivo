import 'package:flutter/material.dart';

class SaldoCard extends StatelessWidget {
  final double saldo;
  const SaldoCard({super.key, required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Saldo Atual', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 10),
            Text(
              'R\$ ${saldo.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 36,
                color: saldo >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
