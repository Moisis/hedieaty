// TODO Implement this library.// Example list of events
import 'Event.dart';
import 'Friend.dart';
import 'Gift.dart';

List<Event> sampleEvents = [
  Event(
    name: "Birthday",
    date: DateTime(2024, 3, 5),
    location: "City Park",
    description: "Celebration with family and friends.",
  ),
  Event(
    name: "Anniversary",
    date: DateTime(2024, 7, 10),
    location: "Beachside Resort",
    description: "Anniversary celebration.",
  ),
  Event(
    name: "Graduation",
    date: DateTime(2023, 11, 12),
    location: "University Hall",
    description: "Graduation ceremony.",
  ),
  Event(
    name: "Holiday Gathering",
    date: DateTime(2024, 12, 25),
    location: "Family Home",
    description: "Annual holiday celebration.",
  ),
];
// Example list of contacts
List<Friend> contacts = [
  Friend(
    name: "John Doe",
    phoneNumber: "+1 234 567 890",
    profileImageUrl: "https://randomuser.me/api/portraits/men/1.jpg",
    events: [sampleEvents[0], sampleEvents[1]],
    giftList: [
      Gift(
        name: "Wireless Earbuds",
        description: "High-quality noise-cancelling earbuds",
        imageUrl: '',
        event: sampleEvents[0],
      ),
      Gift(
        name: "Cookbook",
        description: "Recipe book for international dishes",
        imageUrl: '',
        event: sampleEvents[1],
      ),
    ],
  ),
  Friend(
    name: "Jane Smith",
    phoneNumber: "+1 987 654 321",
    profileImageUrl: "https://randomuser.me/api/portraits/women/2.jpg",
    events: [],
    giftList: [
      // Gift(
      //   name: "Yoga Mat",
      //   description: "Eco-friendly yoga mat",
      //   imageUrl: '',
      //   event: sampleEvents[2],
      // ),
      // Gift(
      //   name: "Essential Oil Diffuser",
      //   description: "Portable diffuser for aromatherapy",
      //   imageUrl: '',
      //   event: sampleEvents[2],
      // ),
    ],
  ),
  Friend(
    name: "Mike Johnson",
    phoneNumber: "+1 555 666 777",
    profileImageUrl: "https://randomuser.me/api/portraits/men/3.jpg",
    events: [sampleEvents[1], sampleEvents[3]],
    giftList: [
      Gift(
        name: "Portable Charger",
        description: "Compact power bank for devices",
        imageUrl: '',
        event: sampleEvents[1],
      ),
      Gift(
        name: "Running Shoes",
        description: "Comfortable shoes for daily runs",
        imageUrl: '',
        event: sampleEvents[3],
      ),
    ],
  ),
  Friend(
    name: "Alice Green",
    phoneNumber: "+1 222 333 444",
    profileImageUrl: "https://randomuser.me/api/portraits/women/4.jpg",
    events: [sampleEvents[0], sampleEvents[2], sampleEvents[3]],
    giftList: [
      Gift(
        name: "Indoor Plant",
        description: "Low-maintenance plant for indoors",
        imageUrl: '',
        event: sampleEvents[0],
      ),
      Gift(
        name: "Watercolor Set",
        description: "Paint set for creative painting",
        imageUrl: '',
        event: sampleEvents[2],
      ),
    ],
  ),
  Friend(
    name: "Robert Brown",
    phoneNumber: "+1 321 654 987",
    profileImageUrl: "https://randomuser.me/api/portraits/men/5.jpg",
    events: [sampleEvents[3], sampleEvents[1]],
    giftList: [
      Gift(
        name: "Leather Wallet",
        description: "Minimalist wallet with card slots",
        imageUrl: '',
        event: sampleEvents[1],
      ),
      Gift(
        name: "Board Game",
        description: "Strategy game for family game nights",
        imageUrl: '',
        event: sampleEvents[3],
      ),
    ],
  ),
  // Add more friends as needed
];



getFriendList() {
  return contacts;
}

getEventList() {
  return sampleEvents;
}