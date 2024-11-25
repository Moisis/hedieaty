

import '../database/DatabaseHelper.dart';
import '../models/gift.dart';


class GiftRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertGift(Gift gift) async {
    final db = await _dbHelper.database;
    return await db.insert('Gifts', gift.toMap());
  }

  Future<int> updateGift(Gift gift) async {
    final db = await _dbHelper.database;
    return await db.update(
      'Gifts',
      gift.toMap(),
      where: 'GiftId = ?',
      whereArgs: [gift.giftId],
    );
  }

  Future<int> deleteGift(int giftId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'Gifts',
      where: 'GiftId = ?',
      whereArgs: [giftId],
    );
  }

  Future<List<Gift>> fetchAllGifts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query('Gifts');
    return result.map((map) => Gift.fromMap(map)).toList();
  }

  Future<Gift?> fetchGiftById(int giftId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'Gifts',
      where: 'GiftId = ?',
      whereArgs: [giftId],
    );
    if (result.isNotEmpty) {
      return Gift.fromMap(result.first);
    }
    return null;
  }
}
