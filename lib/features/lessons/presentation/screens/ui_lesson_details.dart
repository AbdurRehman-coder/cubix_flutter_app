import 'package:cached_network_image/cached_network_image.dart';
import 'package:cubix_app/core/utils/app_exports.dart';
import '../../../../core/utils/text_formatter.dart';

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

  bool showLoading = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
              right: 16,
              top: 21,
              bottom: 20,
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _handleBackButtonPress,
                    child: Icon(
                      Icons.keyboard_arrow_left_rounded,
                      color: AppColors.blackColor,
                      size: 35,
                    ),
                  ),
                  const SizedBox(width: 12),
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

                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(AppAssets.crossIcon, height: 25),
                  ),
                ],
              ),
            ),
          ),

          Expanded(child: _buildContent()),
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
    return LayoutBuilder(
      builder:
          (context, constraints) => SingleChildScrollView(
            controller: _scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (currentPage.pageDiagram != null &&
                          currentPage.pageDiagram!.isNotEmpty) ...[
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: currentPage.pageDiagram!,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Image.network(
                                    'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                                    fit: BoxFit.cover,
                                  ),
                              errorWidget:
                                  (context, url, error) => Image.network(
                                    'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                                    fit: BoxFit.cover,
                                  ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                      ],
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

                      RichText(
                        text: TextFormatter.formatText(
                          currentPage.pageData,
                          AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff242425),
                            height: 1.2,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 24, 15, 0),
                        child: PrimaryButton(
                          borderRadius: 12,
                          isLoading: showLoading,
                          height: 48,
                          text: _getButtonText(),
                          onPressed: _handleButtonPress,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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

  Future<void> _handleButtonPress() async {
    if (currentStep < (widget.subjectTopic.pages?.length ?? 0) - 1) {
      setState(() {
        currentStep++;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      });
    } else {
      setState(() {
        showLoading = true;
      });
      await widget.onCompletion();
      setState(() {
        showLoading = false;
      });
    }
  }

  Future<void> _handleBackButtonPress() async {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      });
    } else {
      Navigator.of(context).pop();
    }
  }
}
