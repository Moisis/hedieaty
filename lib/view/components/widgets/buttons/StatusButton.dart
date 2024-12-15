import'package:flutter/material.dart';
import 'package:hedieaty/utils/AppColors.dart';

class BookingStatusButton extends StatelessWidget {
  const BookingStatusButton({
    Key? key,
    required this.label,
    required this.onTap,
    required this.isActive,
    required this.index,
  }) : super(key: key);

  final String label;
  final bool isActive;
  final int index;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? AppColors.secondary : Colors.grey[200],
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 25,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}