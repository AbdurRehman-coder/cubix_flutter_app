import 'package:cubix_app/core/utils/app_exports.dart';

class MessageWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const MessageWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
    );
  }
}
