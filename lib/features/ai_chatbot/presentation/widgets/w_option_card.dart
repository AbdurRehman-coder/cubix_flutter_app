import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/ai_chatbot/data/chat_response_model.dart';

class CustomOptionCard extends StatelessWidget {
  final ChatOption chatOption;
  final VoidCallback? onTap;

  const CustomOptionCard({super.key, required this.chatOption, this.onTap});

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, borderColor, textColor) = _getColors(chatOption);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          chatOption.buttonMessage,
          style: AppTextStyles.bodyTextStyle.copyWith(
            color: textColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  (Color, Color, Color) _getColors(ChatOption option) {
    final colorName = option.buttonColor.toLowerCase();

    final background = switch (colorName) {
      'primary' => AppColors.primaryOrangeColor,
      'subject' => AppColors.blueColor,
      _ => Colors.transparent,
    };

    final isSecondary = colorName == 'secondary';

    final border = isSecondary ? AppColors.primaryOrangeColor : background;

    final text =
        isSecondary
            ? AppColors.primaryOrangeColor
            : (background == Colors.transparent
                ? AppColors.textTertiaryColor
                : AppColors.whiteColor);

    return (background, border, text);
  }
}
