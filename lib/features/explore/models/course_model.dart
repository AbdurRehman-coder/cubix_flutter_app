// Models
enum LessonStatus { completed, current, locked }

enum CourseCategory {
  core('gen', 'Core'),
  business('busi_econ', 'Business'),
  mind('psy_human', 'Mind'),
  humanities('arts_human', 'Humanities'),
  health('innovation', 'Innovation'),
  gen('heal_life', 'Health');

  const CourseCategory(this.category, this.displayName);

  final String category;
  final String displayName;
}

CourseCategory getCategoryFromTitle(String title) {
  switch (title.trim().toLowerCase()) {
    case 'general education':
      return CourseCategory.core;
    case 'business & econ':
    case 'business & economics':
      return CourseCategory.business;
    case 'psychology & behavior':
      return CourseCategory.mind;
    case 'arts & humanities':
      return CourseCategory.humanities;
    case 'health & life science':
    case 'health and life sciences':
      return CourseCategory.health;
    default:
      return CourseCategory.core;
  }
}
