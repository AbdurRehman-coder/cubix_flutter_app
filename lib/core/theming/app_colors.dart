import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryOrangeColor = Color(0xFFFF7101);
  static const Color secondaryPurpleColor = Color(0xFF8E24AA);
  static const Color backgroundColor = Color(0xFFF4F4F4);
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF6B6B6E);
  static const Color textTertiaryColor = Color(0xFF8E8E93);

  static const Color blackColor = Color(0xFF000000);
  static const Color lightBlackColor = Color(0xFF242425);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color brownColor = Color(0xFF401C00);
  static const Color blueColor = Color(0xFF096EF9);
  static const Color greyColor = Color(0xff6B6B6E);
  static const Color errorColor = Color(0xFFD32F2F);

  static Color getCategoryColor(String categoryName) {
    switch (categoryName) {
      case 'creativity':
        return const Color(0xffFFDBBF);
      case 'curiosity':
        return const Color(0xffFFF5CB);
      case 'book':
        return const Color(0xffE5D3F1);
      case 'careers':
        return const Color(0xFFC1DBFD);
      case 'growth':
        return const Color(0xffC5E3D3);
      default:
        return const Color(0xffFFDBBF);
    }
  }
}
