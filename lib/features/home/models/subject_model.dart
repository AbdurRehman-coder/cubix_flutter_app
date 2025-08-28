class Subject {
  final String id;
  final String title;
  final String abbreviation;
  final String category;
  final String? userCategory; // optional
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Subject({
    required this.id,
    required this.title,
    required this.abbreviation,
    required this.category,
    this.userCategory,
    this.createdAt,
    this.updatedAt,
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
      createdAt:
          json.containsKey('createdAt')
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json.containsKey('updatedAt')
              ? DateTime.tryParse(json['updatedAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'subject_title': title,
      'subject_abbreviation': abbreviation,
      'subject_category': category,
      'subject_user_category': userCategory,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class SubjectsData {
  final List<Subject> curiosity;
  final List<Subject> creativity;
  final List<Subject> careers;
  final List<Subject> books;
  final List<Subject> growth;

  SubjectsData({
    required this.curiosity,
    required this.creativity,
    required this.careers,
    required this.books,
    required this.growth,
  });

  factory SubjectsData.fromJson(Map<String, dynamic> json) {
    List<Subject> parseAndSort(String key) {
      if (!json.containsKey(key)) return [];
      final list =
          (json[key] as List<dynamic>).map((e) => Subject.fromJson(e)).toList();

      // Sort latest first (nulls go last)
      list.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      return list;
    }

    return SubjectsData(
      curiosity: parseAndSort('curiosity'),
      creativity: parseAndSort('creativity'),
      careers: parseAndSort('careers'),
      books: parseAndSort('book'),
      growth: parseAndSort('growth'),
    );
  }
}
