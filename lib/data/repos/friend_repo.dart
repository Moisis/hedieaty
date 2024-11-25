

import '../database/DatabaseHelper.dart';

class FriendRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> addFriend(int userId, int friendId) async {
    final db = await _dbHelper.database;
    return await db.insert('Friends', {'UserID': userId, 'FriendID': friendId});
  }

  Future<int> removeFriend(int userId, int friendId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'Friends',
      where: 'UserID = ? AND FriendID = ?',
      whereArgs: [userId, friendId],
    );
  }

  Future<List<int>> fetchFriendsOfUser(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'Friends',
      where: 'UserID = ?',
      whereArgs: [userId],
    );
    return result.map((map) => map['FriendID'] as int).toList();
  }
}
