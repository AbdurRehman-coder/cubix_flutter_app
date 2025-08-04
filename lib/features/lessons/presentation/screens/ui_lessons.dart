import 'package:cubix_app/features/lessons/presentation/screens/ui_lesson_details.dart';
import 'package:cubix_app/features/lessons/provider/lessons_provider.dart';
import 'package:cubix_app/core/utils/app_exports.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesNotifierProvider);
    final selectedTab = ref.watch(selectedTabProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: Text(
              'Lessons',
              style: AppTextStyles.headingTextStyle.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
                height: 22 / 30,
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(18)),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab('Ongoing', 0, selectedTab, ref),

                _buildTab('Completed', 1, selectedTab, ref),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Course Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: getProportionateScreenWidth(36),
                  mainAxisSpacing: getProportionateScreenHeight(24),
                ),
                itemCount: _getFilteredCourses(courses, selectedTab).length,
                itemBuilder: (context, index) {
                  final course =
                      _getFilteredCourses(courses, selectedTab)[index];
                  return _buildCourseCard(context, course, ref);
                },
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int tabIndex, int selectedTab, WidgetRef ref) {
    final isSelected = selectedTab == tabIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(selectedTabProvider.notifier).state = tabIndex,
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                height: 1.5,
                color:
                    isSelected ? AppColors.blackColor : const Color(0xFF8E8E93),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? AppColors.primaryOrangeColor
                        : Color(0xFF8E8E93).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Course> _getFilteredCourses(List<Course> courses, int selectedTab) {
    if (selectedTab == 0) {
      // Ongoing courses - courses with at least one lesson that's not completed
      return courses.where((course) {
        return course.chapters.any(
          (chapter) => chapter.lessons.any(
            (lesson) => lesson.status != LessonStatus.completed,
          ),
        );
      }).toList();
    } else {
      return courses.where((course) {
        return course.chapters.every(
          (chapter) => chapter.lessons.every(
            (lesson) => lesson.status == LessonStatus.completed,
          ),
        );
      }).toList();
    }
  }

  Widget _buildCourseCard(BuildContext context, Course course, WidgetRef ref) {
    final progress = _calculateProgress(course);
    final Color cardColor = _getCourseColor(course.code);

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder:
        //         (context) => LessonDetailsScreen(
        //           courseId: course.id,
        //           chapterId: course.chapters.first.id,
        //         ),
        //   ),
        // );
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
            // Course Icon
            Container(
              width: double.infinity,
              height: getProportionateScreenHeight(96),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/brain_image.png',
                  fit: BoxFit.cover,
                  height: getProportionateScreenHeight(85),
                  width: getProportionateScreenHeight(85),
                ),
              ),
            ),

            SizedBox(height: 9),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.code,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.title,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 11,
                            color: AppColors.textSecondaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '${progress.completed}/${progress.total}',
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 11,
                            color: AppColors.textSecondaryColor,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value:
                            progress.total > 0
                                ? progress.completed / progress.total
                                : 0,
                        minHeight: 4,
                        backgroundColor: const Color(
                          0xFF8E8E93,
                        ).withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryOrangeColor,
                        ),
                      ),
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

  Color _getCourseColor(String courseCode) {
    switch (courseCode) {
      case 'NUTR 101':
        return const Color(0xFFE5D3F1);
      case 'ECON 101':
        return const Color(0xFFC5E3D3);
      case 'PSY 101':
        return const Color(0xFFE6F0FE);
      default:
        return const Color(0xFFE5D3F1);
    }
  }

  CourseProgress _calculateProgress(Course course) {
    int total = 0;
    int completed = 0;

    for (final chapter in course.chapters) {
      for (final lesson in chapter.lessons) {
        total++;
        if (lesson.status == LessonStatus.completed) {
          completed++;
        }
      }
    }

    return CourseProgress(completed: completed, total: total);
  }
}

class CourseProgress {
  final int completed;
  final int total;

  CourseProgress({required this.completed, required this.total});
}
