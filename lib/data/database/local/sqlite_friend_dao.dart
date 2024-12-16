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

  Future<List<Friend>?> getFriends(String userId) async {
    await _ensureInitialized();
    final maps = await db.query(
      'Friends',
      where: 'UserId = ?', // Filter rows where user_id matches
      whereArgs: [userId],  // Provide the value for the placeholder
    );
    if (maps.isEmpty) {
      return null;
    }
    print("Got friends from SQLite: $maps");

    final friends = maps.map((map) => Friend.fromJson(map)).toList();
    print("Got friends from SQLite34: $friends");
    return friends;

  }


  Future<void> addFriend(Friend friend) async {
    await _ensureInitialized();
    await db.insert(
      'Friends',
      friend.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final friend2 = Friend(FriendId: friend.UserId, UserId: friend.FriendId);
    await db.insert(
      'Friends',
      friend2.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFriend(Friend friend) async {
    await _ensureInitialized();
    await db.delete(
      'Friends',
      where: 'UserId = ?',
      whereArgs: [friend.UserId],
    );

    await db.delete(
      'Friends',
      where: 'UserId = ?',
      whereArgs: [friend.FriendId],
    );
  }

  Future<List<Friend>?> getFriendById(String userId , String friendId) async {
    await _ensureInitialized();
    final maps = await db.query(
      'Friends',
      where: 'UserId = ? AND FriendId = ?', // Filter rows where user_id matches
      whereArgs: [userId , friendId],  // Provide the value for the placeholder
    );
    if (maps.isEmpty) {
      return null;
    }
    // return Friend.fromJson(maps.first);
    final friends = maps.map((map) {
      final friendId = map['FriendId'] ?? '';
      final userId = map['UserId'] ?? '';
      return Friend(FriendId: friendId.toString(), UserId: userId.toString());
    }).toList();
    print("Got friends from SQLite341: $friends");

    return friends;
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