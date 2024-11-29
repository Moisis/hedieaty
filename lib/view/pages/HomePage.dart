import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:hedieaty/view/components/AppColors.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hedieaty/view/components/widgets/buttons/CustomButton.dart';

import '../components/widgets/buttons/Circular_small_Button.dart';
import '../components/widgets/nav/BottomNavBar.dart';
import '../components/widgets/FriendList.dart';
import '../components/widgets/nav/CustomAppBar.dart';

import 'package:hedieaty/modules/demoStorage.dart';
import 'package:hedieaty/modules/Event.dart';
import 'package:hedieaty/modules/Friend.dart';


import 'package:hedieaty/utils/navigationHelper.dart';

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
  late List<Event> sampleEvents;
  late List<Friend> contacts;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    sampleEvents = getEventList();
    contacts = getFriendList();
  }

  Future<void> _refreshContacts() async {
    await Future.delayed(Duration(seconds: 2));
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     navigateToPage(context, 4);
                  //   },
                  //   icon: Icon(Icons.add),
                  //   label: Text('Add New Contact'),
                  //   style: ElevatedButton.styleFrom(
                  //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  //   ),
                  // ),
                  // SizedBox(width: 16),
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     navigateToPage(context, 4);
                  //   },
                  //   icon: Icon(Icons.add),
                  //   label: Text(
                  //     'Create Your Own Event/List',
                  //     textAlign: TextAlign.center,
                  //   ),
                  //   style: ElevatedButton.styleFrom(
                  //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  //   ),
                  // ),


                  Custom_button(title: "Create Your Own Event/List", onPress: (){})


                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _refreshContacts,
                  child: AnimationLimiter(
                    child: FriendList(friends: contacts, searchQuery: searchText),
                  ),
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
            navigateToPage(context, _index);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}