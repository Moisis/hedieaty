import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:hedieaty/pages/FriendPage.dart';
import '../../modules/Friend.dart';
import '../AppColors.dart';

class FriendCard extends StatelessWidget {
  // final String name;
  // final String phoneNumber;
  // final String profileImageUrl;
  // final int events;

  final Friend fr;

  FriendCard({
    required this.fr,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: ListTile(
        tileColor: AppColors.cardbackground,

        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade200, // Placeholder background color
          child: Hero(
            tag: fr.name,
            child: ClipOval(
              child: Image.network(
                fr.profileImageUrl,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) {
                  // Provide a fallback image if the network image fails to load
                  return Image.asset(
                    'assets/images/default_profile.png', // Ensure you have this asset in your project
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  );
                },
              ),
            ),
          ),
        ),
        title: Text(
          fr.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(fr.phoneNumber),

        trailing: badges.Badge(
          badgeContent: Text(
            fr.events.length.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          showBadge: fr.events.isNotEmpty,
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


        ) ,

        onTap: () {
          // Add any action here (e.g., open a contact details page or initiate a call)
          print("Tapped on $fr.name");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendPage(friend: fr),
            ),
          );


        },
      ),
    );
  }
}
