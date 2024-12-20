import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/domain/usecases/user/getUserAuthId.dart';
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
  late GetUserAuthId getUserAuthIdUseCase;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    try {
      final giftRepository = GiftRepositoryImpl(
        sqliteDataSource: SQLiteGiftDataSource(),
        firebaseDataSource: FirebaseGiftDataSource(),
      );

      syncGiftsUseCase = SyncGifts(giftRepository);

      final userRepository = UserRepositoryImpl(
        sqliteDataSource: SQLiteUserDataSource(),
        firebaseDataSource: FirebaseUserDataSource(),
        firebaseAuthDataSource: FirebaseAuthDataSource(),
      );

      final eventRepository = EventRepositoryImpl(
        sqliteDataSource: SQLiteEventDataSource(),
        firebaseDataSource: FirebaseEventDataSource(),
      );

      final friendRepository = FriendRepositoryImpl(
        sqliteDataSource: SQLiteFriendDataSource(),
        firebaseDataSource: FirebaseFriendDataSource(),
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
    } catch (e) {
      // Handle errors gracefully
      print('Error during initialization: $e');
    } finally {
      // Clean up resources, if necessary
      FlutterNativeSplash.remove();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.getBool('isFirstTime') ?? prefs.setBool('isFirstTime', true);
      if (prefs.getBool('isFirstTime')  == true) {
        prefs.setBool('isFirstTime', false);
        Navigator.pushReplacementNamed(context, '/onboarding');
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      key : const ValueKey('intro_page2'),
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/home_page');
          });
          return Container(); // Return an empty container while navigating
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return Container(); // Return an empty container while navigating
        }
      },
    );
  }
}