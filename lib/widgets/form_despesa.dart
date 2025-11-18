import 'package:flutter/material.dart';
import '../models/despesa.dart';
import '../datasource/hive_datasource.dart';

class FormDespesa extends StatefulWidget {
  const FormDespesa({super.key});

  @override
  State<FormDespesa> createState() => _FormDespesaState();
}

class _FormDespesaState extends State<FormDespesa> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final HiveDataSource _data = HiveDataSource();

  // Lista fixa de categorias — poderia vir do banco no futuro
  final List<String> _categorias = [
    'Alimentação',
    'Transporte',
    'Moradia',
    'Lazer',
    'Saúde',
    'Outros',
  ];

  String _categoriaSelecionada = 'Alimentação';

  /// Função de salvamento com validação
  void _salvar() {
    final descricao = _descricaoController.text;

    // ✔ aceita tanto 120,50 quanto 120.50
    final valorTexto = _valorController.text.replaceAll(',', '.');
    final valor = double.tryParse(valorTexto) ?? 0;

    if (descricao.isEmpty || valor <= 0) return;

    final despesa = Despesa(
      descricao: descricao,
      valor: valor,
      data: DateTime.now(),
      categoria: _categoriaSelecionada,
    );

    _data.addDespesa(despesa);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Despesa adicionada: $descricao'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );

    _descricaoController.clear();
    _valorController.clear();
    setState(() {
      _categoriaSelecionada = _categorias.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo de descrição
          TextFormField(
            controller: _descricaoController,
            decoration: const InputDecoration(labelText: 'Descrição'),
            validator: (value) =>
            value == null || value.isEmpty ? 'Informe uma descrição' : null,
          ),

          // Campo de valor
          TextFormField(
            controller: _valorController,
            decoration: const InputDecoration(labelText: 'Valor (R\$)'),
            keyboardType: TextInputType.number,
            validator: (value) {
              final val = double.tryParse(value ?? '');
              if (val == null || val <= 0) return 'Informe um valor válido';
              return null;
            },
          ),

          const SizedBox(height: 10),

          // Dropdown de categoria
          DropdownButtonFormField<String>(
            value: _categoriaSelecionada,
            decoration: const InputDecoration(labelText: 'Categoria'),
            items: _categorias.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Row(
                  children: [
                    Icon(_iconeCategoria(cat), color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Text(cat),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() {
              _categoriaSelecionada = value!;
            }),
          ),

          const SizedBox(height: 16),

          // Botão salvar
          ElevatedButton.icon(
            onPressed: _salvar,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Despesa'),
          ),
        ],
      ),
    );
  }

  /// Define ícones para cada categoria (melhor UX visual)
  IconData _iconeCategoria(String categoria) {
    switch (categoria) {
      case 'Alimentação':
        return Icons.restaurant;
      case 'Transporte':
        return Icons.directions_car;
      case 'Moradia':
        return Icons.home;
      case 'Lazer':
        return Icons.movie;
      case 'Saúde':
        return Icons.favorite;
      default:
        return Icons.attach_money;
    }
  }
}
