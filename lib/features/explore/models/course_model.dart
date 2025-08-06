// Models
enum LessonStatus { completed, current, locked }

enum CourseCategory {
  core('gen', 'Core'),
  business('busi_econ', 'Business'),
  mind('psy_human', 'Mind'),
  humanities('arts_human', 'Humanities'),
  health('innovation', 'Innovation'),
  gen('heal_life', 'Health'); // ✅ New category added

  const CourseCategory(this.category, this.displayName);

  final String category;
  final String displayName;
}

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

  Course copyWith({
    String? id,
    String? title,
    String? code,
    String? icon,
    String? category,
    String? description,
    List<Chapter>? chapters,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      code: code ?? this.code,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      description: description ?? this.description,
      chapters: chapters ?? this.chapters,
    );
  }
}

class Chapter {
  final String id;
  final String title;
  final List<Lesson> lessons;

  const Chapter({required this.id, required this.title, required this.lessons});

  Chapter copyWith({String? id, String? title, List<Lesson>? lessons}) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      lessons: lessons ?? this.lessons,
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final LessonStatus status;

  const Lesson({required this.id, required this.title, required this.status});

  Lesson copyWith({String? id, String? title, LessonStatus? status}) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }
}
