
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hedieaty/data/database/local/sqlite_event_dao.dart';
import 'package:hedieaty/data/database/remote/firebase_event_dao.dart';

import 'package:hedieaty/domain/entities/friend_entity.dart';

import 'package:hedieaty/domain/usecases/event/add_event.dart';
import 'package:hedieaty/domain/usecases/event/sync_events.dart';
import 'package:hedieaty/domain/usecases/friend/getFriends.dart';
import 'package:hedieaty/domain/usecases/friend/sync_Friends.dart';
import 'package:hedieaty/domain/usecases/user/getUserAuthId.dart';

import 'package:hedieaty/utils/AppColors.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../data/database/local/sqlite_friend_dao.dart';
import '../../data/database/local/sqlite_user_dao.dart';
import '../../data/database/remote/firebase_auth.dart';
import '../../data/database/remote/firebase_friend_dao.dart';
import '../../data/database/remote/firebase_user_dao.dart';
import '../../data/repos/event_repository_impl.dart';
import '../../data/repos/friend_repository_impl.dart';
import '../../data/repos/user_repository_impl.dart';

import '../../domain/usecases/event/get_events.dart';
import '../../domain/usecases/friend/addFriend.dart';
import '../../domain/usecases/user/getUserbyPhone.dart';
import '../../domain/usecases/user/get_users.dart';
import '../../domain/usecases/user/sync_users.dart';



import '../../utils/notification/FCM_Firebase.dart';
import '../../utils/notification/notification_helper.dart';
import '../components/widgets/buttons/IconButton.dart';
import '../components/widgets/nav/BottomNavBar.dart';
import '../components/widgets/FriendList.dart';
import '../components/widgets/nav/CustomAppBar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:hedieaty/utils/navigationHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearchClicked = false;
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  final Duration _animationDuration = const Duration(milliseconds: 300);
  late int _index = 1;
  bool isLoading = true;
  List<FriendEntity> contacts = [];
  final ScrollController _scrollController = ScrollController();



  String connectionStatus = 'unknown';
  String UserAuthId = '';


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

  final FirestoreService _firestoreService = FirestoreService();
  String? fcm_token = '';
  NotificationService _notificationService = NotificationService();


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
      addEventUseCase = AddEvent(eventRepository);

      getUsersUseCase = GetUsers(userRepository);
      syncUsersUseCase = SyncUsers(userRepository);
      getUserByPhoneUseCase = GetUserByPhone(userRepository);
      getUserAuthIdUseCase = GetUserAuthId(userRepository);


      getFriendsUseCase = GetFriends(friendRepository);
      addFriendUseCase = AddFriend(friendRepository);
      syncFriendsUseCase = SyncFriends(friendRepository);



      await _refreshContacts();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error during initialization: $e');
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

      var userMap = await _firestoreService.getFcm2(foundFriend.UserId);
      _notificationService.sendNotification(
          userMap!,
          'Friend Added',
          '${foundFriend.UserName} is waiting for you!'
      );
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
        user.UserEventsNo = newEvents.where((event) => event.UserId == user.UserId ).length;
      }

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
        key: ValueKey('CustomBottomBar'),
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
        backgroundColor: AppColors.secondary,
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
