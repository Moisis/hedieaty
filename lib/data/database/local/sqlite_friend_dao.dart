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
      where: 'UserId = ?', // Filter rows where user_id matches
      whereArgs: [userId],  // Provide the value for the placeholder
    );

    print("Got friends from SQLite: $maps");
    final friends = maps.map((map) => Friend.fromJson(map)).toList();
    print("Got friends from SQLite34: $friends");

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

  Future<Friend?> getFriendById(String userId) async {
    await _ensureInitialized();
    final maps = await db.query(
      'Friends',
      where: 'UserId = ?', // Filter rows where user_id matches
      whereArgs: [userId],  // Provide the value for the placeholder
    );
    if (maps.isEmpty) {
      return null;
    }
    return Friend.fromJson(maps.first);
  }

  Future<void> updateFriend(Friend friend) async {
    await _ensureInitialized();
    await db.update(
      'Friends',
      friend.toJson(),
      where: 'UserID = ?',
      whereArgs: [friend.UserId],
    );
  }





}