import 'package:flutter/material.dart';

class DateFilter extends StatelessWidget {
  final DateTime? dataInicial;
  final DateTime? dataFinal;
  final void Function(DateTime?) onSelectDataInicial;
  final void Function(DateTime?) onSelectDataFinal;

  const DateFilter({
    super.key,
    required this.dataInicial,
    required this.dataFinal,
    required this.onSelectDataInicial,
    required this.onSelectDataFinal,
  });

  Future<void> _selecionarData({
    required BuildContext context,
    required DateTime? atual,
    required void Function(DateTime?) onSelect,
  }) async {
    final novaData = await showDatePicker(
      context: context,
      initialDate: atual ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (novaData != null) onSelect(novaData);
  }

  String _formatar(DateTime? dt) {
    if (dt == null) return "--/--/----";
    return "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/"
        "${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _selecionarData(
              context: context,
              atual: dataInicial,
              onSelect: onSelectDataInicial,
            ),
            child: Text("Início: ${_formatar(dataInicial)}"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _selecionarData(
              context: context,
              atual: dataFinal,
              onSelect: onSelectDataFinal,
            ),
            child: Text("Fim: ${_formatar(dataFinal)}"),
          ),
        ),
      ],
    );
  }
}
