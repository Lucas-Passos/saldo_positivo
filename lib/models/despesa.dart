import 'package:hive/hive.dart';
part 'despesa.g.dart';

@HiveType(typeId: 2)
class Despesa extends HiveObject {
  @HiveField(0)
  String descricao;

  @HiveField(1)
  double valor;

  @HiveField(2)
  DateTime data;

  @HiveField(3)
  String categoria;

  Despesa({
    required this.descricao,
    required this.valor,
    required this.data,
    required this.categoria,
  });
}
