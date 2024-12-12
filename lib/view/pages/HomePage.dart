import 'package:flutter/material.dart';
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
  late int _index = 1;
  bool isLoading = true;
  List<UserEntity> contacts = [];

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

    getUsersUseCase = GetUsers(repository);
    syncUsersUseCase = SyncUsers(repository);

    await _refreshContacts();
  }

  Future<void> _refreshContacts() async {
    try {
      setState(() {
        isLoading = true;
      });

      await syncUsersUseCase.call(); // Ensure sync completes
      final newContacts = await getUsersUseCase.call(); // Fetch updated users

      setState(() {
        contacts = newContacts;
        isLoading = false;
      });
    } catch (e) {
      print('Error refreshing contacts: $e');
      setState(() {
        isLoading = false; // Avoid infinite loader
      });
    }
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Add buttons if necessary
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: AnimationLimiter(
                        child: FriendList(
                          friends: contacts,
                          searchQuery: searchText,
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
    _searchController.dispose();
    super.dispose();
  }
}
