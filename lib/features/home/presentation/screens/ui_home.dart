import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_feedback_dialog.dart';

import '../../../../core/widgets/w_custom_dialog.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/app_logo_2.svg',  fit: BoxFit.scaleDown,),
              GestureDetector(
                child: SvgPicture.asset(
                  AppAssets.feedbackIcon,
                  height: getProportionateScreenHeight(25),
                ),
                onTap: () => showFeedbackDialog(context),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          HomeBannerSlider(),
          SizedBox(height: getProportionateScreenHeight(16)),
          GeneralEducationSection(),
          SizedBox(height: getProportionateScreenHeight(24)),
          BusinessSection(),
          SizedBox(height: getProportionateScreenHeight(24)),
          PsychologySection(),
          SizedBox(height: getProportionateScreenHeight(24)),
          ArtsHumanitiesSection(),
          SizedBox(height: getProportionateScreenHeight(24)),
          HealthScienceSection(),
        ],
      ),
    );
  }

  void showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const FeedbackDialog();
      },
    );
  }
}
