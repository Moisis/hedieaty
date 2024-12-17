import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../data/database/local/sqlite_event_dao.dart';
import '../../../data/database/local/sqlite_friend_dao.dart';
import '../../../data/database/local/sqlite_gift_dao.dart';
import '../../../data/database/local/sqlite_user_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_event_dao.dart';
import '../../../data/database/remote/firebase_friend_dao.dart';
import '../../../data/database/remote/firebase_gift_dao.dart';
import '../../../data/database/remote/firebase_user_dao.dart';
import '../../../data/repos/event_repository_impl.dart';
import '../../../data/repos/friend_repository_impl.dart';
import '../../../data/repos/gift_repository_impl.dart';
import '../../../data/repos/user_repository_impl.dart';
import '../../../domain/usecases/event/sync_events.dart';
import '../../../domain/usecases/friend/sync_Friends.dart';
import '../../../domain/usecases/gifts/sync_gifts.dart';
import '../../../domain/usecases/user/sync_users.dart';

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late SyncUsers syncUsersUseCase;
  late SyncFriends syncFriendsUseCase;
  late SyncEvents syncEventsUseCase;
  late SyncGifts syncGiftsUseCase;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {


    try {
      final sqliteDataSource = SQLiteUserDataSource();
      final firebaseDataSource = FirebaseUserDataSource();
      final firebaseAuthDataSource = FirebaseAuthDataSource();

      final sqliteEventSource = SQLiteEventDataSource();
      final firebaseEventSource = FirebaseEventDataSource();

      final sqliteFriendSource = SQLiteFriendDataSource();
      final firebaseFriendSource = FirebaseFriendDataSource();

      final sqliteGiftDataSource = SQLiteGiftDataSource();
      final firebaseGiftDataSource = FirebaseGiftDataSource();

      final giftRepository = GiftRepositoryImpl(
        sqliteDataSource: sqliteGiftDataSource,
        firebaseDataSource: firebaseGiftDataSource,
      );

      syncGiftsUseCase = SyncGifts(giftRepository);

      final userRepository = UserRepositoryImpl(
        sqliteDataSource: sqliteDataSource,
        firebaseDataSource: firebaseDataSource,
        firebaseAuthDataSource: firebaseAuthDataSource,
      );

      final eventRepository = EventRepositoryImpl(
        sqliteDataSource: sqliteEventSource,
        firebaseDataSource: firebaseEventSource,
      );

      final friendRepository = FriendRepositoryImpl(
        sqliteDataSource: sqliteFriendSource,
        firebaseDataSource: firebaseFriendSource,
      );

      syncEventsUseCase = SyncEvents(eventRepository);
      syncUsersUseCase = SyncUsers(userRepository);
      syncFriendsUseCase = SyncFriends(friendRepository);

      // Wait for all synchronization tasks to complete
      await Future.wait([
        syncUsersUseCase.call(),
        syncFriendsUseCase.call(),
        syncEventsUseCase.call(),
        syncGiftsUseCase.call(),
      ]);

      // Navigate to the login screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // Handle errors gracefully, e.g., show an error message or retry
      print('Error during initialization: $e');
      // Optionally, navigate to an error screen or show a dialog
    }
    finally {
      // Clean up resources, if necessary
      FlutterNativeSplash.remove();

    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}