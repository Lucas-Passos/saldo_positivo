// lib/models/receita.dart

import 'package:hive/hive.dart';

// Importante: Referencia o arquivo gerado
part 'receita.g.dart';

// Define a CLASSE Receita com o typeId reservado
@HiveType(typeId: 1)
class Receita extends HiveObject {
  // Os campos (Fields) devem bater com o que está no receita.g.dart!

  @HiveField(0)
  String descricao;

  @HiveField(1)
  double valor;

  @HiveField(2)
  DateTime data;

  @HiveField(3)
  String categoria;

  Receita({
    required this.descricao,
    required this.valor,
    required this.data,
    required this.categoria,
  });
}
