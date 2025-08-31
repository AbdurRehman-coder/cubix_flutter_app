import 'dart:developer';
import 'package:cubix_app/core/utils/app_exports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryOrangeColor,
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Image.asset(AppAssets.appLogoAnimation, height: 90, width: 90),
            const SizedBox(height: 14),
            Text(
              'Cubix',
              style: AppTextStyles.headingTextStyleInter.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Where learning clicks into place',
                style: AppTextStyles.bodyTextStyleInter.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleNavigation() async {
    final loggedUser = await locator.get<SharedPrefServices>().getLoggedUser();
    log('Logged user: ${loggedUser?.toJson()}');
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    if (loggedUser == null || loggedUser.accessToken.isEmpty) {
      Navigator.pushNamed(context, AppRoutes.signIn);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.mainScreen);
    }
  }
}
