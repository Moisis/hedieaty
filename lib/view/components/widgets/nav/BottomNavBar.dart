import 'package:bubble_navigation_bar/bubble_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;


class Bottomnavbar extends StatefulWidget {

  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  const Bottomnavbar({
    Key? key,
    required this.currentIndex,
    required this.onIndexChanged,
  }) : super(key: key);

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  @override
  Widget build(BuildContext context) {
    return BubbleNavigationBar(
      currentIndex: widget.currentIndex,
      onIndexChanged: widget.onIndexChanged,

      items: [

        BubbleNavItem(
          icon: badges.Badge(
            position: badges.BadgePosition.topEnd(top: -10, end: 12),
            badgeContent: const Text('3'),
            child: const Icon(Icons.notifications),
          ),
          label: 'Notifications',
        ),
        // const BubbleNavItem(
        //   icon: Icon(Icons.card_giftcard),
        //   label: 'Pledged Gifts',
        // ),
        const BubbleNavItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BubbleNavItem(
          icon: Icon(Icons.celebration),
          label: 'Events',
        ),
        const BubbleNavItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),

      ],
    );
  }
}
