import 'package:cubix_app/features/home/models/subject_details_model.dart';
import 'package:cubix_app/core/utils/app_exports.dart';

class LessonDetailsScreen extends ConsumerStatefulWidget {
  final SubjectTopic subjectTopic;
  final Function() onCompletion;

  const LessonDetailsScreen({
    super.key,
    required this.subjectTopic,
    required this.onCompletion,
  });

  @override
  ConsumerState<LessonDetailsScreen> createState() =>
      _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends ConsumerState<LessonDetailsScreen> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with progress
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: AppColors.blackColor.withValues(alpha: 0.25),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              left: 16,
              right: 65,
              top: 21,
              bottom: 20,
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      'assets/icons/cross_icon.svg',
                      height: 25,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE3E3E4), width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: LinearProgressIndicator(
                          value:
                              (currentStep + 1) /
                              ((widget.subjectTopic.pages?.length ?? 1)
                                  .toDouble()),
                          minHeight: 7,
                          backgroundColor: const Color(0xFFE3E3E4),
                          borderRadius: BorderRadius.circular(30),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryOrangeColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(child: _buildContent()),

          Padding(
            padding: const EdgeInsets.all(30),
            child: PrimaryButton(
              borderRadius: 12,
              height: 48,
              text: _getButtonText(),
              onPressed: _handleButtonPress,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final pages = widget.subjectTopic.pages ?? [];
    if (pages.isEmpty || currentStep >= pages.length) {
      return Center(
        child: Text(
          'No lesson content found.',
          style: AppTextStyles.bodyTextStyle.copyWith(
            fontSize: 14,
            color: AppColors.textSecondaryColor,
          ),
        ),
      );
    }

    final currentPage = pages[currentStep];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentPage.pageTitle,
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            currentPage.pageData,
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xff242425),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    if (currentStep < (widget.subjectTopic.pages?.length ?? 0) - 1) {
      return 'Continue';
    } else {
      return 'Finish';
    }
  }

  void _handleButtonPress() {
    if (currentStep < (widget.subjectTopic.pages?.length ?? 0) - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      widget.onCompletion();

      Navigator.pop(context);
    }
  }
}
