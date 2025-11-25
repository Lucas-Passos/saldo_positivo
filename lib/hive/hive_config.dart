import 'package:hive/hive.dart';
import '../models/user_model.dart';

class HiveConfig {
  static const String usersBox = 'usersBox';
  static const String sessionBox = 'sessionBox';

  static Future<void> openBoxes() async {
    await Hive.openBox<User>(usersBox);
    await Hive.openBox(sessionBox);
  }

  static Box<User> getUsersBox() => Hive.box<User>(usersBox);
  static Box getSessionBox() => Hive.box(sessionBox);
}
