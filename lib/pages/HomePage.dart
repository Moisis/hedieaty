import 'package:flutter/material.dart';
import 'package:hedieaty/components/AppColors.dart';



import '../components/widgets/BottomNavBar.dart';
import '../components/widgets/FriendList.dart';
import '../components/widgets/CustomAppBar.dart';


import '../modules/demoStorage.dart';
import '../modules/Event.dart';
import '../modules/Friend.dart';

import '../utils/navigationHelper.dart';

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
  late var _index = 2;
  late List<Event> sampleEvents ;
  late List<Friend> contacts ;



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleEvents = getEventList();
    contacts = getFriendList();
    print(contacts);
    for (var i = 0; i < contacts.length; i++) {
      print(contacts[i].name);

    }
  }



  Future<void> _refreshContacts() async {
    // Simulate a network call or any other async operation
    await Future.delayed(Duration(seconds: 2));

    //Todo : get contacts again with refresh
    // Update the contacts list (for demonstration purposes, we just shuffle the list)
    setState(() {
      contacts.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      navigateToPage(context, 4);
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add New Contact'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                  SizedBox(width: 16), // Spacing between buttons
                  ElevatedButton.icon(
                    onPressed: () {
                      navigateToPage(context, 4);
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                      'Create Your Own \nEvent/List',
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7 ,
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _refreshContacts,
                  child: FriendList(friends: contacts, searchQuery: searchText),
                ),
              ),
            ],
          ),
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