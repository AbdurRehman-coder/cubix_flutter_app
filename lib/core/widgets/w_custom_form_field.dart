import 'package:cubix_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import '../utils/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color? fillColor;
  final int maxLines;
  final double borderRadius;
  final Color? borderColor;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    this.fillColor = Colors.transparent,
    this.hintText = "What's one thing you liked or didn't like about the app?",
    this.maxLines = 4,
    this.validator,
    this.borderRadius = 20,
    this.borderColor,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      onChanged: (value) {},
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: fillColor,
        suffixIcon: suffixIcon,
        hintStyle: AppTextStyles.bodyTextStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xffAAAAAE),
          height: 25 / 14,
        ),
        errorStyle: AppTextStyles.bodyTextStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 25 / 14,
          color: AppColors.errorColor,
        ),
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? Color(0xffE3E3E4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Color(0xffE3E3E4), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
        ),
      ),

      style: AppTextStyles.bodyTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 25 / 14,
      ),
    );
  }
}
