import 'package:flutter/material.dart';
import 'package:hedieaty/domain/entities/event_entity.dart';

import 'package:hedieaty/domain/usecases/event/getEventsbyUserId.dart';
import 'package:hedieaty/view/components/widgets/nav/CustomAppBar.dart';

import '../../data/database/local/sqlite_event_dao.dart';
import '../../data/database/local/sqlite_gift_dao.dart';
import '../../data/database/local/sqlite_user_dao.dart';
import '../../data/database/remote/firebase_auth.dart';
import '../../data/database/remote/firebase_event_dao.dart';
import '../../data/database/remote/firebase_gift_dao.dart';
import '../../data/database/remote/firebase_user_dao.dart';
import '../../data/repos/event_repository_impl.dart';
import '../../data/repos/gift_repository_impl.dart';
import '../../data/repos/user_repository_impl.dart';
import '../../domain/entities/friend_entity.dart';
import '../../domain/entities/gift_entity.dart';
import '../../domain/usecases/event/add_event.dart';

import '../../domain/usecases/event/sync_events.dart';
import '../../domain/usecases/gifts/get_gifts_event.dart';
import '../../domain/usecases/gifts/sync_gifts.dart';
import '../../domain/usecases/user/get_users.dart';
import '../../domain/usecases/user/sync_users.dart';
import '../../utils/AppColors.dart';
import '../components/widgets/buttons/StatusButton.dart';
import 'gift/EventListDetailsPage.dart';

class FriendPage extends StatefulWidget {
  final FriendEntity friend;

  const FriendPage({Key? key, required this.friend}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  bool isLoading = true;

  late GetUsers getUsersUseCase;
  late SyncUsers syncUsersUseCase;
  late SyncEvents syncEventsUseCase;

  late AddEvent addEventUseCase;
  late GetEventsbyUserId getEventsbyUserId;


  List<EventEntity> events = [];
  List<EventEntity> filteredEvents = [];
  var _selectedStatus = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final sqliteDataSource = SQLiteUserDataSource();
      final firebaseDataSource = FirebaseUserDataSource();
      final firebaseAuthDataSource = FirebaseAuthDataSource();
      final sqliteEventSource = SQLiteEventDataSource();
      final firebaseEventSource = FirebaseEventDataSource();

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

      addEventUseCase = AddEvent(eventRepository);
      getEventsbyUserId = GetEventsbyUserId(eventRepository);

      getUsersUseCase = GetUsers(userRepository);
      syncUsersUseCase = SyncUsers(userRepository);

      await _refreshEvents();
    } catch (e) {
      debugPrint('Error during initialization: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshEvents() async {
    try {
      await syncUsersUseCase.call();
      await syncEventsUseCase.call();

      final newEvents = await getEventsbyUserId.call(widget.friend.FriendId);

      setState(() {
        events = newEvents;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error refreshing events: $e');
    }
  }

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
    } else {
      // Show past events (EventDate strictly before today)
      return events.where((event) {
        final eventDate = DateTime.tryParse(event.EventDate);
        if (eventDate == null) return false;

        // Get today's date without the time part
        final today = DateTime(now.year, now.month, now.day);

        return eventDate
            .isBefore(today); // Check if the event date is before today
      }).toList();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '${widget.friend.UserName}\'s Profile',
        showBackButton: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Hero(
                          tag: widget.friend.UserPhone ?? 'Unknown Phone',
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                              'assets/images/default_profile.png',
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.friend.UserName ?? 'Unknown Name',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.friend.UserEmail ?? 'Unknown Email',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Events Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Events',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

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
                    ],
                  ),

                  filteredEvents.isEmpty
                      ? Center(
                          child: Padding(
                            padding:  EdgeInsets.all(MediaQuery.of(context).size.height * 0.1),
                            child: Text(
                              'No events to show.',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: ListTile(
                                leading:
                                    Icon(Icons.event, color: AppColors.primary),
                                title: Text(
                                  event.EventName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  '${event.EventDate} at ${event.EventLocation}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.grey),
                                onTap: () async {
                                  // Event detail navigation logic
                                  final isViewed = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EventDetails(event: event ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
