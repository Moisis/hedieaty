import 'package:sqflite/sqflite.dart';

import '../../models/user.dart';
import 'SQLite.dart';

class SQLiteUserDataSource {

  late Database db;
  bool _isInitialized = false;

  Future<void> init() async {
    db = await DatabaseHelper().database; // Use DatabaseHelper to get the database instance
    _isInitialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  Future<List<UserModel>> getUsers() async {
    await _ensureInitialized();
    final maps = await db.query('Users');
    return maps.map((map) => UserModel.fromJson(map)).toList();
  }

  Future<void> addUser(UserModel user) async {
    await _ensureInitialized();
    try {
      await db.insert('Users', user.toJson());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        await updateUser(user);
      } else {
        rethrow;
      }
    }
  }


  Future<void> updateUser(UserModel user) async {
    await _ensureInitialized();
    await db.update('Users', user.toJson(), where: 'UserId = ?', whereArgs: [user.UserId]);
  }

  Future<void> deleteUser(String id) async {
    await _ensureInitialized();
    await db.delete('Users', where: 'UserId = ?', whereArgs: [id]);
  }

  Future<UserModel?> getUserById(String id) async {
    await _ensureInitialized();
    final maps = await db.query('Users', where: 'UserId = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return UserModel.fromJson(maps.first);
  }


}