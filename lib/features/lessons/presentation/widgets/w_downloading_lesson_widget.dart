import 'package:cubix_app/core/utils/app_exports.dart';

class DownloadingSubjectCard extends StatefulWidget {
  final String title;

  const DownloadingSubjectCard({super.key, required this.title});

  @override
  State<DownloadingSubjectCard> createState() => _DownloadingSubjectCardState();
}

class _DownloadingSubjectCardState extends State<DownloadingSubjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.chatBot);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.whiteColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top with circular loader
            Container(
              width: double.infinity,
              height: getProportionateScreenHeight(96),
              decoration: BoxDecoration(
                color: AppColors.primaryOrangeColor.withValues(alpha: 0.09),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: const Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    backgroundColor: Color(0xFFE3E3E4),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryOrangeColor,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 9),

            // Title
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SUBJECT",
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),

                    // Downloading text + linear loader
                    Text(
                      "Downloading",
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: _progressAnimation.value,
                            minHeight: 5,
                            backgroundColor: const Color(
                              0xFF8E8E93,
                            ).withValues(alpha: 0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryOrangeColor,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
