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

  Future<void> _handleNavigation() async {
    final token = await locator.get<SharedPrefServices>().getAccessToken();
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;

    if (token == null || token.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CustomBottomNavBar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryOrangeColor,
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Image.asset(AppAssets.appLogo, height: 90, width: 90),
            const SizedBox(height: 14),
            Text(
              'Cubix',
              style: AppTextStyles.headingTextStyleInter.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
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
}
