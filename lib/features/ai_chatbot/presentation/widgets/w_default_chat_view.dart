import 'package:cubix_app/features/ai_chatbot/data/sample_model.dart';

import '../../../../core/utils/app_exports.dart';

class DefaultChatView extends StatelessWidget {
  final List<AssistantSample> preDefinedMessages;
  final TextEditingController controller;
  final ValueNotifier<bool> hasText;
  const DefaultChatView({
    super.key,
    required this.preDefinedMessages,
    required this.controller,
    required this.hasText,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'What Do You Want To\nLearn Today?',
                style: AppTextStyles.bodyTextStyle.copyWith(
                  color: AppColors.lightBlackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close_sharp,
                  size: 30,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Let’s Build A Learning Path Together',
            style: AppTextStyles.bodyTextStyle.copyWith(
              color: AppColors.textTertiaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(100)),
          Center(
            child: Image.asset(
              AppAssets.appLogoAnimation,
              height: getProportionateScreenHeight(120),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(100)),
          Text(
            'Try Telling Me',
            style: AppTextStyles.bodyTextStyle.copyWith(
              color: AppColors.lightBlackColor,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.9,
            ),
            itemCount: preDefinedMessages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  controller.text = preDefinedMessages[index].message;
                  hasText.value = true;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AppAssets.starsIcon),
                      const SizedBox(height: 4),
                      Text(
                        preDefinedMessages[index].interface,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          color: AppColors.lightBlackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
