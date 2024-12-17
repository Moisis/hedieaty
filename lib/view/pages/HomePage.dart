import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hedieaty/data/database/local/sqlite_event_dao.dart';
import 'package:hedieaty/data/database/remote/firebase_event_dao.dart';
import 'package:hedieaty/domain/entities/event_entity.dart';
import 'package:hedieaty/domain/entities/friend_entity.dart';
import 'package:hedieaty/domain/repos_head/event_repository.dart';
import 'package:hedieaty/domain/usecases/event/add_event.dart';
import 'package:hedieaty/domain/usecases/event/sync_events.dart';
import 'package:hedieaty/domain/usecases/friend/getFriends.dart';
import 'package:hedieaty/domain/usecases/friend/sync_Friends.dart';
import 'package:hedieaty/domain/usecases/user/getUserAuthId.dart';
import 'package:hedieaty/domain/usecases/user/getUserbyId.dart';
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
import '../../domain/usecases/user/getUserbyPhone.dart';
import '../../domain/usecases/user/get_users.dart';
import '../../domain/usecases/user/sync_users.dart';

import '../../domain/entities/user_entity.dart';

import '../components/widgets/buttons/Circular_small_Button.dart';
import '../components/widgets/buttons/IconButton.dart';
import '../components/widgets/nav/BottomNavBar.dart';
import '../components/widgets/FriendList.dart';
import '../components/widgets/nav/CustomAppBar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

  String connectionStatus = 'unknown';
  String UserAuthId = '';

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controllerPhone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late GetUsers getUsersUseCase;
  late SyncUsers syncUsersUseCase;
  late GetUserByPhone getUserByPhoneUseCase;


  late SyncEvents syncEventsUseCase;
  late GetEvents getEventsUseCase;
  late AddEvent addEventUseCase;
  late GetUserAuthId  getUserAuthIdUseCase;

  late GetFriends getFriendsUseCase;
  late AddFriend addFriendUseCase;
  late SyncFriends syncFriendsUseCase;

  @override
  void initState() {
    super.initState();
    print('init state');
    isLoading = true;
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      setState(() {
        isLoading = true;
      });
      final sqliteDataSource = SQLiteUserDataSource();
      final firebaseDataSource = FirebaseUserDataSource();
      final firebaseAuthDataSource = FirebaseAuthDataSource();

      final sqliteEventSource = SQLiteEventDataSource();
      final firebaseEventSource = FirebaseEventDataSource();

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
      getUserByPhoneUseCase = GetUserByPhone(userRepository);
      getUserAuthIdUseCase = GetUserAuthId(userRepository);


      getFriendsUseCase = GetFriends(friendRepository);
      addFriendUseCase = AddFriend(friendRepository);
      syncFriendsUseCase = SyncFriends(friendRepository);

      print('Syncing contacts');
      print(FirebaseAuth.instance.currentUser!.uid);

      await _refreshContacts();
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number cannot be empty";
    }
    if (value.length != 10 || !RegExp(r'^\d{10}$').hasMatch(value)) {
      return "Phone number must be exactly 10 digits";
    }
    return null;
  }

  void _addFriend(String phone) async {
    // Ensure form is validated first
    if (!_formKey.currentState!.validate()) {
      return; // Stop execution if validation fails
    }

    try {

      final foundFriend = await getUserByPhoneUseCase.call(phone);

      FriendEntity tempFriend = FriendEntity(
        UserId: UserAuthId,
        FriendId: foundFriend.UserId,
      );

      await addFriendUseCase.call(tempFriend);


      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Friend added successfully!",
        gravity: ToastGravity.SNACKBAR,
      );

      await _refreshContacts();
      setState(() {
        _controllerPhone.clear();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error adding friend $e",
        gravity: ToastGravity.SNACKBAR,
      );
    }
  }

  void _addFriendWindow() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // This allows the modal to resize for the keyboard
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _controllerPhone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                      prefixText: "+20 ",
                    ),
                    validator: _validatePhone,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IC_button(
                      title: 'Add Friend',
                      onPress: () {
                        _addFriend(_controllerPhone.text);
                      },
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      color: AppColors.primary,
                      fontsize: 14,
                      width: 150,
                      height: 50,
                    ),
                    const Spacer(),
                    IC_button(
                      title: 'Cancel',
                      onPress: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                      color: Colors.redAccent,
                      fontsize: 14,
                      width: 150,
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _checkConnectionStatus() async {
    try {
      final ConnectivityResult result =
          (await Connectivity().checkConnectivity()) as ConnectivityResult;
      if (!mounted) return;
      setState(() {
        connectionStatus =
            result == ConnectivityResult.none ? 'none' : 'connected';
      });
    } catch (e) {
      // Log the error or handle it as needed
      if (!mounted) return;
      setState(() {
        connectionStatus = 'error';
      });
    }
  }

  Future<void> _refreshContacts() async {
    print('Refresh:');
    try {

      UserAuthId = await getUserAuthIdUseCase.call();
      print('UserAuthId: $UserAuthId');
      await syncUsersUseCase.call();
      await syncEventsUseCase.call();
      await syncFriendsUseCase.call();

      // Fetch updated data
      final newContacts = await getUsersUseCase.call();
      final newEvents = await getEventsUseCase.call();
      final newFriends = await getFriendsUseCase.call(UserAuthId);



      // Update user event counts
      for (var user in newContacts) {
        user.UserEventsNo =
            newEvents.where((event) => event.UserId == user.UserId).length;
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
        isLoading=false;
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

                        IC_button(
                          title: 'Create Your Own Event',
                          onPress: () {
                            Navigator.pushNamed(context, '/EventCreatePage');
                          },
                          icon: const Icon(
                            Icons.edit_calendar,
                            color: Colors.white,
                          ),
                          color: AppColors.primary,
                          fontsize: 16,
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addFriendWindow();
        },
        child: const Icon(
          Icons.person_add,
          color: Colors.white,
        ),
        backgroundColor: AppColors.primary,
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
