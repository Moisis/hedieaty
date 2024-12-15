import 'package:flutter/material.dart';
import 'package:hedieaty/domain/usecases/user/Logout_user.dart';
import 'package:hedieaty/view/components/widgets/buttons/CustomButton.dart';
import 'package:hedieaty/view/components/widgets/nav/CustomAppBar.dart';

import '../../data/database/remote/firebase_auth.dart';
import '../../data/repos/user_repository_impl.dart';
import '../components/widgets/nav/BottomNavBar.dart';


import 'package:hedieaty/data/testback/Friend.dart';
import 'package:hedieaty/data/testback/demoStorage.dart';

import 'package:hedieaty/utils/navigationHelper.dart';


class ProfilePage extends StatefulWidget {

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late var _index = 2;

  late LogoutUser logoutUser;



  Future<void> _initialize() async {
    try {
      // final sqliteDataSource = SQLiteUserDataSource();
      // final firebaseDataSource = FirebaseUserDataSource();

      // final sqliteEventSource = SQLiteEventDataSource();
      // final firebaseEventSource = FirebaseEventDataSource();
      //
      final firebaseAuthDataSource = FirebaseAuthDataSource();
      //
      // final sqliteFriendSource = SQLiteFriendDataSource();
      // final firebaseFriendSource = FirebaseFriendDataSource();

      final userRepository = UserRepositoryImpl(
        // sqliteDataSource: sqliteDataSource,
        // firebaseDataSource: firebaseDataSource,
        firebaseAuthDataSource: firebaseAuthDataSource,
      );

      logoutUser = LogoutUser(userRepository);

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

  final Friend friend = getFriendList().first;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
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
                  backgroundImage: NetworkImage(friend.profileImageUrl),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold , color:  Color(0x80000000),),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'No bio available',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Account Information'),
            subtitle: Text('Change your account information'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.supervisor_account_sharp),
            title: Text('Friends'),
            subtitle: Text('Manage friends'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Pledged Gifts'),
            subtitle: Text('Manage payment methods'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {

              Navigator.pushNamed(context, '/pledgedGifts');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            subtitle:
            Text('Change Options'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {

              Navigator.pushNamed(context, '/settings_page');
            },
          ),
          Divider(),
          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: Text('Logout'),
          //   subtitle: Text('Logout from your account'),
          //   trailing: Icon(Icons.arrow_forward_ios_rounded),
          //   onTap: () {},
          // ),

          Spacer(),
          Custom_button(
              title: 'Logout',
              onPress: () {
                _logout(context);
          }

          ),
          Spacer(),

        ],
      ),
      bottomNavigationBar: Bottomnavbar(
        currentIndex: _index,
        onIndexChanged: (index) {
          setState(() {
            _index = index;
            navigateToPage(context , _index);
          });
        },
      ),
    );
  }
}

