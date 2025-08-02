import 'package:cubix_app/features/lessons/presentation/screens/ui_lesson_details.dart';
import 'package:cubix_app/features/lessons/provider/lessons_provider.dart';
import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/explore/models/course_model.dart';

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
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
                height: 22 / 30,
              ),
            ),
          ),
          // Tab Bar
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildTab('Ongoing', 0, selectedTab, ref),

                _buildTab('Completed', 1, selectedTab, ref),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Course Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
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
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
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
                        : const Color(0xFF8E8E93),
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
      // Completed courses - courses where all lessons are completed
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => LessonDetailsScreen(
                  courseId: course.id,
                  chapterId: course.chapters.first.id,
                ),
          ),
        );
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
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,

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
                    height: 91,
                    width: 91,
                  ),
                ),
              ),
            ),

            // Course Info
            Padding(
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
                  const SizedBox(height: 16),

                  // Progress
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Progress Bar
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor:
                          progress.total > 0
                              ? progress.completed / progress.total
                              : 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrangeColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
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
        return const Color(0xFFB39DDB);
      case 'ECON 101':
        return const Color(0xFF81C784);
      case 'PSY 101':
        return const Color(0xFF64B5F6);
      default:
        return const Color(0xFF90A4AE);
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
