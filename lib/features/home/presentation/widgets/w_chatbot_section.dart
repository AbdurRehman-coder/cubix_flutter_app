import 'package:cubix_app/core/utils/app_exports.dart';

class ChatBotSection extends StatelessWidget {
  const ChatBotSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.chatBot);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppAssets.starsIcon,
              height: getProportionateScreenHeight(25),
            ),
            SizedBox(width: getProportionateScreenWidth(11)),
            Text(
              'Find a topic with AI',
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 16,
                color: AppColors.textPrimaryColor,
              ),
            ),
            Spacer(),

            SvgPicture.asset(
              AppAssets.searchIcon,
              height: getProportionateScreenHeight(22),
            ),
          ],
        ),
      ),
    );
  }
}
