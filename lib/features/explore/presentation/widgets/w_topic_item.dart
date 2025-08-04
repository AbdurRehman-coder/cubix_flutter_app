import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/models/subject_details_model.dart';
import 'package:cubix_app/features/lessons/presentation/screens/ui_lesson_details.dart';

class TopicItem extends StatelessWidget {
  final SubjectTopic topic;

  final bool showConnector;

  const TopicItem({
    super.key,
    required this.topic,
    required this.showConnector,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(0xffC7C7C9);

    // switch (lesson.status) {
    //   case LessonStatus.completed:
    //     backgroundColor = const Color(0xFF199051);

    //     break;
    //   case LessonStatus.current:
    //     backgroundColor = AppColors.primaryOrangeColor;

    //     break;
    //   case LessonStatus.locked:
    //     backgroundColor = Color(0xffC7C7C9);

    //     break;
    // }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: getProportionateScreenHeight(16)),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: backgroundColor, width: 2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child:
                    // lesson.status == LessonStatus.completed
                    false
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
                  //  lesson.status == LessonStatus.completed
                  false
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
              if (true) {
                //todo: lesson.status != LessonStatus.locked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => LessonDetailsScreen(subjectTopic: topic),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border.all(
                  color:
                      // lesson.status == LessonStatus.current ||
                      //         lesson.status == LessonStatus.completed
                      false ? backgroundColor : Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                topic.topicTitle,
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
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
