import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/lessons/presentation/screens/ui_lesson_details.dart';

import '../../../../core/services/analytics_services.dart';

class TopicItem extends StatelessWidget {
  final SubjectTopic topic;
  final bool needToGenerate;
  final bool showConnector;
  final bool isCompleted;
  final bool isLocked;
  final bool isReady;
  final bool isLoading;
  final String sectionTitle;
  final Function() onCompletion;

   TopicItem({
    super.key,
    required this.topic,
    required this.needToGenerate,
    required this.showConnector,
    required this.isCompleted,
    required this.isLocked,
    required this.isReady,
    required this.onCompletion,
    required this.isLoading,
    required this.sectionTitle
  });

  final analytics = locator<AnalyticServices>();
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(0xffC7C7C9);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: getProportionateScreenHeight(16)),

            isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 4.5,
                    strokeCap: StrokeCap.round,
                    backgroundColor: const Color(0xffFFDBBF),
                    color: AppColors.primaryOrangeColor,
                  ),
                )
                : Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color:
                        isCompleted
                            ? Color(0xFF199051)
                            : isReady
                            ? AppColors.primaryOrangeColor
                            : backgroundColor,
                    border: Border.all(
                      color:
                          isCompleted
                              ? Color(0xFF199051)
                              : isReady
                              ? AppColors.primaryOrangeColor
                              : backgroundColor,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child:
                        isCompleted
                            ? const Icon(
                              Icons.check_circle,
                              size: 15,
                              color: AppColors.whiteColor,
                            )
                            : Icon(
                              Icons.circle,
                              color: AppColors.whiteColor,
                              size: 13,
                            ),
                  ),
                ),

            SizedBox(height: 10),
            if (showConnector)
              CustomPaint(
                size: Size(1.2, 50),

                painter: DashedLineVerticalPainter(
                  isCompleted
                      ? Color(0xFF199050).withValues(alpha: 0.4)
                      : Color(0xffC7C7C9),
                ),
              ),
          ],
        ),

        const SizedBox(width: 18),

        Expanded(
          child: GestureDetector(
            onTap: () {
              if (!needToGenerate) {
                analytics.logLessonStarted(lessonTitle: topic.topicTitle, sectionTitle:sectionTitle);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => LessonDetailsScreen(
                          subjectTopic: topic,
                          onCompletion: onCompletion,
                        ),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color:
                    needToGenerate ? Color(0xffE3E3E4) : AppColors.whiteColor,
                border: Border.all(
                  color:
                      isCompleted
                          ? Color(0xFF199051)
                          : isReady
                          ? AppColors.primaryOrangeColor
                          : backgroundColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                topic.topicTitle,
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                      needToGenerate ? Color(0xff8E8E93) : AppColors.blackColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  final Color color;

  DashedLineVerticalPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = size.width;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant DashedLineVerticalPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
