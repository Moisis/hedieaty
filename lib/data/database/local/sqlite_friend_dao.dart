import 'package:hedieaty/domain/entities/friend_entity.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/friend.dart';
import 'SQLite.dart';

class SQLiteFriendDataSource {

  late Database db;
  bool _isInitialized = false;

  Future<void> init() async {
    db = await DatabaseHelper().database;
    _isInitialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  Future<List<Friend>> getFriends(String userId) async {
    await _ensureInitialized();
    final maps = await db.query(
      'Friends',
      where: 'UserID = ?', // Filter rows where user_id matches
      whereArgs: [userId],  // Provide the value for the placeholder
    );
    final friends = maps.map((map) => Friend.fromJson(map)).toList();
    return friends;
  }


  Future<void> addFriend(Friend friend) async {
    await _ensureInitialized();
    await db.insert('Friends', friend.toJson());
  }

  Future<void> deleteFriend(String userId) async {
    await _ensureInitialized();
    await db.delete(
      'Friends',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }





}