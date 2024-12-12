import 'package:firebase_database/firebase_database.dart';
import '../../models/user.dart';

class FirebaseUserDataSource {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('Users');

  Stream<List<User>> getUsersStream() {
    return dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return data.entries
          .map((entry) => User.fromJson(Map<String, dynamic>.from(entry.value)))
          .toList();
    });
  }

  Future<void> addUser(User user) async {
    await dbRef.child(user.UserId).set(user.toJson());
  }

  Future<void> updateUser(User user) async {
    await dbRef.child(user.UserId).update(user.toJson());
  }

  Future<void> deleteUser(String id) async {
    await dbRef.child(id).remove();
  }

  Future<User?> getUserById(String id) async {
    final snapshot = await dbRef.child(id).get();
    if (!snapshot.exists) return null;
    return User.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
  }

  Future<List<User>> getUsers() async {
    final snapshot = await dbRef.get();
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((entry) => User.fromJson(Map<String, dynamic>.from(entry.value)))
        .toList();
  }
}
