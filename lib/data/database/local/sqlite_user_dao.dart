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

  Future<List<User>> getUsers() async {
    await _ensureInitialized();
    final maps = await db.query('Users');
    return maps.map((map) => User.fromJson(map)).toList();
  }

  Future<void> addUser(User user) async {
    await _ensureInitialized();
    await db.insert('Users', user.toJson());
  }

  Future<void> updateUser(User user) async {
    await _ensureInitialized();
    await db.update('Users', user.toJson(), where: 'UserId = ?', whereArgs: [user.UserId]);
  }

  Future<void> deleteUser(String id) async {
    await _ensureInitialized();
    await db.delete('Users', where: 'UserId = ?', whereArgs: [id]);
  }

  Future<User?> getUserById(String id) async {
    await _ensureInitialized();
    final maps = await db.query('Users', where: 'UserId = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return User.fromJson(maps.first);
  }
}