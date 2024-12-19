import 'package:sqflite/sqflite.dart';

import '../../models/gift.dart';
import 'SQLite.dart';

class SQLiteGiftDataSource {

  late Database db;
  bool _isInitialized = false;

  Future<void> init() async {
    db = await DatabaseHelper()
        .database; // Use DatabaseHelper to get the database instance
    _isInitialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  Future<List<Gift>> getGifts() async {
    await _ensureInitialized();
    final maps = await db.query('Gifts');
    return maps.map((map) => Gift.fromJson(map)).toList();
  }

  Future<void> addGift(Gift gift) async {
    await _ensureInitialized();
    await db.insert('Gifts', gift.toJson());
  }

  Future<void> updateGift(Gift gift) async {
    print('updateGift');
    await _ensureInitialized();
    await db.update(
        'Gifts', gift.toJson(), where: 'GiftId = ?', whereArgs: [gift.GiftId]);
  }

  Future<void> deleteGift(String id) async {
    await _ensureInitialized();
    await db.delete('Gifts', where: 'GiftId = ?', whereArgs: [id]);
  }


  Future<Gift?> getGiftById(String id) async {

    await _ensureInitialized();
    final List<Map<String, dynamic>> maps = await db.query(
      'gifts',
      where: 'GiftId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Gift.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<void> deleteAllGifts() async {
    await _ensureInitialized();
    await db.delete('Gifts');
  }

  Future<List<Gift>> getGiftsListbyEventId(String eventId) async {
    await _ensureInitialized();
    final maps = await db.query('Gifts', where: 'GiftEventId = ?', whereArgs: [eventId]);
    return maps.map((map) => Gift.fromJson(map)).toList();
  }


  Future<List<Gift>> getPledgedGifts(String userid) async {
    await _ensureInitialized();
    final maps = await db.query('Gifts', where: 'GiftStatus = ?', whereArgs: [userid]);
    return maps.map((map) => Gift.fromJson(map)).toList();
  }


  Future<void> deleteGiftsEvent(String Eventid) async {
    await _ensureInitialized();
    await db.delete('Gifts', where: 'GiftEventId = ?', whereArgs: [Eventid]);
  }




}