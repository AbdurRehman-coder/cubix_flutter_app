class ProgressModel {
  final String id;
  final String subject;
  final List<String> sectionProgress;
  final List<String> topicProgress;
  final int totalSections;
  final String deviceId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProgressModel({
    required this.id,
    required this.subject,
    required this.sectionProgress,
    required this.topicProgress,
    required this.totalSections,
    required this.deviceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      id: json['_id'],
      subject: json['subject'] ?? '',
      sectionProgress: List<String>.from(json['section_progress']),
      topicProgress: List<String>.from(json['topic_progress']),
      totalSections: json['total_sections'] ?? 0,
      deviceId: json['device_id'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
