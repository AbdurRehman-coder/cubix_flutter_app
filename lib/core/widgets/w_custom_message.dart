import 'package:cubix_app/core/utils/app_exports.dart';

class MessageWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const MessageWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 22,
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 14,
                color: AppColors.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
