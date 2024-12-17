import 'package:flutter/material.dart';
import 'package:hedieaty/domain/entities/event_entity.dart';
import 'package:hedieaty/domain/usecases/event/delete_event.dart';
import 'package:hedieaty/utils/AppColors.dart';
import 'package:hedieaty/view/pages/Event/EventCreationPage.dart';

import '../../../data/database/local/sqlite_event_dao.dart';
import '../../../data/database/local/sqlite_user_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_event_dao.dart';
import '../../../data/database/remote/firebase_user_dao.dart';
import '../../../data/repos/event_repository_impl.dart';
import '../../../data/repos/user_repository_impl.dart';
import '../../../domain/usecases/event/add_event.dart';
import '../../../domain/usecases/event/get_events.dart';
import '../../../domain/usecases/event/sync_events.dart';
import '../../../domain/usecases/user/get_users.dart';
import '../../../domain/usecases/user/sync_users.dart';
import '../../components/widgets/EventCard.dart';
import '../../components/widgets/buttons/StatusButton.dart';
import '../../components/widgets/nav/BottomNavBar.dart';
import '../../components/widgets/nav/CustomAppBar.dart';

import 'package:hedieaty/utils/navigationHelper.dart';

import '../gift/EventListDetailsPage.dart';
import 'EventEditPage.dart';

class Eventlistpage extends StatefulWidget {
  const Eventlistpage({super.key});

  @override
  State<Eventlistpage> createState() => _EventlistpageState();
}

class _EventlistpageState extends State<Eventlistpage> {
  List<EventEntity> events = [];
  List<EventEntity> filteredEvents = [];
  late var _index = 0;
  var _selectedStatus = 0;

  late GetUsers getUsersUseCase;
  late SyncUsers syncUsersUseCase;

  late SyncEvents syncEventsUseCase;
  late GetEvents getEventsUseCase;
  late DeleteEvent deleteEventUseCase;

  late AddEvent addEventUseCase;

  void _onStatusChange(int index) {
    setState(() {
      _selectedStatus = index;
      filteredEvents = filterEvents(index, events);
    });
  }

  List<EventEntity> filterEvents(int index, List<EventEntity> events) {
    final now = DateTime.now();

    if (index == 0) {
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
      // Show upcoming events (EventDate in the future)
      return events.where((event) {
        final eventDate = DateTime.tryParse(event.EventDate);
        return eventDate != null && eventDate.isAfter(now);
      }).toList();
    } else if (index == 2) {
      // Show past events (EventDate strictly before today)
      return events.where((event) {
        final eventDate = DateTime.tryParse(event.EventDate);
        if (eventDate == null) return false;

        // Get today's date without the time part
        final today = DateTime(now.year, now.month, now.day);

        return eventDate
            .isBefore(today); // Check if the event date is before today
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
  }

  Future<void> _intializeData() async {
    try {
      final sqliteEventSource = SQLiteEventDataSource();
      final firebaseEventSource = FirebaseEventDataSource();

      final sqliteDataSource = SQLiteUserDataSource();
      final firebaseDataSource = FirebaseUserDataSource();
      final firebaseAuthDataSource = FirebaseAuthDataSource();

      final userRepository = UserRepositoryImpl(
        sqliteDataSource: sqliteDataSource,
        firebaseDataSource: firebaseDataSource,
        firebaseAuthDataSource: firebaseAuthDataSource,
      );

      final eventRepository = EventRepositoryImpl(
        sqliteDataSource: sqliteEventSource,
        firebaseDataSource: firebaseEventSource,
      );

      syncEventsUseCase = SyncEvents(eventRepository);
      getEventsUseCase = GetEvents(eventRepository);
      addEventUseCase = AddEvent(eventRepository);
      deleteEventUseCase = DeleteEvent(eventRepository);

      getUsersUseCase = GetUsers(userRepository);
      syncUsersUseCase = SyncUsers(userRepository);

      await syncUsersUseCase.call();
      await syncEventsUseCase.call();

      final newEvents = await getEventsUseCase.call();
      final users = await getUsersUseCase.call();

      final userAuthId = await userRepository.getUserAuthId();

      for (EventEntity event in newEvents) {
        if (event.UserId == userAuthId) {
          event.UserName = 'Me';
        } else {
          final user = users.firstWhere((user) => user.UserId == event.UserId);
          event.UserName = user.UserName;
        }
      }

      setState(() {
        this.events = newEvents;
        _onStatusChange(_selectedStatus);
      });
    } catch (e) {
      print(e);
    }
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
                      // _onSearchChanged(value);
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
                                    // _onSortOptionSelected('name_asc');
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: Text('Name (Descending)'),
                                  onTap: () {
                                    // _onSortOptionSelected('name_desc');
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: Text('Date (Ascending)'),
                                  onTap: () {
                                    // _onSortOptionSelected('date_asc');
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: Text('Date (Descending)'),
                                  onTap: () {
                                    // _onSortOptionSelected('date_desc');
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
              padding: const EdgeInsets.only(
                top: 20,
                left: 10,
                right: 10,
              ),
              child: ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];

                  return DateTime.tryParse(event.EventDate)
                              ?.isAfter(DateTime.now()) ==
                          true
                      ? Eventcard(
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
                            await deleteEventUseCase(event.EventId);
                            await _intializeData();
                          },
                          onTap: () async {
                            final isViewed = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetails(event: event),
                              ),
                            );
                          },
                        )
                      : Eventcard(
                          event: event,
                          onTap: () async {
                            final isViewed = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetails(event: event),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ),
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
            print('Event Updated lol');
            await _intializeData();
          }
        },
        child: Icon(
          Icons.edit_calendar,
        ),
        backgroundColor: AppColors.secondary,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
