import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add or update user data based on authId
  Future<String> addUser(String authId, String fcmToken) async {
    try {
      // Check if a user with the provided authId already exists
      final existingUser = await _checkForExistingUser(authId);

      if (existingUser != null) {
        // If user exists, update the FCM token
        await updateUser(existingUser.id, fcmToken: fcmToken);
        return existingUser.id; // Return the existing user ID
      }


       await _db.collection('Users').doc(authId).set({
        'fcm_token': fcmToken,
      });


      return authId ; // Return the new user ID
    } catch (e) {
      print('Error adding user: $e');
      rethrow; // Or handle more specifically
    }
  }

  // Check if a user with the provided authId already exists
  Future<DocumentSnapshot?> _checkForExistingUser(String authId) async {
    try {
      final docRef = _db.collection('Users').doc(authId);
      final doc = await docRef.get();

      if (doc.exists) {
        return doc;
      } else {
        return null;
      }
    } catch (e) {
      print('Error checking for existing user: $e');
      return null;
    }
  }

  // Get user data by user ID
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final docRef = _db.collection('Users').doc(userId);
      final doc = await docRef.get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }



  Future<String?> getFcm2(String userId) async {
    try {
      final doc = await _db.collection('Users').doc(userId).get();

      if (doc.exists && doc.data() != null) {

        return doc.data()?['fcm_token'];
      } else {
        print("No user found with ID: $userId");
        return null;
      }
    } catch (e) {
      print("Error fetching user object: $e");
      return null;
    }
  }



  // Update user data (authId and/or fcmToken)
  Future<void> updateUser(String userId, {String? authId, String? fcmToken}) async {
    try {
      final updateData = <String, dynamic>{};
      if (authId != null) updateData['auth_id'] = authId;
      if (fcmToken != null) updateData['fcm_token'] = fcmToken;

      if (updateData.isNotEmpty) {
        await _db.collection('Users').doc(authId ?? userId).update(updateData);
      }
    } catch (e) {
      print('Error updating user: $e');
      rethrow; // Or handle more specifically
    }
  }

  // Delete user data by user ID
  Future<bool> deleteUser(String userId) async {
    try {
      final docRef = _db.collection('Users').doc(userId);
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }
}
