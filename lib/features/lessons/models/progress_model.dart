class ProgressModel {
  final String id;
  final SubjectModel subject;
  final List<String> sectionProgress;
  final List<String> topicProgress;
  final int totalSections;
  final String user;
  final String subjectModel;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProgressModel({
    required this.id,
    required this.subject,
    required this.sectionProgress,
    required this.topicProgress,
    required this.totalSections,
    required this.user,
    required this.subjectModel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      id: json['_id'],
      subject: SubjectModel.fromJson(json['subject']),
      sectionProgress: List<String>.from(json['section_progress'] ?? []),
      topicProgress: List<String>.from(json['topic_progress'] ?? []),
      totalSections: json['total_sections'] ?? 0,
      user: json['user'] ?? '',
      subjectModel: json['subject_model'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class SubjectModel {
  final String id;
  final String subjectTitle;
  final String subjectAbbreviation;
  final String subjectCategory;

  SubjectModel({
    required this.id,
    required this.subjectTitle,
    required this.subjectAbbreviation,
    required this.subjectCategory,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['_id'],
      subjectTitle: json['subject_title'] ?? '',
      subjectAbbreviation: json['subject_abbreviation'] ?? '',
      subjectCategory: json['subject_category'] ?? '',
    );
  }
}

// class ProgressModel {
//   final String id;
//   final String subject;
//   final List<String> sectionProgress;
//   final List<String> topicProgress;
//   final int totalSections;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   ProgressModel({
//     required this.id,
//     required this.subject,
//     required this.sectionProgress,
//     required this.topicProgress,
//     required this.totalSections,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory ProgressModel.fromJson(Map<String, dynamic> json) {
//     return ProgressModel(
//       id: json['_id'],
//       subject: json['subject'] ?? '',
//       sectionProgress: List<String>.from(json['section_progress']),
//       topicProgress: List<String>.from(json['topic_progress']),
//       totalSections: json['total_sections'] ?? 0,
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }
// }
