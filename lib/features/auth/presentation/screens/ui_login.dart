import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/bottom_navbar/presentation/screens/ui_main_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final notifier = ref.read(bottomNavIndexProvider.notifier);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(34),
          vertical: getProportionateScreenHeight(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(AppAssets.onboardingImage, fit: BoxFit.fill),
            SizedBox(height: getProportionateScreenHeight(45)),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Any topic. Anytime.',
                    style: AppTextStyles.headingTextStyle.copyWith(
                      color: AppColors.brownColor,
                      height: 40 / 32,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: '\nYour way.',
                    style: AppTextStyles.headingTextStyle.copyWith(
                      color: AppColors.blueColor,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: getProportionateScreenHeight(65)),
            Text(
              textAlign: TextAlign.center,
              'Sign in to continue with',
              style: AppTextStyles.bodyTextStyle.copyWith(
                color: AppColors.brownColor,
                fontSize: getProportionateScreenHeight(16),
                fontWeight: FontWeight.w500,
                wordSpacing: 1.4,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(24)),
            PrimaryButton(
              text: 'Apple',
              icon: SvgPicture.asset(
                AppAssets.appleIcon,
                fit: BoxFit.scaleDown,
              ),
              height: getProportionateScreenHeight(56),
              onPressed: () {
                if (currentIndex != 0) {
                  notifier.state = 0;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              },
              textColor: AppColors.blackColor,
              backgroundColor: AppColors.whiteColor,
            ),
            SizedBox(height: getProportionateScreenHeight(12)),
            PrimaryButton(
              text: 'Google',
              height: getProportionateScreenHeight(56),
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: SvgPicture.asset(
                  AppAssets.googleIcon,
                  fit: BoxFit.scaleDown,
                ),
              ),

              onPressed: () {
                if (currentIndex != 0) {
                  notifier.state = 0;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              },
              textColor: AppColors.blackColor,
              backgroundColor: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
