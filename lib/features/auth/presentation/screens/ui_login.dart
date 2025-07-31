import 'package:cubix_app/core/constants/app_assets.dart';
import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(34),
          vertical: getProportionateScreenHeight(12),
        ),
        child: Column(
          children: [
            Image.asset(
              AppAssets.onboardingImage,
              height: getProportionateScreenHeight(331),
              width: getProportionateScreenWidth(345),
            ),
            SizedBox(height: getProportionateScreenHeight(40)),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Any topic. Anytime.',
                    style: AppTextStyles.headingTextStyle.copyWith(
                      color: AppColors.brownColor,
                    ),
                  ),
                  TextSpan(
                    text: '\nYour way.',
                    style: AppTextStyles.headingTextStyle.copyWith(
                      color: AppColors.blueColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(8)),
            Text(
              'Powered by AI',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyTextStyle.copyWith(
                color: AppColors.textSecondaryColor,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(65)),
            Text(
              textAlign: TextAlign.center,
              'Sign in to continue with',
              style: AppTextStyles.bodyTextStyle.copyWith(
                color: AppColors.brownColor,
                fontSize: getProportionateScreenHeight(18),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(24)),
            PrimaryButton(
              text: 'Apple',
              icon: SvgPicture.asset(AppAssets.appleIcon),
              iconLeading: true,
              onPressed: () {},
              textColor: AppColors.blackColor,
              backgroundColor: AppColors.whiteColor,
            ),
            SizedBox(height: getProportionateScreenHeight(12)),
            PrimaryButton(
              text: 'Google',
              icon: SvgPicture.asset(AppAssets.googleIcon),
              iconLeading: true,
              onPressed: () {},
              textColor: AppColors.blackColor,
              backgroundColor: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
