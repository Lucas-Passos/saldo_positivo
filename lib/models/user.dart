import 'package:hive/hive.dart';

// LINHA CRÍTICA CORRIGIDA: Agora referencia 'user.g.dart'
// Este arquivo será gerado ao rodar o build_runner.
part 'user.g.dart';

// O 'typeId' deve ser único no seu projeto.
@HiveType(typeId: 3)
class UserModel extends HiveObject {
  // Campo 0
  @HiveField(0)
  String email;

  // Campo 1
  @HiveField(1)
  String senha;

  UserModel({required this.email, required this.senha});

  @override
  String toString() {
    return 'UserModel(email: $email, senha: ********)';
  }
}
