import 'package:cubix_app/core/utils/app_exports.dart';

class HomeBannerModel {
  final String title;
  final String subtitle;
  final BannerThemeColor colorTheme;

  HomeBannerModel({
    required this.title,
    required this.subtitle,
    required this.colorTheme,
  });
}

class BannerThemeColor {
  final Color background;
  final Color circle1;
  final Color circle2;

  BannerThemeColor({
    required this.background,
    required this.circle1,
    required this.circle2,
  });
}
