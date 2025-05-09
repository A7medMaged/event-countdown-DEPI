import 'package:events_dashboard/core/helpers/theming/colors.dart';
import 'package:events_dashboard/core/routing/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackToLoginScreen extends StatelessWidget {
  const BackToLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Already have an account',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: ' ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: 'Sign in',
            style: TextStyle(
              fontSize: 13,
              color: secondColor,
              fontWeight: FontWeight.bold,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    GoRouter.of(context).pushReplacement(AppRoutes.loginScreen);
                  },
          ),
        ],
      ),
    );
  }
}
