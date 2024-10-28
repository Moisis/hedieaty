import 'package:flutter/material.dart';

import '../components/widgets/BottomNavBar.dart';
import '../components/widgets/CustomAppBar.dart';
import '../modules/Event.dart';
import '../modules/demoStorage.dart';
import '../utils/navigationHelper.dart';

class Eventlistpage extends StatefulWidget {
  const Eventlistpage({super.key});

  @override
  State<Eventlistpage> createState() => _EventlistpageState();
}

class _EventlistpageState extends State<Eventlistpage> {

  late List<Event> events;
  late var _index = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    events = getEventList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        isSearchClicked: false,
        searchController: TextEditingController(),
        animationDuration: Duration(milliseconds: 300),
        onSearchChanged: (value) {

        },
        onSearchIconPressed: () {
          setState(() {

          });
        },
        onSettingsIconPressed: () {
          // Handle settings button press
        },
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ExpansionTile(
              title: Text(event.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(
                '${event.date.toLocal().toString().split(' ')[0]} - ${event.location}',
                style: const TextStyle(fontSize: 14),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(event.description),
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar:Bottomnavbar(
        currentIndex: _index,
        onIndexChanged: (index) {
          setState(() {
            _index = index;
            navigateToPage(context , _index);
          });
        },
      ) ,
    );
  }
}
