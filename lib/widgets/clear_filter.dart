import 'package:flutter/material.dart';

class ClearFilterButton extends StatelessWidget {
  final VoidCallback onClear;

  const ClearFilterButton({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onClear,
      icon: const Icon(Icons.clear, color: Colors.red),
      label: const Text("Limpar filtros", style: TextStyle(color: Colors.red)),
    );
  }
}
