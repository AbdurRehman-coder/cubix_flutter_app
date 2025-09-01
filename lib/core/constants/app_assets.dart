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
  static const String starsIcon = 'assets/icons/stars_icon.svg';
  static const String searchIcon = 'assets/icons/search_icon.svg';
  static String getIconPath(String abbreviation, String category) {
    if (category == "book") {
      return 'assets/icons/book.svg';
    } else if (abbreviation == "EP") {
      return 'assets/icons/Sky Color & Light.svg';
    } else if (abbreviation == "AI: How, Uses & Future") {
      return 'assets/icons/AIF.svg';
    } else {
      return 'assets/icons/$abbreviation.svg';
    }
  }
}
