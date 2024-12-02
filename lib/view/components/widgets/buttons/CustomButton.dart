import 'package:flutter/material.dart';
import 'package:hedieaty/utils/AppColors.dart';

class Custom_button extends StatelessWidget {

  Custom_button( {required this.title, required this.onPress});

  final String title ;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPress,
        child:  Text(title , style: AppColors.textPrimary_h1,),
      ),
    );
  }

}