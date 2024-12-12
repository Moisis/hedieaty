import 'package:flutter/material.dart';

import '../components/widgets/nav/BottomNavBar.dart';
import '../components/widgets/nav/CustomAppBar.dart';

import 'package:hedieaty/utils/navigationHelper.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  late var _index = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Notifcation Page',
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
