import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../data/database/local/sqlite_event_dao.dart';
import '../../../data/database/local/sqlite_friend_dao.dart';
import '../../../data/database/local/sqlite_user_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_event_dao.dart';
import '../../../data/database/remote/firebase_friend_dao.dart';
import '../../../data/database/remote/firebase_user_dao.dart';
import '../../../data/repos/event_repository_impl.dart';
import '../../../data/repos/friend_repository_impl.dart';
import '../../../data/repos/user_repository_impl.dart';
import '../../../domain/entities/friend_entity.dart';
import '../../../domain/usecases/event/get_events.dart';
import '../../../domain/usecases/event/sync_events.dart';
import '../../../domain/usecases/friend/getFriends.dart';
import '../../../domain/usecases/friend/sync_Friends.dart';
import '../../../domain/usecases/user/getUserAuthId.dart';
import '../../../domain/usecases/user/get_users.dart';
import '../../../domain/usecases/user/sync_users.dart';
import '../../../utils/AppColors.dart';
import '../../components/widgets/FriendList.dart';
import '../../components/widgets/nav/CustomAppBar.dart';

class ProfileManageFriends extends StatefulWidget {
  const ProfileManageFriends({super.key});

  @override
  State<ProfileManageFriends> createState() => _ProfileManageFriendsState();
}

class _ProfileManageFriendsState extends State<ProfileManageFriends> {
  String UserAuthId = '';

  bool isLoading = true;
  List<FriendEntity> contacts = [];
  final ScrollController _scrollController = ScrollController();
  final Duration _animationDuration = const Duration(milliseconds: 375);

  bool isSearchClicked = false;
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();

  late GetUsers getUsersUseCase;
  late SyncUsers syncUsersUseCase;

  late SyncEvents syncEventsUseCase;
  late GetEvents getEventsUseCase;
  // late AddEvent addEventUseCase;
  late GetUserAuthId getUserAuthIdUseCase;

  late GetFriends getFriendsUseCase;
  // late AddFriend addFriendUseCase;
  late SyncFriends syncFriendsUseCase;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      setState(() {
        isLoading = true;
      });

      final userRepository = UserRepositoryImpl(
        sqliteDataSource: SQLiteUserDataSource(),
        firebaseDataSource: FirebaseUserDataSource(),
        firebaseAuthDataSource: FirebaseAuthDataSource(),
      );

      final eventRepository = EventRepositoryImpl(
        sqliteDataSource: SQLiteEventDataSource(),
        firebaseDataSource: FirebaseEventDataSource(),
      );

      final friendRepository = FriendRepositoryImpl(
        sqliteDataSource: SQLiteFriendDataSource(),
        firebaseDataSource: FirebaseFriendDataSource(),
      );

      syncEventsUseCase = SyncEvents(eventRepository);
      getEventsUseCase = GetEvents(eventRepository);

      getUsersUseCase = GetUsers(userRepository);
      syncUsersUseCase = SyncUsers(userRepository);
      getUserAuthIdUseCase = GetUserAuthId(userRepository);

      getFriendsUseCase = GetFriends(friendRepository);
      syncFriendsUseCase = SyncFriends(friendRepository);

      await _refreshContacts();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  Future<void> _refreshContacts() async {
    print('Refresh:');
    try {
      UserAuthId = await getUserAuthIdUseCase.call();
      await syncUsersUseCase.call();
      await syncEventsUseCase.call();
      await syncFriendsUseCase.call();

      // Fetch updated data
      final newContacts = await getUsersUseCase.call();
      final newEvents = await getEventsUseCase.call();
      final newFriends = await getFriendsUseCase.call(UserAuthId);

      // Update user event counts
      for (var user in newContacts) {
        user.UserEventsNo = newEvents
            .where((event) =>
                event.UserId == user.UserId &&
                (DateTime.tryParse(event.EventDate)!.isBefore(DateTime.now())))
            .length;
      }

      for (FriendEntity friend in newFriends) {
        final user =
            newContacts.firstWhere((user) => user.UserId == friend.FriendId);
        friend.UserName = user.UserName;
        friend.UserEmail = user.UserEmail;
        friend.UserPhone = user.UserPhone;
        friend.UserPass = user.UserPass;
        friend.UserPrefs = user.UserPrefs;
        friend.UserEventsNo = user.UserEventsNo;
      }

      setState(() {
        contacts = newFriends;
        // isLoading=false;
      });
    } catch (e) {
      debugPrint('Error refreshing contacts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Friends',
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
        showBackButton: true,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : contacts.isEmpty
                ? Center(
                    child: Text(
                      'No Friends',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
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
    );
  }
}
