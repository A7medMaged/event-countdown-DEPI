import 'package:events_dashboard/core/helpers/theming/colors.dart';
import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final double? borderRadius;
  final Color? backgroundColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? buttonWidth;
  final double? buttonHeight;
  final String buttonText;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  const AppTextButton({
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.buttonHeight,
    this.buttonWidth,
    required this.buttonText,
    required this.textStyle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 16.0)),
      color: backgroundColor ?? priamryColor,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 12, vertical: verticalPadding ?? 14),
      minWidth: buttonWidth ?? double.infinity,
      height: buttonHeight,
      onPressed: onPressed,
      child: Text(buttonText, style: textStyle),
    );
  }
}
