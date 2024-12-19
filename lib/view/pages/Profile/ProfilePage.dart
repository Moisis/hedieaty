
import 'package:flutter/material.dart';
import 'package:hedieaty/domain/entities/user_entity.dart';
import 'package:hedieaty/domain/usecases/user/Logout_user.dart';
import 'package:hedieaty/domain/usecases/user/getUserAuthId.dart';

import 'package:hedieaty/view/components/widgets/nav/CustomAppBar.dart';

import '../../../data/database/local/sqlite_user_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_user_dao.dart';
import '../../../data/repos/user_repository_impl.dart';
import '../../../domain/usecases/user/getUserbyId.dart';

import '../../components/widgets/nav/BottomNavBar.dart';



import 'package:hedieaty/utils/navigationHelper.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late var _index = 2;

  late LogoutUser logoutUser;
  late GetUserById getUserById;
  late GetUserAuthId getUserAuthId;
  UserEntity user = UserEntity(
      UserId: '',
      UserName: '',
      UserEmail: '',
      UserPass: '',
      UserPrefs: '',
      UserPhone: '');

  Future<void> _initialize() async {
    try {
      final sqliteDataSource = SQLiteUserDataSource();
      final firebaseDataSource = FirebaseUserDataSource();

      // final sqliteEventSource = SQLiteEventDataSource();
      // final firebaseEventSource = FirebaseEventDataSource();
      //
      final firebaseAuthDataSource = FirebaseAuthDataSource();
      //
      // final sqliteFriendSource = SQLiteFriendDataSource();
      // final firebaseFriendSource = FirebaseFriendDataSource();

      final userRepository = UserRepositoryImpl(
        sqliteDataSource: sqliteDataSource,
        firebaseDataSource: firebaseDataSource,
        firebaseAuthDataSource: firebaseAuthDataSource,
      );

      logoutUser = LogoutUser(userRepository);
      getUserById = GetUserById(userRepository);
      getUserAuthId = GetUserAuthId(userRepository);

      var userAuthID = await getUserAuthId.call();
      final user2 = await getUserById.call(userAuthID);

      setState(() {
        user = user2;
      });
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _logout(BuildContext context) {
    logoutUser.call();
    Navigator.pushReplacementNamed(context, '/register');
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile Page',
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      'https://www.pngkey.com/png/full/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.UserName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0x80000000),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        user.UserEmail,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          // ListTile(
          //   leading: Icon(Icons.person),
          //   title: Text('Account Information'),
          //   subtitle: Text('Change your account information'),
          //   trailing: Icon(Icons.arrow_forward_ios_rounded),
          //   onTap: () async {
          //
          //     var userMap = await _firestoreService.getFcm2(user.UserId);
          //     fcm_token = userMap;
          //     print(fcm_token);
          //     if (fcm_token != null) {
          //       Future.wait(
          //         [_notificationService.sendNotification(fcm_token!, 'Account Information', 'Change your account information')]
          //       ) ;
          //     } else {
          //       print('FCM token is null');
          //     }
          //
          //   },
          // ),
          // Divider(),

          ListTile(
            leading: Icon(Icons.event),
            title: Text('Events'),
            subtitle: Text('Manage events'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.supervisor_account_sharp),
            title: Text('Friends'),
            subtitle: Text('Manage friends'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.pushNamed(context, '/manageFriends');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Pledged Gifts'),
            subtitle: Text('Manage Pledged Gifts'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.pushNamed(context, '/pledgedGifts');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            subtitle: Text('Change Options'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.pushNamed(context, '/settings_page');
            },
          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            subtitle: Text('Logout from your account'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              _logout(context);
            },
          ),

          // Custom_button(
          //     title: 'Logout',
          //     onPress: () {
          //       _logout(context);
          //     }),
        ],
      ),
      bottomNavigationBar: Bottomnavbar(
        currentIndex: _index,
        onIndexChanged: (index) {
          setState(() {
            _index = index;
            navigateToPage(context, _index);
          });
        },
      ),
    );
  }
}
