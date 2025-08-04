class SubjectDetail {
  final String id;
  final String title;
  final String abbreviation;
  final String category;
  final String overview;
  final List<SubjectSection> sections;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubjectDetail({
    required this.id,
    required this.title,
    required this.abbreviation,
    required this.category,
    required this.overview,
    required this.sections,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubjectDetail.fromJson(Map<String, dynamic> json) {
    return SubjectDetail(
      id: json['_id'],
      title: json['subject_title'],
      abbreviation: json['subject_abbreviation'],
      category: json['subject_category'],
      overview: json['subject_overview'],
      sections: (json['subject_sections'] as List)
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

  SubjectSection({
    required this.sectionTitle,
    required this.topics,
  });

  factory SubjectSection.fromJson(Map<String, dynamic> json) {
    return SubjectSection(
      sectionTitle: json['section_title'],
      topics: (json['topics'] as List)
          .map((e) => SubjectTopic.fromJson(e))
          .toList(),
    );
  }
}

class SubjectTopic {
  final String topicTitle;
  final List<SubjectPage>? pages;

  SubjectTopic({
    required this.topicTitle,
    this.pages,
  });

  factory SubjectTopic.fromJson(Map<String, dynamic> json) {
    return SubjectTopic(
      topicTitle: json['topic_title'],
      pages: json['pages'] != null
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

  SubjectPage({
    required this.pageTitle,
    required this.pageData,
  });

  factory SubjectPage.fromJson(Map<String, dynamic> json) {
    return SubjectPage(
      pageTitle: json['page_title'],
      pageData: json['page_data'],
    );
  }
}
