import 'package:animated_introduction/animated_introduction.dart';
import 'package:flutter/material.dart';

import '../../../utils/AppColors.dart';


final List<SingleIntroScreen> pages = [
  const SingleIntroScreen(
    title: 'Welcome to Hedieaty App !',
    description: 'You plans your Events, We\'ll do the rest and will be the best! Guaranteed!  ',
    imageAsset: 'assets/images/intro_gift(No_bg).png',
  ),
  const SingleIntroScreen(
    title: 'Receive Notifications ',
    description: 'Stay always up to date and dont miss a chance to make someone happy .',
    imageAsset: 'assets/images/intro_cal(No_bg).png',
  ),
  const SingleIntroScreen(
    title: 'Share your wishlist',
    description: 'Be able to share all your wishes at any time through custom lists. ',
    imageAsset: 'assets/images/intro_wish(No_bg).png',
  ),
];


class IntroPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AnimatedIntroduction(
      slides: pages,
      indicatorType: IndicatorType.circle,
      footerBgColor: Color(0xff78CAEB),
      doneWidget: const Text('Get Started !' , style: AppColors.textPrimary_h1 ,),
      onDone: () {
        /// TODO: Go to desire page like login or home
        Navigator.pushReplacementNamed(context, '/home_page');
      },
    );
  }
}




