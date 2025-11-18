import 'package:flutter/material.dart';
import '../models/receita.dart';
import '../datasource/hive_datasource.dart';

class FormReceita extends StatefulWidget {
  const FormReceita({super.key});

  @override
  State<FormReceita> createState() => _FormReceitaState();
}

class _FormReceitaState extends State<FormReceita> {
  // 🔑 Variáveis de controle de formulário
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final HiveDataSource _data = HiveDataSource();

  // Lista fixa de categorias de Receita
  final List<String> _categorias = [
    'Salário',
    'Freelance',
    'Investimentos',
    'Presente',
    'Outros',
  ];

  String _categoriaSelecionada = 'Salário';

  /// Função de salvamento com validação
  void _salvar() {
    // 1. Validação do formulário
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final descricao = _descricaoController.text;

    // ✔ Aceita tanto 120,50 quanto 120.50 (igual ao form_despesa)
    final valorTexto = _valorController.text.replaceAll(',', '.');
    final valor = double.tryParse(valorTexto) ?? 0;

    // A validação do Formulário já cobre a maioria dos erros, mas verificamos o valor por segurança
    if (valor <= 0) return;

    final receita = Receita(
      descricao: descricao,
      valor: valor,
      data: DateTime.now(),
      categoria: _categoriaSelecionada,
    );

    // 2. Salva no Hive
    _data.addReceita(receita);

    // 3. Feedback e Limpeza
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receita adicionada: $descricao'),
        backgroundColor: Colors.green,
      ),
    );
    _descricaoController.clear();
    _valorController.clear();

    // Notifica a tela pai para reconstruir e mostrar a nova receita,
    // embora o ValueListenableBuilder faça isso de forma reativa.
    setState(() {});
  }

  // Define ícones para cada categoria (para um melhor UX visual, espelhando form_despesa)
  IconData _iconeCategoria(String categoria) {
    switch (categoria) {
      case 'Salário':
        return Icons.work;
      case 'Freelance':
        return Icons.laptop_mac;
      case 'Investimentos':
        return Icons.trending_up;
      case 'Presente':
        return Icons.card_giftcard;
      default:
        return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 📝 Descrição
          TextFormField(
            controller: _descricaoController,
            decoration: const InputDecoration(labelText: 'Descrição'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Insira uma descrição para a receita';
              }
              return null;
            },
          ),

          // 💰 Valor
          TextFormField(
            controller: _valorController,
            decoration: const InputDecoration(labelText: 'Valor (R\$)'),
            keyboardType: TextInputType.number,
            validator: (value) {
              final valorTexto = value!.replaceAll(',', '.');
              if (double.tryParse(valorTexto) == null ||
                  double.tryParse(valorTexto)! <= 0) {
                return 'Insira um valor válido e positivo';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // 🏷️ Dropdown de categoria
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

          // ➕ Botão salvar
          ElevatedButton.icon(
            onPressed: _salvar,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Adicionar Receita',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ],
      ),
    );
  }
}
