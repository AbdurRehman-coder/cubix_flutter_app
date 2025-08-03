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

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryOrangeColor,
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Image.asset(
              AppAssets.appLogo,
              height: getProportionateScreenHeight(90),
              width: getProportionateScreenWidth(90),
            ),
            SizedBox(height: getProportionateScreenHeight(14)),
            Text(
              'Cubix',
              style: AppTextStyles.headingTextStyleInter.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: EdgeInsets.only(
                bottom: getProportionateScreenHeight(30),
              ),
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
