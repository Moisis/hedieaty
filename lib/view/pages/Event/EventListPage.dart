import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hedieaty/domain/entities/event_entity.dart';
import 'package:hedieaty/domain/usecases/event/delete_event.dart';
import 'package:hedieaty/utils/AppColors.dart';
import 'package:hedieaty/view/pages/Event/EventCreatePage.dart';

import '../../../data/database/local/sqlite_event_dao.dart';
import '../../../data/database/local/sqlite_friend_dao.dart';
import '../../../data/database/local/sqlite_gift_dao.dart';
import '../../../data/database/local/sqlite_user_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_event_dao.dart';
import '../../../data/database/remote/firebase_friend_dao.dart';
import '../../../data/database/remote/firebase_gift_dao.dart';
import '../../../data/database/remote/firebase_user_dao.dart';
import '../../../data/repos/event_repository_impl.dart';
import '../../../data/repos/friend_repository_impl.dart';
import '../../../data/repos/gift_repository_impl.dart';
import '../../../data/repos/user_repository_impl.dart';

import '../../../domain/usecases/event/add_event.dart';
import '../../../domain/usecases/event/get_events.dart';
import '../../../domain/usecases/event/sync_events.dart';
import '../../../domain/usecases/friend/getFriends.dart';
import '../../../domain/usecases/friend/sync_Friends.dart';
import '../../../domain/usecases/gifts/deleteGiftsEvent.dart';

import '../../../domain/usecases/user/getUserAuthId.dart';
import '../../../domain/usecases/user/get_users.dart';
import '../../../domain/usecases/user/sync_users.dart';
import '../../components/widgets/EventCard.dart';
import '../../components/widgets/buttons/StatusButton.dart';
import '../../components/widgets/nav/BottomNavBar.dart';
import '../../components/widgets/nav/CustomAppBar.dart';

import 'package:hedieaty/utils/navigationHelper.dart';

import '../gift/EventListDetailsPage.dart';
import 'EventEditPage.dart';
import '../../../domain/usecases/event/GetStreamEvent.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<EventEntity> filteredEvents = [];
  late var _index = 0;
  var _selectedStatus = 0;

  late GetUsers getUsersUseCase;
  late SyncUsers syncUsersUseCase;
  late GetUserAuthId getUserAuthId;

  late SyncEvents syncEventsUseCase;
  late GetEvents getEventsUseCase;
  late DeleteEvent deleteEventUseCase;

  late AddEvent addEventUseCase;

  late DeleteGiftsEvent deleteGiftsEventUseCase;

  late GetStreamEvent getStreamEvent;
  late Stream<List<EventEntity>> eventsStream;
  late StreamSubscription<List<EventEntity>>? _eventSubscription;
  List<EventEntity> events = [];

  late GetFriends getFriendsUseCase;
  late SyncFriends syncFriendsUseCase;

  void _onStatusChange(int index) {
    setState(() {
      _selectedStatus = index;
      filteredEvents = filterEvents(index, events);
    });
  }

  List<EventEntity> filterEvents(int index, List<EventEntity> events) {
    final now = DateTime.now();
    if (index == 0) {
      // Show ongoing events
      return events.where((event) {
        final eventDate = DateTime.tryParse(event.EventDate);
        if (eventDate == null) return false;

        // Get the current date without time (midnight) and compare
        final today = DateTime(now.year, now.month, now.day);
        final eventDay =
            DateTime(eventDate.year, eventDate.month, eventDate.day);

        return eventDay == today;
      }).toList();
    } else if (index == 1) {
      // Show upcoming events
      return events.where((event) {
        final eventDate = DateTime.tryParse(event.EventDate);
        return eventDate != null && eventDate.isAfter(now);
      }).toList();
    } else if (index == 2) {
      // Show past events
      return events.where((event) {
        final eventDate = DateTime.tryParse(event.EventDate);
        if (eventDate == null) return false;

        // Get today's date without the time part
        final today = DateTime(now.year, now.month, now.day);

        return eventDate.isBefore(today);
      }).toList();
    } else {
      return events.where((event) {
        return event.UserName == 'Me';
      }).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _intializeData();
    _subscribetoEvents();
  }

  Future<void> _intializeData() async {
    try {
      final userRepository = UserRepositoryImpl(
        sqliteDataSource: SQLiteUserDataSource(),
        firebaseDataSource: FirebaseUserDataSource(),
        firebaseAuthDataSource: FirebaseAuthDataSource(),
      );

      final eventRepository = EventRepositoryImpl(
        sqliteDataSource: SQLiteEventDataSource(),
        firebaseDataSource: FirebaseEventDataSource(),
      );

      final giftRepository = GiftRepositoryImpl(
        sqliteDataSource: SQLiteGiftDataSource(),
        firebaseDataSource: FirebaseGiftDataSource(),
      );

      final friendRepository = FriendRepositoryImpl(
        sqliteDataSource: SQLiteFriendDataSource(),
        firebaseDataSource: FirebaseFriendDataSource(),
      );

      syncEventsUseCase = SyncEvents(eventRepository);
      getEventsUseCase = GetEvents(eventRepository);
      addEventUseCase = AddEvent(eventRepository);
      deleteEventUseCase = DeleteEvent(eventRepository);
      getStreamEvent = GetStreamEvent(eventRepository);

      deleteEventUseCase = DeleteEvent(eventRepository);

      deleteGiftsEventUseCase = DeleteGiftsEvent(giftRepository);

      getFriendsUseCase = GetFriends(friendRepository);
      syncFriendsUseCase = SyncFriends(friendRepository);

      getUsersUseCase = GetUsers(userRepository);
      syncUsersUseCase = SyncUsers(userRepository);
      getUserAuthId = GetUserAuthId(userRepository);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _subscribetoEvents() async {
    await syncUsersUseCase.call();
    await syncEventsUseCase.call();

    final users = await getUsersUseCase.call();

    final userAuthId = await getUserAuthId.call();
    eventsStream = getStreamEvent.call();

    _eventSubscription = eventsStream.listen((updatedEvents) {
      print('Gifts updated: $updatedEvents');
      setState(() {
        for (EventEntity event in updatedEvents) {
          if (event.UserId == userAuthId) {
            event.UserName = 'Me';
          } else {
            final user =
                users.firstWhere((user) => user.UserId == event.UserId);
            event.UserName = user.UserName;
          }
        }
        events = updatedEvents;
        _onStatusChange(_selectedStatus);
      });
    });
  }

  @override
  void dispose() {
    _eventSubscription?.cancel(); // Clean up the subscription
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredEvents = events
          .where((event) =>
              event.EventName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onSortOptionSelected(String option) {
    setState(() {
      switch (option) {
        case 'name_asc':
          filteredEvents.sort((a, b) => a.EventName.compareTo(b.EventName));
          break;
        case 'name_desc':
          filteredEvents.sort((a, b) => b.EventName.compareTo(a.EventName));
          break;
        case 'date_asc':
          filteredEvents.sort((a, b) {
            final dateA = DateTime.tryParse(a.EventDate);
            final dateB = DateTime.tryParse(b.EventDate);
            if (dateA == null || dateB == null) return 0;
            return dateA.compareTo(dateB);
          });
          break;
        case 'date_desc':
          filteredEvents.sort((a, b) {
            final dateA = DateTime.tryParse(a.EventDate);
            final dateB = DateTime.tryParse(b.EventDate);
            if (dateA == null || dateB == null) return 0;
            return dateB.compareTo(dateA);
          });
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Event List',
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatusButton(
                label: 'Ongoing',
                onTap: _onStatusChange,
                index: 0,
                isActive: _selectedStatus == 0,
              ),
              StatusButton(
                label: 'Upcoming',
                onTap: _onStatusChange,
                index: 1,
                isActive: _selectedStatus == 1,
              ),
              StatusButton(
                label: 'Past',
                onTap: _onStatusChange,
                index: 2,
                isActive: _selectedStatus == 2,
              ),
              StatusButton(
                label: 'Mine',
                onTap: _onStatusChange,
                index: 3,
                isActive: _selectedStatus == 3,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Row for Search Bar and Sort Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Search Bar
                Flexible(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Events',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {
                      // Call a method to filter bookings based on search query
                      _onSearchChanged(value);
                    },
                  ),
                ),

                SizedBox(width: 10),

                // Sort Button
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.sort),
                    onPressed: () {
                      // Open a dialog or menu to select sort options
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Sort By',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ListTile(
                                  title: Text('Name (Ascending)'),
                                  onTap: () {
                                    _onSortOptionSelected('name_asc');
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: Text('Name (Descending)'),
                                  onTap: () {
                                    _onSortOptionSelected('name_desc');
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: Text('Date (Ascending)'),
                                  onTap: () {
                                    _onSortOptionSelected('date_asc');
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: Text('Date (Descending)'),
                                  onTap: () {
                                    _onSortOptionSelected('date_desc');
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: filteredEvents.isEmpty
                  ? Center(
                      child: Text(
                        'No Events',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return Eventcard(
                          event: event,
                          onEdit: () async {
                            final isUpdated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditEventPage(event: event),
                              ),
                            );
                            if (isUpdated == true) {
                              print('Event Updated');
                              await _intializeData();
                              _onStatusChange(_selectedStatus);
                            }
                          },
                          onDelete: () async {
                            Future.wait(
                              [
                                deleteEventUseCase(event.EventId),
                                deleteGiftsEventUseCase(event.EventId),
                              ],
                            );
                            await _intializeData();
                          },
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetails(event: event),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          )
        ],
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
        onPressed: () async {
          final isCreated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventCreationPage(),
            ),
          );
          if (isCreated == true) {
            print('Event Updated ');
            await _intializeData();
          }
        },
        child: Icon(
          Icons.edit_calendar,
          color: Colors.white,
        ),
        backgroundColor: AppColors.secondary,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
