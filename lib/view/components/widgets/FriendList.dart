import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


import '../../../data/testback/Friend.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../utils/AppColors.dart';
import 'FriendCard.dart';

class FriendList extends StatelessWidget {
  final List<UserEntity> friends;
  final String searchQuery;

  FriendList({required this.friends, required this.searchQuery});

  List<UserEntity> searchContacts(List<UserEntity> contacts, String searchQuery) {
    final query = searchQuery.trim().toLowerCase(); // Trim spaces and convert to lowercase

    if (query.isEmpty) return contacts; // If the query is empty, return all contacts
    // Normalize the search query for phone numbers
    final normalizedQuery = query.replaceAll(RegExp(r'\D'), '');

    // Determine if the query is a phone number
    final isPhoneNumberQuery = RegExp(r'^\d+$').hasMatch(normalizedQuery);

    return contacts.where((contact) {
      final contactName = contact.UserName.trim().toLowerCase(); // Trim spaces in contact name

      // Normalize phone number by stripping non-digit characters
      final normalizedPhoneNumber = contact.UserPhone.replaceAll(RegExp(r'\D'), '');

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 50, color: AppColors.primary),
            SizedBox(height: 20),
            Text('No contacts found', style: AppColors.textPrimary_h2),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: filteredFriends.length,
        itemBuilder: (context, index) {
          final contact = filteredFriends[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: FriendCard(
                  fr: Friend(
                    name: contact.UserName,
                    phoneNumber: contact.UserPhone,
                    profileImageUrl: contact.UserId,
                    events: [],
                    giftList: [],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
