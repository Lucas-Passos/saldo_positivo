import 'package:hive/hive.dart';
part 'receita.g.dart';

@HiveType(typeId: 1)
class Receita extends HiveObject {
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
