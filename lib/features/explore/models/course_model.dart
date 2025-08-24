enum CourseCategory {
  creativity('creativity', 'Creativity'),
  growth('growth', 'Growth '),
  careers('careers', 'Careers '),
  curiosity('curiosity', 'Curiosity'),
  book('book', 'Books');

  const CourseCategory(this.category, this.displayName);

  final String category;
  final String displayName;
}

CourseCategory getCategoryFromTitle(String title) {
  switch (title.trim().toLowerCase()) {
    case 'creativity':
      return CourseCategory.creativity;
    case 'curiosity':
      return CourseCategory.curiosity;
    case 'books':
      return CourseCategory.book;
    case 'careers':
      return CourseCategory.careers;
    case 'growth':
      return CourseCategory.growth;
    default:
      return CourseCategory.creativity;
  }
}
