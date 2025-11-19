import 'package:flutter/material.dart';

class ClearFilterButton extends StatelessWidget {
  final VoidCallback onClear;

  const ClearFilterButton({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.filter_alt_off_rounded, size: 20),
      label: const Text("Limpar filtros", style: TextStyle(fontSize: 15)),
      onPressed: onClear,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
