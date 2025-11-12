import 'package:flutter/material.dart';
import '../models/receita.dart';
import '../datasource/hive_datasource.dart';

class FormReceita extends StatefulWidget {
  const FormReceita({super.key});

  @override
  State<FormReceita> createState() => _FormReceitaState();
}

class _FormReceitaState extends State<FormReceita> {
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final HiveDataSource _data = HiveDataSource();

  final List<String> _categorias = [
    'Salário',
    'Freelance',
    'Investimentos',
    'Outros',
  ];
  String _categoriaSelecionada = 'Salário';

  void _salvar() {
    final descricao = _descricaoController.text;
    final valor = double.tryParse(_valorController.text) ?? 0;
    if (descricao.isEmpty || valor <= 0) return;

    final receita = Receita(
      descricao: descricao,
      valor: valor,
      data: DateTime.now(),
      categoria: _categoriaSelecionada,
    );

    _data.addReceita(receita);
    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Receita adicionada: $descricao')));
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
          child: const Text('Adicionar Receita'),
        ),
      ],
    );
  }
}
