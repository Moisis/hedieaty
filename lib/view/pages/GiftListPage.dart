import 'package:flutter/material.dart';

import '../components/widgets/nav/BottomNavBar.dart';
import '../components/widgets/nav/CustomAppBar.dart';
import 'package:hedieaty/utils/navigationHelper.dart';


class GiftListPage extends StatefulWidget {
  const GiftListPage({super.key});

  @override
  State<GiftListPage> createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  late var _index = 3;


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
          setState(() {});
        },

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Gift List Page',
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
