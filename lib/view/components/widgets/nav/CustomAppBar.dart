// // lib/components/CustomAppBar.dart

// lib/components/CustomAppBar.dart
import 'package:flutter/material.dart';
import '../../../../utils/AppColors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? isSearchClicked;
  final TextEditingController? searchController;
  final Duration? animationDuration;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchIconPressed;
  final bool showBackButton; // New parameter

  CustomAppBar({
    this.isSearchClicked = false,
    this.searchController,
    this.animationDuration = const Duration(milliseconds: 300),
    this.onSearchChanged,
    this.onSearchIconPressed,
    this.showBackButton = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    final bool showSearch = isSearchClicked ?? false;

    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          : showSearch
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: () {
                    searchController?.clear();
                    if (onSearchChanged != null) {
                      onSearchChanged!('');
                    }
                    if (onSearchIconPressed != null) {
                      onSearchIconPressed!();
                    }
                  },
                )
              : Image.asset("assets/images/intro_gift(No_bg).png"),
      backgroundColor: AppColors.primary,
      title: AnimatedContainer(
        duration: animationDuration!,
        width: showSearch
            ? MediaQuery.of(context).size.width * 0.7
            : MediaQuery.of(context).size.width * 0.4,
        child: showSearch && searchController != null
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
        if (onSearchIconPressed != null)
          IconButton(
            icon: Icon(
              Icons.search,
              color: AppColors.white,
            ),
            onPressed: onSearchIconPressed,
          ),
        IconButton(
          icon: const Icon(Icons.settings, color: AppColors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/settings_page');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
