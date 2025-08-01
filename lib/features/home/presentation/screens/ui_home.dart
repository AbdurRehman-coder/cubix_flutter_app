import 'package:cubix_app/core/utils/app_exports.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
          vertical: getProportionateScreenHeight(21),
        ),
        children: [
          Row(
            children: [
              Text(
                'CUBIX',
                style: AppTextStyles.headingTextStyle.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              GestureDetector(
                child: SvgPicture.asset(
                  AppAssets.feedbackIcon,
                  height: getProportionateScreenHeight(25),
                ),
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(46)),
          HomeBannerSlider(),
          SizedBox(height: getProportionateScreenHeight(16)),
          HabitsSection(),
          SizedBox(height: getProportionateScreenHeight(25)),
          BrainBitesSection(),
          SizedBox(height: getProportionateScreenHeight(25)),
          CareerSkillsSection(),
          SizedBox(height: getProportionateScreenHeight(25)),
          SelfInsightSection(),
          SizedBox(height: getProportionateScreenHeight(25)),
          AcademicBoostSection(),
        ],
      ),
    );
  }
}
