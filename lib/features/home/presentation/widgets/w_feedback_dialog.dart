import 'package:cubix_app/core/utils/app_exports.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog>
    with SingleTickerProviderStateMixin {
  bool _isFeedbackSent = false;
  final TextEditingController _feedbackController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    setState(() {
      _isFeedbackSent = true;
    });
    _animationController.forward();
  }

  void _closeFeedbackForm() {
    Navigator.of(context).pop();
  }

  void _closeThankYou() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(24),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isFeedbackSent ? _buildThankYouView() : _buildFeedbackForm(),
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Column(
      key: const ValueKey('feedback_form'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon
        Center(
          child: SvgPicture.asset(
            AppAssets.feedbackIcon,
            height: getProportionateScreenHeight(88),
            colorFilter: ColorFilter.mode(
              AppColors.primaryOrangeColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'Help us improve!',
          style: AppTextStyles.bodyTextStyle.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Description
        Text(
          'This is the early version of Cubix. It\'s free while we build it and your feedback helps shape what it becomes.',
          style: AppTextStyles.bodyTextStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff47474A),
            height: 26 / 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // Text Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xffE5E5E5)),
          ),
          child: TextField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
                  'What\'s one thing you liked or didn\'t like about the app?',
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xff9E9E9E),
                height: 1.2,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xff242425),
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Buttons
        Column(
          children: [
            PrimaryButton(text: 'Submit', onPressed: _submitFeedback),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _closeFeedbackForm,
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff242425),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThankYouView() {
    return FadeTransition(
      key: const ValueKey('thank_you'),
      opacity: _fadeAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Center(
            child: SvgPicture.asset(
              AppAssets.feedbackIcon,
              height: getProportionateScreenHeight(88),
              colorFilter: ColorFilter.mode(
                AppColors.primaryOrangeColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'Thanks for the feedback!',
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: AppColors.blackColor,
              height: 26 / 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'We really appreciate you helping us making the app better.',
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff47474A),
              height: 26 / 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Play Icon
          SvgPicture.asset(
            AppAssets.feedbackIcon,
            height: getProportionateScreenHeight(25),
          ),
          const SizedBox(height: 40),

          // Done Button
          PrimaryButton(text: 'Done', onPressed: _closeThankYou),
        ],
      ),
    );
  }
}
