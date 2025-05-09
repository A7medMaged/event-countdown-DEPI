// ignore_for_file: use_build_context_synchronously

import 'package:event_app/core/helpers/theming/colors.dart';
import 'package:event_app/core/routing/routes.dart';
import 'package:event_app/views/splash_screen/widgets/sliding_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({super.key});

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();
    initSlidingAnimation();
    navigateToHome();
  }

  void navigateToHome() {
    Future.delayed(Duration(seconds: 4), () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        context.go(AppRoutes.eventView);
      } else {
        context.go(AppRoutes.loginScreen);
      }
    });
  }

  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    slidingAnimation = Tween<Offset>(
      begin: const Offset(0, 10),
      end: Offset.zero,
    ).animate(animationController);

    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(FontAwesomeIcons.calendarCheck, color: secondColor, size: 150),
        SlidingText(slidingAnimation: slidingAnimation),
      ],
    );
  }
}
