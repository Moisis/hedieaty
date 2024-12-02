import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:hedieaty/utils/AppColors.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hedieaty/view/components/widgets/buttons/CustomButton.dart';

import '../../data/database/local/sqlite_user_dao.dart';
import '../../data/database/remote/firebase_user_dao.dart';
import '../../data/repos/user_repository_impl.dart';
import '../../domain/repos_head/user_repository.dart';
import '../../domain/usecases/user/get_users.dart';
import '../../domain/usecases/user/sync_users.dart';

import '../../domain/entities/user_entity.dart';


import '../components/widgets/buttons/Circular_small_Button.dart';
import '../components/widgets/nav/BottomNavBar.dart';
import '../components/widgets/FriendList.dart';
import '../components/widgets/nav/CustomAppBar.dart';

// import 'package:hedieaty/modules/demoStorage.dart';
// import 'package:hedieaty/modules/Event.dart';
// import 'package:hedieaty/modules/Friend.dart';


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
  late var _index = 1;
  // late List<Event> sampleEvents;
  // late List<Us> contacts;

  late List<UserEntity> contacts = [];

  final ScrollController _scrollController = ScrollController();

  late GetUsers getUsersUseCase;
  late SyncUsers syncUsersUseCase;


  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final sqliteDataSource = SQLiteUserDataSource();
    final firebaseDataSource = FirebaseUserDataSource();
    final repository = UserRepositoryImpl(
      sqliteDataSource: sqliteDataSource,
      firebaseDataSource: firebaseDataSource,
    );

    getUsersUseCase = GetUsers(repository as UserRepository);
    syncUsersUseCase = SyncUsers(repository as UserRepository);

    await sqliteDataSource.init();

    await _refreshContacts();

  }

  Future<void> _refreshContacts() async {
    syncUsersUseCase.call();
    contacts = await getUsersUseCase.call()  ;

    setState(() {

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


                  // Custom_button(title: "Create Your Own Event/List", onPress: (){})


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