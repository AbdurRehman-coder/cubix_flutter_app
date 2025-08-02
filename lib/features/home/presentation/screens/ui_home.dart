import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_feedback_dialog.dart';

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
              SvgPicture.asset('assets/icons/app_logo_2.svg'),
              Spacer(),
              GestureDetector(
                child: SvgPicture.asset(
                  AppAssets.feedbackIcon,
                  height: getProportionateScreenHeight(25),
                ),
                onTap: () => showFeedbackDialog(context),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(36)),
          HomeBannerSlider(),
          SizedBox(height: getProportionateScreenHeight(16)),
          GeneralEducationSection(),
          SizedBox(height: getProportionateScreenHeight(25)),
          BusinessSection(),
          SizedBox(height: getProportionateScreenHeight(25)),
          PsychologySection(),
          SizedBox(height: getProportionateScreenHeight(25)),
          ArtsHumanitiesSection(),
          SizedBox(height: getProportionateScreenHeight(25)),
          HealthScienceSection(),
        ],
      ),
    );
  }

  // Usage example:
  void showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const FeedbackDialog();
      },
    );
  }
}
