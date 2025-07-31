import 'package:cubix_app/core/utils/app_exports.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final bool fullWidth;
  final Widget? icon;
  final double borderRadius;
  final bool enabled;
  final double elevation;
  final bool iconLeading; // NEW

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
    this.fullWidth = true,
    this.icon,
    this.borderRadius = 10,
    this.elevation = 0,
    this.iconLeading = false, // NEW: default to false (icon after text)
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primaryOrangeColor,
          side: BorderSide(
            color: backgroundColor ?? AppColors.primaryOrangeColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: Size(fullWidth ? double.infinity : 0, 56),
        ),
        child: _buildButtonContent(),
      );
    }

    return ElevatedButton(
      onPressed:
          enabled
              ? isLoading
                  ? null
                  : onPressed
              : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primaryOrangeColor,
        foregroundColor: textColor ?? AppColors.whiteColor,
        overlayColor: Colors.transparent,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: Size(
          fullWidth ? double.infinity : 0,
          getProportionateScreenHeight(56),
        ),
        elevation: elevation,
        disabledBackgroundColor: AppColors.textSecondaryColor,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined
                ? (backgroundColor ?? AppColors.primaryOrangeColor)
                : (textColor ?? Colors.white),
          ),
        ),
      );
    }

    if (icon != null) {
      final textWidget = Text(text, style: AppTextStyles.buttonTextStyle);
      const spacing = SizedBox();

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            iconLeading
                ? [icon!, textWidget, spacing]
                : [textWidget, spacing, icon!],
      );
    }

    return Text(text, style: AppTextStyles.buttonTextStyle);
  }
}
