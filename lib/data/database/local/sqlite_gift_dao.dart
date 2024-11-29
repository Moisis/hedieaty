import 'package:sqflite/sqflite.dart';

import '../../models/gift.dart';
import 'SQLite.dart';

class SQLiteGiftDataSource {

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

  Future<List<Gift>> getUsers() async {
    await _ensureInitialized();
    final maps = await db.query('Gifts');
    return maps.map((map) => Gift.fromJson(map)).toList();
  }

  Future<void> addGift(Gift gift) async {
    await _ensureInitialized();
    await db.insert('Gifts', gift.toJson());
  }

  Future<void> updateGift(Gift gift) async {
    await _ensureInitialized();
    await db.update('Gifts', gift.toJson(), where: 'GiftId = ?', whereArgs: [gift.GiftId]);
  }

  Future<void> deleteUser(String id) async {
    await _ensureInitialized();
    await db.delete('Gifts', where: 'GiftId = ?', whereArgs: [id]);
  }

  Future<Gift?> getUserById(String id) async {
    await _ensureInitialized();
    final maps = await db.query('Gifts', where: 'GiftId = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Gift.fromJson(maps.first);
  }
}