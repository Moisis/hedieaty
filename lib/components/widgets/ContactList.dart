import 'package:flutter/material.dart';
import '../../modules/Contact.dart';
import 'ContactCard.dart';

class ContactList extends StatelessWidget {
  final List<Contact> contacts;
  final String searchQuery;

  ContactList({required this.contacts, required this.searchQuery});


  List<Contact> searchContacts(List<Contact> contacts, String searchQuery) {
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

    final filteredContacts = searchContacts(contacts, searchQuery);

    return ListView.builder(
      itemCount: filteredContacts.length *1,
      itemBuilder: (context, index) {
        final contact = filteredContacts[0];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: ContactCard(
            name: contact.name,
            phoneNumber: contact.phoneNumber,
            profileImageUrl: contact.profileImageUrl,
            events: contact.events,
          ),
        );
      },
    );
  }
}