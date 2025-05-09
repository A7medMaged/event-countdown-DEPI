import 'package:events_dashboard/core/helpers/theming/colors.dart';
import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final Function(String?) validator;
  final TextInputType? keyboardType;
  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    required this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIconColor: WidgetStateColor.resolveWith(
          (states) =>
              states.contains(WidgetState.focused) ? secondColor : lightGray,
        ),
        isDense: true,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(
                style: BorderStyle.solid,
                color: secondColor,
                width: 1.3,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: lightGray, width: 1.3),
              borderRadius: BorderRadius.circular(16.0),
            ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          borderRadius: BorderRadius.circular(16.0),
        ),
        hintStyle:
            hintStyle ??
            TextStyle(
              color: lightGray,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
        hintText: hintText,
        suffixIcon: suffixIcon,
        // suffixIconColor: mainBlue,
        fillColor: backgroundColor ?? black,
        filled: true,
      ),
      obscureText: isObscureText ?? false,
      style: TextStyle(
        color: lightGray,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      validator: (value) {
        return validator(value);
      },
    );
  }
}
