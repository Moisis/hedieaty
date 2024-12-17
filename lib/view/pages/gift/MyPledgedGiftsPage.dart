import 'package:flutter/material.dart';

import '../../components/widgets/nav/CustomAppBar.dart';



class PledgedGiftsPage extends StatefulWidget {
  const PledgedGiftsPage({super.key});

  @override
  State<PledgedGiftsPage> createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        title: 'Pledged Gifts ',
        showBackButton: true,
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


    );
  }
}
