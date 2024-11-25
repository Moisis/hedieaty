import 'package:sqflite/sqflite.dart';
import '../database/DatabaseHelper.dart';
import '../models/user.dart';




class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertUser(User user) async {
    final db = await _dbHelper.database;
    return await db.insert('Users', user.toMap());
  }

  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'Users',
      user.toMap(),
      where: 'UserId = ?',
      whereArgs: [user.userId],
    );
  }

  Future<int> deleteUser(int userId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'Users',
      where: 'UserId = ?',
      whereArgs: [userId],
    );
  }

  Future<List<User>> fetchAllUsers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query('Users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<User?> fetchUserById(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'Users',
      where: 'UserId = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }
}
