import '../utils/app_exports.dart';

class AppAssets {
  static const String appLogoAnimation = 'assets/gifs/logo_animation.gif';
  static const String feedbackAnimation = 'assets/gifs/feedback_animation.gif';

  // Images
  static const String onboardingImage = 'assets/images/onboarding_image.png';
  static const String appLogo = 'assets/images/app_logo.png';
  static const String nutritionIcon = 'assets/images/nutriton_image.png';

  // Icons
  static const String appleIcon = 'assets/icons/apple_icon.svg';
  static const String googleIcon = 'assets/icons/google_icon.svg';
  static const String homeIcon = 'assets/icons/home_icon.svg';
  static const String lessonsIcon = 'assets/icons/lessons_icon.svg';
  static const String settingsIcon = 'assets/icons/settings_icon.svg';
  static const String exploreIcon = 'assets/icons/explore_icon.svg';
  static const String feedbackIcon = 'assets/icons/feedback_icon.svg';
  static const String bookIcon = 'assets/icons/book_icon.svg';

  static const String downloadIcon = 'assets/icons/download_icon.svg';
  static const String maskCurve = 'assets/icons/mask_curve.svg';
  static const String appIcon2 = 'assets/icons/app_logo_2.svg';
  static const String crossIcon = 'assets/icons/cross_icon.svg';
  static const String deleteIcon = 'assets/icons/delete_icon.svg';

  static String getIconPath(String courseCode) {
    final formattedCode = courseCode.replaceAll(' ', '').toLowerCase();
    return 'assets/images/$formattedCode.png';
  }

  static Color getCategoryColor(String categoryName) {
    switch (categoryName) {
      case 'gen':
        return const Color(0xffFFDBBF);
      case 'busi_econ':
        return const Color(0xffC5E3D3);
      case 'psy_human':
        return const Color(0xffC1DBFD);
      case 'arts_human':
        return const Color(0xffFFF5CB);
      case 'heal_life':
        return const Color(0xffE5D3F1);
      case 'Innovation':
        return const Color(0xffD4F8E8);
      default:
        return const Color(0xffF0F0F0); // fallback color
    }
  }
}
