import 'package:flutter/material.dart';
import '../models/despesa.dart';
import '../datasource/hive_datasource.dart';

class FormDespesa extends StatefulWidget {
  const FormDespesa({super.key});

  @override
  State<FormDespesa> createState() => _FormDespesaState();
}

class _FormDespesaState extends State<FormDespesa> {
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final HiveDataSource _data = HiveDataSource();

  final List<String> _categorias = [
    'Alimentação',
    'Transporte',
    'Moradia',
    'Lazer',
    'Saúde',
    'Outros',
  ];
  String _categoriaSelecionada = 'Alimentação';

  void _salvar() {
    final descricao = _descricaoController.text;
    final valor = double.tryParse(_valorController.text) ?? 0;
    if (descricao.isEmpty || valor <= 0) return;

    final despesa = Despesa(
      descricao: descricao,
      valor: valor,
      data: DateTime.now(),
      categoria: _categoriaSelecionada,
    );

    _data.addDespesa(despesa);
    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Despesa adicionada: $descricao')));
    _descricaoController.clear();
    _valorController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _descricaoController,
          decoration: const InputDecoration(labelText: 'Descrição'),
        ),
        TextField(
          controller: _valorController,
          decoration: const InputDecoration(labelText: 'Valor (R\$)'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _categoriaSelecionada,
          decoration: const InputDecoration(labelText: 'Categoria'),
          items: _categorias
              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
              .toList(),
          onChanged: (value) => setState(() => _categoriaSelecionada = value!),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _salvar,
          child: const Text('Adicionar Despesa'),
        ),
      ],
    );
  }
}
