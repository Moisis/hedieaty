import 'package:flutter/material.dart';
import 'package:hedieaty/domain/entities/user_entity.dart';

import '../../domain/entities/friend_entity.dart';
import '../../utils/AppColors.dart';

class FriendPage extends StatelessWidget {
  final FriendEntity friend;

  const FriendPage({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${friend.UserName}\'s Profile'),
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Hero(
                  tag: friend.UserPhone ?? 'Unknown Phone',
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                      'assets/images/default_profile.png', // Ensure you have this asset in your project
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend.UserName ?? 'Unknown Name',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0x80000000)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        friend.UserEmail ?? 'Unknown Email',
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
          // Expanded(
          //   // child: ListView.builder(
          //   //   itemCount: friend.UserEventsNo ?? 0,
          //   //   itemBuilder: (context, eventIndex) {
          //   //     final event = friend.events[eventIndex];
          //   //     final eventGifts = friend.giftList
          //   //         .where((gift) => gift.event == event)
          //   //         .toList();
          //   //
          //   //     return ExpansionTile(
          //   //       title: Text(event.name),
          //   //       subtitle: Text(
          //   //         '${event.date.toLocal()} - ${event.location}',
          //   //         style: TextStyle(fontSize: 12),
          //   //       ),
          //   //       children: eventGifts.map((gift) {
          //   //         return ListTile(
          //   //           leading: Icon(Icons.card_giftcard),
          //   //           title: Text(gift.name),
          //   //           subtitle: Text(gift.description),
          //   //           trailing: ElevatedButton(
          //   //             onPressed: () {
          //   //               // Handle gift pledge functionality
          //   //             },
          //   //             child: Text('Pledge'),
          //   //           ),
          //   //         );
          //   //       }).toList(),
          //   //     );
          //   //   },
          //   // ),
          // ),
        ],
      ),
    );
  }
}