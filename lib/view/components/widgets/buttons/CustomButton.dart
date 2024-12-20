import 'package:flutter/material.dart';
import 'package:hedieaty/utils/AppColors.dart';

class Custombutton extends StatelessWidget {

  Custombutton( {required this.title, required this.onPress});

  final String title ;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.07,
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