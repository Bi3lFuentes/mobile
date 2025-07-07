import '../AppDatabase.dart';
import '../model/User.dart';

class UserDao {
  static const String table = 'users';

  Future<int> insertUser(User user) async {
    final db = await AppDatabase().database;
    return db.insert(table, user.toMap());
  }

  Future<User?> getUser(String email, String password) async {
    final db = await AppDatabase().database;
    final result = await db.query(table,
        where: 'email = ? AND paswword = ?',
        whereArgs: [email, password]);
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }
}