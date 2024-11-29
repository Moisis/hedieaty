import 'package:flutter/material.dart';
import 'package:hedieaty/view/components/widgets/nav/CustomAppBar.dart';

import '../components/widgets/nav/BottomNavBar.dart';


import 'package:hedieaty/modules/Friend.dart';
import 'package:hedieaty/modules/demoStorage.dart';

import 'package:hedieaty/utils/navigationHelper.dart';

class ProfilePage extends StatefulWidget {



  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late var _index = 4;

  final Friend friend = getFriendList().first;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(

      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(friend.profileImageUrl),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold , color:  Color(0x80000000),),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'No bio available',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          // Gift List Section
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Adjust the padding value as needed
              child: Text(
                'Events',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0x80000000),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: friend.events.length,
              itemBuilder: (context, eventIndex) {
                final event = friend.events[eventIndex];
                final eventGifts = friend.giftList
                    .where((gift) => gift.event == event)
                    .toList();

                return ExpansionTile(
                  title: Text(event.name),
                  subtitle: Text(
                    '${event.date.toLocal()} - ${event.location}',
                    style: TextStyle(fontSize: 12),
                  ),
                  children: eventGifts.map((gift) {
                    return ListTile(
                      leading: Icon(Icons.card_giftcard),
                      title: Text(gift.name),
                      subtitle: Text(gift.description),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Handle gift pledge functionality
                        },
                        child: Text('Pledge'),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavbar(
        currentIndex: _index,
        onIndexChanged: (index) {
          setState(() {
            _index = index;
            navigateToPage(context , _index);
          });
        },
      ),
    );
  }
}