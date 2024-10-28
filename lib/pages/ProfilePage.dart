import 'package:flutter/material.dart';
import 'package:hedieaty/components/widgets/CustomAppBar.dart';

import '../components/widgets/BottomNavBar.dart';
import '../utils/navigationHelper.dart';

class ProfilePage extends StatefulWidget {



  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late var _index = 4;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(

        onSettingsIconPressed: () {
          // Handle settings button press
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Profile Page',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
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
