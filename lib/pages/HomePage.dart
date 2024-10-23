import 'package:flutter/material.dart';

import '../components/widgets/CustomAppBar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isSearchClicked = false;
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  final Duration _animationDuration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isSearchClicked: isSearchClicked,
        searchController: _searchController,
        animationDuration: _animationDuration,
        onSearchChanged: (value) {
          setState(() {
            searchText = value;
          });
        },
        onSearchIconPressed: () {
          setState(() {
            if (isSearchClicked) {
              _searchController.clear();
            }
            isSearchClicked = !isSearchClicked;
          });
        },
        onSettingsIconPressed: () {
          // Handle settings button press
        },
      ),
      body: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter your username',
        ),
      ),
    );
  }

}
