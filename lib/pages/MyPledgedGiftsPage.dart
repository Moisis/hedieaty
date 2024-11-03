import 'package:flutter/material.dart';

import '../components/widgets/nav/BottomNavBar.dart';
import '../components/widgets/nav/CustomAppBar.dart';
import '../utils/navigationHelper.dart';

class PledgedGiftsPage extends StatefulWidget {
  const PledgedGiftsPage({super.key});

  @override
  State<PledgedGiftsPage> createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {

  late var _index = 1;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        isSearchClicked: false,
        searchController: TextEditingController(),
        animationDuration: Duration(milliseconds: 300),
        onSearchChanged: (value) {

        },
        onSearchIconPressed: () {
          setState(() {

          });
        },

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Pledged Gifts Page',
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
