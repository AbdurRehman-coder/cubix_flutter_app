import 'package:cubix_app/core/utils/app_exports.dart';

class FeedbackDialog extends ConsumerStatefulWidget {
  const FeedbackDialog({super.key});

  @override
  ConsumerState<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends ConsumerState<FeedbackDialog>
    with SingleTickerProviderStateMixin {
  bool _isFeedbackSent = false;

  bool _showLoading = false;

  final TextEditingController _feedbackController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _formKey = GlobalKey<FormState>();

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

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _showLoading = true;
      });
      final success = await locator.get<HomeServices>().createFeedback(
        description: _feedbackController.text,
      );
      if (success) {
        setState(() {
          _isFeedbackSent = true;
          _showLoading = false;
        });
        _animationController.forward();
      } else {
        setState(() {
          _showLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send feedback")),
        );
      }
    }
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
      backgroundColor: AppColors.whiteColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      clipBehavior: Clip.none,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    _isFeedbackSent
                        ? _buildThankYouView()
                        : _buildFeedbackForm(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('feedback_form'),
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SvgPicture.asset(
              AppAssets.feedbackIcon,
              height: getProportionateScreenHeight(88),
              width: getProportionateScreenWidth(92),
              colorFilter: ColorFilter.mode(
                AppColors.primaryOrangeColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Help us improve!',
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
              height: 22 / 28,
              wordSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'This is the early version of Cubix. It\'s free while we build it and your feedback helps shape what it becomes.',
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff47474A),
              height: 22 / 16,
              wordSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          CustomTextField(
            controller: _feedbackController,
            maxLines: 5,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Feedback cannot be empty';
              }
              return null;
            },
          ),

          const SizedBox(height: 28),

          Column(
            children: [
              PrimaryButton(
                text: 'Submit',
                isLoading: _showLoading,
                onPressed: _submitFeedback,
                height: 48,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _closeFeedbackForm,
                child: Text(
                  'Cancel',
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                    height: 22 / 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
              height: 40 / 28,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          Text(
            'We really appreciate you helping us making the app better.',
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff47474A),
              height: 22 / 16,
            ),
            textAlign: TextAlign.center,
          ),

          Image.asset('assets/images/send.gif', height: 150),

          PrimaryButton(text: 'Done', onPressed: _closeThankYou, height: 48),
          const SizedBox(height: 35),
        ],
      ),
    );
  }
}
