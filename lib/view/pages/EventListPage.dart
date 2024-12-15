import 'package:flutter/material.dart';
import 'package:hedieaty/domain/entities/event_entity.dart';

import '../../data/database/local/sqlite_event_dao.dart';
import '../../data/database/local/sqlite_user_dao.dart';
import '../../data/database/remote/firebase_auth.dart';
import '../../data/database/remote/firebase_event_dao.dart';
import '../../data/database/remote/firebase_user_dao.dart';
import '../../data/repos/event_repository_impl.dart';
import '../../data/repos/user_repository_impl.dart';
import '../../domain/usecases/event/add_event.dart';
import '../../domain/usecases/event/get_events.dart';
import '../../domain/usecases/event/sync_events.dart';
import '../../domain/usecases/user/get_users.dart';
import '../../domain/usecases/user/sync_users.dart';
import '../components/widgets/EventCard.dart';
import '../components/widgets/buttons/StatusButton.dart';
import '../components/widgets/nav/BottomNavBar.dart';
import '../components/widgets/nav/CustomAppBar.dart';



import 'package:hedieaty/utils/navigationHelper.dart';

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

  late AddEvent addEventUseCase;


  List<EventEntity> filterEvents(int index, List<EventEntity> events) {
    final now = DateTime.now();

    if (index == 0) {
      // Show all events with a valid EventDate
      return events.where((event) {
        final eventDate = DateTime.tryParse(event.EventDate);
        return eventDate != null && !eventDate.isAfter(now)  && !eventDate.isBefore(now);
      }).toList();
    } else if (index == 1) {
      // Show upcoming events (EventDate in the future)
      return events.where((event) {
        final eventDate = DateTime.tryParse(event.EventDate);
        return eventDate != null && eventDate.isAfter(now);
      }).toList();
    } else {
      // Show past events (EventDate in the past)
      return events.where((event) {
        final eventDate = DateTime.tryParse(event.EventDate);
        return eventDate != null && eventDate.isBefore(now);
      }).toList();
    }
  }

  void _onStatusChange(int index) {
    setState(() {
      _selectedStatus = index;

      filteredEvents = filterEvents(index, events); // Use a separate filteredEvents list
    });
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

      getUsersUseCase = GetUsers(userRepository);
      syncUsersUseCase = SyncUsers(userRepository);



      await syncUsersUseCase.call();
      // await syncEventsUseCase.call();


      final newEvents = await getEventsUseCase.call();
      final users = await getUsersUseCase.call();


      final userAuthId = await userRepository.getUserAuthId();


      for (EventEntity event in newEvents) {

        if (event.UserId == userAuthId) {
          event.UserName = 'Me';
        }else{
          final user = users.firstWhere((user) => user.UserId == event.UserId);
          event.UserName = user.UserName;
        }
      }

      setState(() {
        this.events = newEvents;
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
      // body: ListView.builder(
      //   itemCount: events.length,
      //   itemBuilder: (context, index) {
      //     final event = events[index];
      //     return Card(
      //       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      //       child: ExpansionTile(
      //         title: Text(event.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      //         subtitle: Text(
      //           '${event.date.toLocal().toString().split(' ')[0]} - ${event.location}',
      //           style: const TextStyle(fontSize: 14),
      //         ),
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.all(16.0),
      //             child: Text(event.description),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BookingStatusButton(
                label: 'Ongoing',
                onTap: _onStatusChange,
                index: 0,
                isActive: _selectedStatus == 0,
              ),
              BookingStatusButton(
                label: 'Upcoming',
                onTap: _onStatusChange,
                index: 1,
                isActive: _selectedStatus == 1,
              ),
              BookingStatusButton(
                label: 'Past',
                onTap: _onStatusChange,
                index: 2,
                isActive: _selectedStatus == 2,
              ),
            ],
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
                  // return Card(
                  //   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  //   child: ExpansionTile(
                  //     title: Text(event.EventName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  //     subtitle: Text(
                  //       '${event.EventDate.toString().split(' ')[0]} - ${event.EventLocation}',
                  //       style: const TextStyle(fontSize: 14),
                  //     ),
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.all(16.0),
                  //         child: Text(event.EventDescription),
                  //       ),
                  //     ],
                  //   ),
                  // );

                  return Eventcard(
                    event: event,
                    // onTap: () {
                    //   navigateToEventDetail(context, event);
                    // },
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
    );
  }

}