import 'package:flutter/material.dart';

class DateFilter extends StatelessWidget {
  final DateTime? dataInicial;
  final DateTime? dataFinal;
  final void Function(DateTime) onSelectDataInicial;
  final void Function(DateTime) onSelectDataFinal;

  const DateFilter({
    super.key,
    this.dataInicial,
    this.dataFinal,
    required this.onSelectDataInicial,
    required this.onSelectDataFinal,
  });

  Future<void> _pickDate({
    required BuildContext context,
    required DateTime? dataAtual,
    required void Function(DateTime) onSelected,
  }) async {
    final result = await showDatePicker(
      context: context,
      initialDate: dataAtual ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      onSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _pickDate(
              context: context,
              dataAtual: dataInicial,
              onSelected: onSelectDataInicial,
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                dataInicial == null
                    ? "Data inicial"
                    : "De: ${dataInicial!.day}/${dataInicial!.month}/${dataInicial!.year}",
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => _pickDate(
              context: context,
              dataAtual: dataFinal,
              onSelected: onSelectDataFinal,
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                dataFinal == null
                    ? "Data final"
                    : "Até: ${dataFinal!.day}/${dataFinal!.month}/${dataFinal!.year}",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
