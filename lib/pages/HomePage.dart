import 'package:flutter/material.dart';
import 'package:hedieaty/components/AppColors.dart';


import '../components/widgets/BottomNavBar.dart';
import '../components/widgets/FriendList.dart';
import '../components/widgets/CustomAppBar.dart';
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

  // Example list of contacts
  List<Friend> contacts = [
    Friend(
      name: "John Doe",
      phoneNumber: "+1 234 567 890",
      profileImageUrl: "https://randomuser.me/api/portraits/men/1.jpg",
      events: 2,
    ),
    Friend(
      name: "Jane Smith",
      phoneNumber: "+1 987 654 321",
      profileImageUrl: "https://randomuser.me/api/portraits/women/2.jpg",
      events: 1,
    ),
    Friend(
      name: "Mike Johnson",
      phoneNumber: "+1 555 666 777",
      profileImageUrl: "https://randomuser.me/api/portraits/men/3.jpg",
      events: 4,
    ),
    Friend(
      name: "Alice Green",
      phoneNumber: "+1 222 333 444",
      profileImageUrl: "https://randomuser.me/api/portraits/women/4.jpg",
      events: 3,
    ),
    Friend(
      name: "Robert Brown",
      phoneNumber: "+1 321 654 987",
      profileImageUrl: "https://randomuser.me/api/portraits/men/5.jpg",
      events: 2,
    ),
    Friend(
      name: "Lucy Gray",
      phoneNumber: "+1 567 890 123",
      profileImageUrl: "https://randomuser.me/api/portraits/women/6.jpg",
      events: 1,
    ),
    Friend(
      name: "Tom Clark",
      phoneNumber: "+1 678 999 231",
      profileImageUrl: "https://randomuser.me/api/portraits/men/7.jpg",
      events: 5,
    ),
    Friend(
      name: "Emma White",
      phoneNumber: "+1 333 888 777",
      profileImageUrl: "https://randomuser.me/api/portraits/women/8.jpg",
      events: 4,
    ),
    Friend(
      name: "James Black",
      phoneNumber: "+1 789 012 345",
      profileImageUrl: "https://randomuser.me/api/portraits/men/9.jpg",
      events: 2,
    ),
    Friend(
      name: "Olivia King",
      phoneNumber: "+1 210 654 987",
      profileImageUrl: "https://randomuser.me/api/portraits/women/10.jpg",
      events: 3,
    ),
    Friend(
      name: "William Reed",
      phoneNumber: "+1 456 789 012",
      profileImageUrl: "https://randomuser.me/api/portraits/men/11.jpg",
      events: 1,
    ),
    Friend(
      name: "Sophia Adams",
      phoneNumber: "+1 321 765 432",
      profileImageUrl: "https://randomuser.me/api/portraits/women/12.jpg",
      events: 6,
    ),
    Friend(
      name: "Henry Lee",
      phoneNumber: "+1 999 123 456",
      profileImageUrl: "https://randomuser.me/api/portraits/men/13.jpg",
      events: 0,
    ),
    Friend(
      name: "Mia Scott",
      phoneNumber: "+1 456 321 678",
      profileImageUrl: "https://randomuser.me/api/portraits/women/14.jpg",
      events: 2,
    ),
    Friend(
      name: "David Allen",
      phoneNumber: "+1 777 888 999",
      profileImageUrl: "https://randomuser.me/api/portraits/men/15.jpg",
      events: 4,
    ),
    Friend(
      name: "Charlotte Walker",
      phoneNumber: "+1 888 999 000",
      profileImageUrl: "https://randomuser.me/api/portraits/women/16.jpg",
      events: 1,
    ),
    Friend(
      name: "Daniel Martin",
      phoneNumber: "+1 101 202 303",
      profileImageUrl: "https://randomuser.me/api/portraits/men/17.jpg",
      events: 2,
    ),
    Friend(
      name: "Amelia Thomas",
      phoneNumber: "+1 404 505 606",
      profileImageUrl: "https://randomuser.me/api/portraits/women/18.jpg",
      events: 5,
    ),
    Friend(
      name: "Lucas Hill",
      phoneNumber: "+1 505 606 707",
      profileImageUrl: "https://randomuser.me/api/portraits/men/19.jpg",
      events: 1,
    ),
    Friend(
      name: "Ella Rivera",
      phoneNumber: "+1 606 707 808",
      profileImageUrl: "https://randomuser.me/api/portraits/women/20.jpg",
      events: 3,
    ),
  ];



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
                  ElevatedButton(
                    onPressed: () {
                      navigateToPage(context, 4);
                    },
                    child: Text('Go to Profile Page'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      navigateToPage(context, 4);
                    },
                    child: Text('Go to Profile Page'),
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