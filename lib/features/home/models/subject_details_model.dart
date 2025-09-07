class SubjectDetail {
  final String id;
  final String title;
  final String abbreviation;
  final String? category; // optional now
  final String overview;
  final String? tone; // optional (for assistant subjects)
  final List<String>? tags; // optional (for assistant subjects)
  final List<SubjectSection> sections;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubjectDetail({
    required this.id,
    required this.title,
    required this.abbreviation,
    this.category,
    required this.overview,
    this.tone,
    this.tags,
    required this.sections,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubjectDetail.fromJson(Map<String, dynamic> json) {
    return SubjectDetail(
      id: json['_id'],
      title: json['subject_title'],
      abbreviation: json['subject_abbreviation'],
      category: json['subject_category'], // may be null
      overview: json['subject_overview'],
      tone: json['subject_tone'], // may be null
      tags:
          json['subject_tags'] != null
              ? List<String>.from(json['subject_tags'])
              : null,
      sections:
          (json['subject_sections'] as List)
              .map((e) => SubjectSection.fromJson(e))
              .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class SubjectSection {
  final String sectionTitle;
  final List<SubjectTopic> topics;

  SubjectSection({required this.sectionTitle, required this.topics});

  factory SubjectSection.fromJson(Map<String, dynamic> json) {
    return SubjectSection(
      sectionTitle: json['section_title'],
      topics:
          (json['topics'] as List)
              .map((e) => SubjectTopic.fromJson(e))
              .toList(),
    );
  }
}

class SubjectTopic {
  final String topicTitle;
  final List<SubjectPage>? pages;

  SubjectTopic({required this.topicTitle, this.pages});

  factory SubjectTopic.fromJson(Map<String, dynamic> json) {
    return SubjectTopic(
      topicTitle: json['topic_title'],
      pages:
          json['pages'] != null
              ? (json['pages'] as List)
                  .map((e) => SubjectPage.fromJson(e))
                  .toList()
              : null,
    );
  }
}

class SubjectPage {
  final String pageTitle;
  final String pageData;
  final String? pageDiagram;

  SubjectPage({
    required this.pageTitle,
    required this.pageData,
    this.pageDiagram,
  });

  factory SubjectPage.fromJson(Map<String, dynamic> json) {
    return SubjectPage(
      pageTitle: json['page_title'],
      pageData: json['page_data'],
      pageDiagram: json['page_diagram'],
    );
  }
}
