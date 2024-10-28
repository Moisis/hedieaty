// lib/utils/navigation_helper.dart
import 'package:flutter/material.dart';


void navigateToPage(BuildContext context, int index) {
  String  page;
  switch (index) {
    case 0:
      page = '/notification_page';
      break;
    case 1:
      page = '/pledgedGifts';
      break;
    case 2:
      page = '/home_page';
      break;
    case 3:
      page ='/Eventlistpage';
      break;
    case 4:
      page = '/profile_page';
      break;
    default:
      return;
  }
  Navigator.pushReplacementNamed(
    context,
    page
  );
}