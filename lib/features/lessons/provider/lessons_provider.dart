// Providers
import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/explore/data/mock_course_data.dart';

// Providers
class CoursesNotifier extends StateNotifier<List<Course>> {
  CoursesNotifier() : super(MockCourseData.getAllCourses());

  void completeLesson(String courseId, String chapterId, String lessonId) {
    state =
        state.map((course) {
          if (course.id == courseId) {
            final updatedChapters =
                course.chapters.map((chapter) {
                  if (chapter.id == chapterId) {
                    final lessons = chapter.lessons;
                    final lessonIndex = lessons.indexWhere(
                      (l) => l.id == lessonId,
                    );

                    if (lessonIndex != -1) {
                      final updatedLessons = List<Lesson>.from(lessons);
                      updatedLessons[lessonIndex] = lessons[lessonIndex]
                          .copyWith(status: LessonStatus.completed);

                      // Unlock next lesson if exists
                      if (lessonIndex + 1 < lessons.length) {
                        updatedLessons[lessonIndex + 1] = lessons[lessonIndex +
                                1]
                            .copyWith(status: LessonStatus.current);
                      }

                      return chapter.copyWith(lessons: updatedLessons);
                    }
                  }
                  return chapter;
                }).toList();

            return course.copyWith(chapters: updatedChapters);
          }
          return course;
        }).toList();
  }
}

final coursesNotifierProvider =
    StateNotifierProvider<CoursesNotifier, List<Course>>((ref) {
      return CoursesNotifier();
    });

final selectedTabProvider = StateProvider<int>((ref) => 0);
