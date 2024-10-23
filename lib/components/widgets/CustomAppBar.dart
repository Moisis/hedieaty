// lib/components/CustomAppBar.dart
import 'package:flutter/material.dart';
import '../AppColors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchClicked;
  final TextEditingController searchController;
  final Duration animationDuration;
  final Function(String) onSearchChanged;
  final VoidCallback onSearchIconPressed;
  final VoidCallback onSettingsIconPressed;

  CustomAppBar({
    required this.isSearchClicked,
    required this.searchController,
    required this.animationDuration,
    required this.onSearchChanged,
    required this.onSearchIconPressed,
    required this.onSettingsIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isSearchClicked
          ? const Icon(Icons.arrow_back_sharp, color: AppColors.white)
          : Image.asset("assets/images/intro_gift(No_bg).png"),
      backgroundColor: AppColors.primary,
      title: AnimatedContainer(
        duration: animationDuration,
        width: isSearchClicked
            ? MediaQuery.of(context).size.width * 0.7
            : MediaQuery.of(context).size.width * 0.4,
        child: isSearchClicked
            ? TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search here...',
            border: InputBorder.none,
            hintStyle: AppColors.textPrimary_h2,
          ),
          onChanged: onSearchChanged,
        )
            : const Text(
          'Hedieaty',
          style: AppColors.textPrimary_h1,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            isSearchClicked ? Icons.close : Icons.search,
            color: AppColors.white,
          ),
          onPressed: onSearchIconPressed,
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: AppColors.white),
          onPressed: onSettingsIconPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}