import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/data/database/local/sqlite_event_dao.dart';
import 'package:hedieaty/data/database/remote/firebase_event_dao.dart';
import 'package:hedieaty/domain/entities/event_entity.dart';
import 'package:hedieaty/domain/entities/friend_entity.dart';
import 'package:hedieaty/domain/repos_head/event_repository.dart';
import 'package:hedieaty/domain/usecases/event/add_event.dart';
import 'package:hedieaty/domain/usecases/event/sync_events.dart';
import 'package:hedieaty/domain/usecases/friend/getFriends.dart';
import 'package:hedieaty/utils/AppColors.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hedieaty/view/components/widgets/buttons/CustomButton.dart';

import '../../data/database/local/sqlite_friend_dao.dart';
import '../../data/database/local/sqlite_user_dao.dart';
import '../../data/database/remote/firebase_auth.dart';
import '../../data/database/remote/firebase_friend_dao.dart';
import '../../data/database/remote/firebase_user_dao.dart';
import '../../data/repos/event_repository_impl.dart';
import '../../data/repos/friend_repository_impl.dart';
import '../../data/repos/user_repository_impl.dart';
import '../../domain/repos_head/user_repository.dart';
import '../../domain/usecases/event/get_events.dart';
import '../../domain/usecases/friend/addFriend.dart';
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
  List<FriendEntity> contacts = [];
  // List<FriendEntity> Friends = [];

  final ScrollController _scrollController = ScrollController();

  late GetUsers getUsersUseCase;
  late SyncUsers syncUsersUseCase;

  late SyncEvents syncEventsUseCase;
  late GetEvents getEventsUseCase;

  late AddEvent addEventUseCase;

  late GetFriends getFriendsUseCase;
  late AddFriend addFriendUseCase;



  @override
  void initState() {
    super.initState();
    print ('init state');

    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final sqliteDataSource = SQLiteUserDataSource();
      final firebaseDataSource = FirebaseUserDataSource();

      final sqliteEventSource = SQLiteEventDataSource();
      final firebaseEventSource = FirebaseEventDataSource();

      final firebaseAuthDataSource = FirebaseAuthDataSource();

      final sqliteFriendSource = SQLiteFriendDataSource();
      final firebaseFriendSource = FirebaseFriendDataSource();

      final userRepository = UserRepositoryImpl(
        sqliteDataSource: sqliteDataSource,
        firebaseDataSource: firebaseDataSource,
        firebaseAuthDataSource: firebaseAuthDataSource,
      );

      final eventRepository = EventRepositoryImpl(
        sqliteDataSource: sqliteEventSource,
        firebaseDataSource: firebaseEventSource,
      );

      final friendRepository = FriendRepositoryImpl(
        sqliteDataSource: sqliteFriendSource,
        firebaseDataSource: firebaseFriendSource,
      );

      syncEventsUseCase = SyncEvents(eventRepository);
      getEventsUseCase = GetEvents(eventRepository);
      addEventUseCase = AddEvent(eventRepository);

      getUsersUseCase = GetUsers(userRepository);
      syncUsersUseCase = SyncUsers(userRepository);

      getFriendsUseCase = GetFriends(friendRepository);

      addFriendUseCase = AddFriend(friendRepository);



      await _refreshContacts();
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  Future<void> _refreshContacts() async {
    print('Refresh:');
    try {
      setState(() {
        isLoading = true;
      });

      // Synchronize users and events
      await syncUsersUseCase.call();
      await syncEventsUseCase.call();


      // Fetch updated data
      final newContacts = await getUsersUseCase.call();
      final newEvents = await getEventsUseCase.call();

      // // Update user event counts
      for (var user in newContacts) {
        user.UserEventsNo = newEvents.where((event) => event.UserId == user.UserId).length;
      }
      //  Todo - Auth
      FirebaseAuth auth = FirebaseAuth.instance;
      final user = auth.currentUser;
      final newFriends = await getFriendsUseCase.call(user!.uid);

      for (FriendEntity friend in newFriends) {
        final user = newContacts.firstWhere((user) => user.UserId == friend.FriendId);
        friend.UserName = user.UserName;
        friend.UserEmail = user.UserEmail;
        friend.UserPhone = user.UserPhone;
        friend.UserPass = user.UserPass;
        friend.UserPrefs = user.UserPrefs;
        friend.UserEventsNo = user.UserEventsNo;
      }



      setState(() {
        contacts = newFriends;
        isLoading = false;
      });
    } catch (e) {
      // debugPrint('Error refreshing contacts: $e');
      setState(() {
        isLoading = false;
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
                        InkWell(
                          onTap: () {
                            navigateToPage(context, 2);
                          },
                          child: Icon(
                             Icons.add,
                            color: AppColors.primary,
                          ),
                        ),
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
