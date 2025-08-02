// Selected category provider
import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/explore/data/mock_course_data.dart';
import 'package:cubix_app/features/explore/models/course_model.dart';

final selectedCategoryProvider = StateProvider<CourseCategory>((ref) {
  return CourseCategory.core;
});

// Courses provider that reacts to category changes
final coursesProvider = Provider<List<Course>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  return MockCourseData.courses[selectedCategory] ?? [];
});
