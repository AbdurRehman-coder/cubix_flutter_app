import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/models/home_banner_model.dart';

final List<HomeBannerModel> homeBannerList = [
  HomeBannerModel(
    title: 'Learn Smarter, Not Harder',
    subtitle: 'Bite-sized lessons designed to fit into\nyour day',
    colorTheme: BannerThemeColor(
      background: Color(0xFF8CC7A8),
      circle1: Color(0xFF199051),
      circle2: Color(0xFF53AC7D),
    ),
  ),
  HomeBannerModel(
    title: 'Make Progress Fast',
    subtitle:
        'Built to give you quick wins and\nlasting takeaways in just minutes',
    colorTheme: BannerThemeColor(
      background: Color(0xFFFDB400),
      circle1: Color(0xFFFE7101),
      circle2: Color(0xFFFED730),
    ),
  ),
  HomeBannerModel(
    title: 'Learn What Matters to You',
    subtitle: 'From school subjects to personal\ngrowth',
    colorTheme: BannerThemeColor(
      background: Color(0xFF00A3FE),
      circle1: Color(0xFF096EF9),
      circle2: Color(0xFF0753BB),
    ),
  ),
];
