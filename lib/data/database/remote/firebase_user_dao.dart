import 'package:firebase_database/firebase_database.dart';
import '../../models/user.dart';

class FirebaseUserDataSource {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('Users');

  Stream<List<UserModel>> getUsersStream() {
    return dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return data.entries
          .map((entry) => UserModel.fromJson(Map<String, dynamic>.from(entry.value)))
          .toList();
    });
  }

  Future<void> addUser(UserModel user) async {
    await dbRef.child(user.UserId).set(user.toJson());
  }

  Future<void> updateUser(UserModel user) async {
    await dbRef.child(user.UserId).update(user.toJson());
  }

  Future<void> deleteUser(String id) async {
    await dbRef.child(id).remove();
  }

  Future<UserModel?> getUserById(String id) async {
    final snapshot = await dbRef.child(id).get();
    if (!snapshot.exists) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
  }

  Future<List<UserModel>> getUsers() async {
    final snapshot = await dbRef.get();
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((entry) => UserModel.fromJson(Map<String, dynamic>.from(entry.value)))
        .toList();
  }
}
