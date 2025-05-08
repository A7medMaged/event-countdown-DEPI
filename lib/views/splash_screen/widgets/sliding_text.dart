import 'package:event_app/core/helpers/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlidingText extends StatelessWidget {
  const SlidingText({super.key, required this.slidingAnimation});

  final Animation<Offset> slidingAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slidingAnimation,
      builder: (context, _) {
        return SlideTransition(
          position: slidingAnimation,
          child: Text(
            'NextUp',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: secondColor,
              fontFamily:
                  GoogleFonts.creepsterTextTheme(
                    Theme.of(context).textTheme,
                  ).bodyLarge!.fontFamily,
            ),
          ),
        );
      },
    );
  }
}
