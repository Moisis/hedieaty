import 'package:flutter/material.dart';
import 'package:hedieaty/components/AppColors.dart';
import '../components/widgets/ContactList.dart';
import '../components/widgets/CustomAppBar.dart';


import '../modules/Contact.dart';


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


  // Example list of contacts

  final List<Contact> contacts = [
    Contact(
      name: "John Doe",
      phoneNumber: "+1 234 567 890",
      profileImageUrl: "https://avatarfiles.alphacoders.com/365/thumb-1920-365881.png",
      events: 2,
    ),
    Contact(
      name: "Jane Smith",
      phoneNumber: "+1 987 654 321",
      profileImageUrl: "https://avatarfiles.alphacoders.com/365/thumb-1920-365881.png",
      events: 1,
    ),
    Contact(
      name: "Mike Johnson",
      phoneNumber: "+1 555 666 777",
      profileImageUrl: "https://avatarfiles.alphacoders.com/365/thumb-1920-365881.png",
    ),

    Contact(
      name: "Not Youssef ",
      phoneNumber: "+1 555 666 777",
      profileImageUrl: "https://avatars.githubusercontent.com/u/101019690?v=4",
      events: 0, // cuz he has Skill issue
    ),


    // Add more contacts here
  ];


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
      body: ContactList( contacts: contacts , searchQuery: searchText),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.primary.withOpacity(0.5),
        backgroundColor: AppColors.background,
      ),
    );
  }
}
