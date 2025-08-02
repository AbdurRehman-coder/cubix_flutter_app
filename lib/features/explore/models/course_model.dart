// models/course.dart
class Course {
  final String id;
  final String title;
  final String code;
  final String icon;
  final String category;
  final String description;
  final List<Chapter> chapters;

  const Course({
    required this.id,
    required this.title,
    required this.code,
    required this.icon,
    required this.category,
    required this.description,
    required this.chapters,
  });
}

class Chapter {
  final String id;
  final String title;
  final List<Lesson> lessons;

  const Chapter({required this.id, required this.title, required this.lessons});
}

class Lesson {
  final String id;
  final String title;
  final LessonStatus status;

  const Lesson({required this.id, required this.title, required this.status});
}

enum LessonStatus { completed, current, locked }

// models/category.dart
enum CourseCategory {
  core('Core'),
  business('Business'),
  mind('Mind'),
  humanities('Humanities');

  const CourseCategory(this.displayName);
  final String displayName;
}
