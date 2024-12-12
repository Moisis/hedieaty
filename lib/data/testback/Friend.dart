// Contact data model

import 'package:hedieaty/data/testback/Gift.dart';


import 'Event.dart';



class Friend {
  final String name;
  final String phoneNumber;
  final String profileImageUrl;
  final List<Event> events;
  final List<Gift> giftList;

  Friend({
    required this.name,
    required this.phoneNumber,
    required this.profileImageUrl,
    this.events = const [],
    required this.giftList,
  });
}
