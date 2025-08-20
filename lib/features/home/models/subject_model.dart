class Subject {
  final String id;
  final String title;
  final String abbreviation;
  final String category;
  final String? userCategory; // optional

  Subject({
    required this.id,
    required this.title,
    required this.abbreviation,
    required this.category,
    this.userCategory,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json.containsKey('_id') ? json['_id'] as String : '',
      title:
          json.containsKey('subject_title')
              ? json['subject_title'] as String
              : '',
      abbreviation:
          json.containsKey('subject_abbreviation')
              ? json['subject_abbreviation'] as String
              : '',
      category:
          json.containsKey('subject_category')
              ? json['subject_category'] as String
              : '',
      userCategory:
          json.containsKey('subject_user_category')
              ? json['subject_user_category'] as String
              : null,
    );
  }
}

class SubjectsData {
  final List<Subject> curiosity;
  final List<Subject> creativity;
  final List<Subject> career;
  final List<Subject> books;
  final List<Subject> growth;

  SubjectsData({
    required this.curiosity,
    required this.creativity,
    required this.career,
    required this.books,
    required this.growth,
  });

  factory SubjectsData.fromJson(Map<String, dynamic> json) {
    return SubjectsData(
      curiosity:
          json.containsKey('curiosity')
              ? (json['curiosity'] as List<dynamic>)
                  .map((e) => Subject.fromJson(e))
                  .toList()
              : [],
      creativity:
          json.containsKey('creativity')
              ? (json['creativity'] as List<dynamic>)
                  .map((e) => Subject.fromJson(e))
                  .toList()
              : [],
      career:
          json.containsKey('career')
              ? (json['career'] as List<dynamic>)
                  .map((e) => Subject.fromJson(e))
                  .toList()
              : [],
      books:
          json.containsKey('book')
              ? (json['book'] as List<dynamic>)
                  .map((e) => Subject.fromJson(e))
                  .toList()
              : [],
      growth:
          json.containsKey('growth')
              ? (json['growth'] as List<dynamic>)
                  .map((e) => Subject.fromJson(e))
                  .toList()
              : [],
    );
  }
}
