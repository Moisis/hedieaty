import 'package:flutter/material.dart';
import 'package:hedieaty/components/AppColors.dart';
import '../../modules/Friend.dart';
import 'FriendCard.dart';



class FriendList extends StatelessWidget {
  final List<Friend> friends;
  final String searchQuery;

  FriendList({required this.friends, required this.searchQuery});


  List<Friend> searchContacts(List<Friend> contacts, String searchQuery) {
    final query = searchQuery.trim().toLowerCase(); // Trim spaces and convert to lowercase

    if (query.isEmpty) return contacts; // If the query is empty, return all contacts
    // Normalize the search query for phone numbers
    final normalizedQuery = query.replaceAll(RegExp(r'\D'), '');

    // Determine if the query is a phone number
    final isPhoneNumberQuery = RegExp(r'^\d+$').hasMatch(normalizedQuery);

    return contacts.where((contact) {
      final contactName = contact.name.trim().toLowerCase(); // Trim spaces in contact name

      // Normalize phone number by stripping non-digit characters
      final normalizedPhoneNumber = contact.phoneNumber.replaceAll(RegExp(r'\D'), '');

      // Check if the name contains the query
      final bool nameMatches = contactName.contains(query);

      // Check if the phone number contains the query (after normalizing both)
      final bool phoneMatches = normalizedPhoneNumber.contains(normalizedQuery);

      return isPhoneNumberQuery ? phoneMatches : nameMatches;
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    final filteredFriends = searchContacts(friends, searchQuery);

    if (filteredFriends.isEmpty) {
      return const Center(
        child: Text('No contacts found', style: AppColors.textPrimary_h2,),
      );
    } else {
      return ListView.builder(
        itemCount: filteredFriends.length,
        itemBuilder: (context, index) {
          final contact = filteredFriends[index];
          return FriendCard(
            fr: Friend(name: contact.name,
                phoneNumber: contact.phoneNumber,
                profileImageUrl:  contact.profileImageUrl,
                events: contact.events,
                giftList: contact.giftList)

          );
        },
      );
    }
  }




}


