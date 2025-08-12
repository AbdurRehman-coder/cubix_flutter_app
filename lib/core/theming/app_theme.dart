import 'package:cubix_app/core/utils/app_exports.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundColor,
      primaryColor: AppColors.primaryOrangeColor,
      canvasColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryOrangeColor,
      ),
      fontFamily: 'Lato',
    );
  }
}
