import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/explore/models/course_model.dart';
import 'package:cubix_app/features/lessons/presentation/screens/ui_lesson_details.dart';

class CourseDetailsScreen extends StatelessWidget {
  final Course course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Color(0xFFC5E3D3)),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 24, 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close_sharp,
                            size: 30,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/brain_image.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),

                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.code,
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 11,
                      color: AppColors.greyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(8)),
                  Text(
                    course.title,
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 18,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    course.description,
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Divider(
                height: 1,
                thickness: 1,
                color: const Color(0xffE3E3E4),
              ),
            ),
            // Lessons content
            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 29),
              itemCount: course.chapters.length,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 72),
              itemBuilder: (context, chapterIndex) {
                final chapter = course.chapters[chapterIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        chapter.title,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 18,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Column(
                      children:
                          chapter.lessons.asMap().entries.map((entry) {
                            final lessonIndex = entry.key;
                            final lesson = entry.value;
                            final isLastLesson =
                                lessonIndex == chapter.lessons.length - 1;
                            return LessonItem(
                              lesson: lesson,
                              chapterId: chapter.id,
                              courseId: course.id,
                              showConnector: !(isLastLesson),
                            );
                          }).toList(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LessonItem extends StatelessWidget {
  final Lesson lesson;
  final String courseId, chapterId;
  final bool showConnector;

  const LessonItem({
    super.key,
    required this.lesson,
    required this.showConnector, required this.courseId, required this.chapterId,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;

    switch (lesson.status) {
      case LessonStatus.completed:
        backgroundColor = const Color(0xFF199051);

        break;
      case LessonStatus.current:
        backgroundColor = AppColors.primaryOrangeColor;

        break;
      case LessonStatus.locked:
        backgroundColor = Color(0xffC7C7C9);

        break;
    }

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
                    lesson.status == LessonStatus.completed
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
                  lesson.status == LessonStatus.completed
                      ? Color(0xFF199050).withValues(alpha: 0.4)
                      : Color(0xffC7C7C9),
                ),
              ),
          ],
        ),

        const SizedBox(width: 18),

        Expanded(
          child: GestureDetector(
            onTap: (){
              if(lesson.status != LessonStatus.locked){

                Navigator.push(context, MaterialPageRoute(builder: (context)=> LessonDetailsScreen(courseId: courseId, chapterId: chapterId )));
              }

            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border.all(
                  color:
                      lesson.status == LessonStatus.current ||
                              lesson.status == LessonStatus.completed
                          ? backgroundColor
                          : Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                lesson.title,
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
