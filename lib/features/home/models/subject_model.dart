class Subject {
  final String id;
  final String title;
  final String abbreviation;
  final String category;

  Subject({
    required this.id,
    required this.title,
    required this.abbreviation,
    required this.category,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['_id'],
      title: json['subject_title'],
      abbreviation: json['subject_abbreviation'],
      category: json['subject_category'],
    );
  }
}

class SubjectsData {
  final List<Subject> gen;
  final List<Subject> healLife;
  final List<Subject> psyHuman;
  final List<Subject> artsHuman;
  final List<Subject> busiEcon;

  SubjectsData({
    required this.gen,
    required this.healLife,
    required this.psyHuman,
    required this.artsHuman,
    required this.busiEcon,
  });

  factory SubjectsData.fromJson(Map<String, dynamic> json) {
    return SubjectsData(
      gen: (json['gen'] as List).map((e) => Subject.fromJson(e)).toList(),
      healLife:
          (json['heal_life'] as List).map((e) => Subject.fromJson(e)).toList(),
      psyHuman:
          (json['psy_human'] as List).map((e) => Subject.fromJson(e)).toList(),
      artsHuman:
          (json['arts_human'] as List).map((e) => Subject.fromJson(e)).toList(),
      busiEcon:
          (json['busi_econ'] as List).map((e) => Subject.fromJson(e)).toList(),
    );
  }
}
