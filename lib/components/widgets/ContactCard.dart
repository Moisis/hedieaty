import 'package:flutter/material.dart';

import 'package:badges/badges.dart' as badges;

import '../AppColors.dart';


class ContactCard extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String profileImageUrl;
  final int events;

  ContactCard({
    required this.name,
    required this.phoneNumber,
    required this.profileImageUrl,
    required this.events, // 'events' is now required and passed from ContactList
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // tileColor: AppColors.card_background,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(profileImageUrl),
        radius: 25,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(phoneNumber),
      trailing: badges.Badge(
        onTap: () {},
        badgeContent: Text(
            events.toString(),
            style: AppColors.textbadger
        ),

        showBadge:events > 0  ,

        badgeAnimation: badges.BadgeAnimation.rotation(
          animationDuration: Duration(seconds: 1),
          colorChangeAnimationDuration: Duration(seconds: 1),
          loopAnimation: false,
          curve: Curves.fastOutSlowIn,
          colorChangeAnimationCurve: Curves.easeInCubic,
        ),


        badgeStyle: badges.BadgeStyle(
          shape: badges.BadgeShape.circle,
          badgeColor: AppColors.primary,
          padding: EdgeInsets.all(10),
          elevation: 0,
        ),
      ),
      onTap: () {
        // Add any action here (e.g., open a contact details page or initiate a call)
        print("Tapped on $name");
      },
    );
  }
}