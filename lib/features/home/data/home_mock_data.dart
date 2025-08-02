import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/models/home_banner_model.dart';

final List<HomeBannerModel> homeBannerList = [
  HomeBannerModel(
    title: 'Learn Smarter, Not Harder',
    subtitle:
        'Short, focused lessons that fit between\nclasses, homework, or even lunch.',
    colorTheme: BannerThemeColor(
      background: Color(0xFF8CC7A8),
      circle1: Color(0xFF199051),
      circle2: Color(0xFF53AC7D),
    ),
  ),
  HomeBannerModel(
    title: 'Make Progress Fast',
    subtitle:
        'Get quick wins that actually help\nyou score higher on quizzes,\ntests, and assignments.',
    colorTheme: BannerThemeColor(
      background: Color(0xFFFDB400),
      circle1: Color(0xFFFE7101),
      circle2: Color(0xFFFED730),
    ),
  ),
  HomeBannerModel(
    title: 'Learn What Matters to You',
    subtitle:
        'From economics to psychology, focus\nonly on the subjects that help you\npass your classes.',
    colorTheme: BannerThemeColor(
      background: Color(0xFF00A3FE),
      circle1: Color(0xFF096EF9),
      circle2: Color(0xFF0753BB),
    ),
  ),
];
