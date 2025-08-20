import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticServices {
  late final FirebaseAnalytics _analytics;

  AnalyticServices() {
    _analytics = FirebaseAnalytics.instance;
  }

  FirebaseAnalyticsObserver getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  Future<void> logSubjectView({
    required String subjectTitle,
    required String subjectCategory,

  }) async {
    await _analytics.logEvent(
      name: 'subject_view',
      parameters: {
        'subject_title': subjectTitle,
        'subject_category': subjectTitle,
      },
    );
  }



  Future<void> logSubjectDownloaded({
    required String sectionTitle,
    required String subjectId,

  }) async {
    await _analytics.logEvent(
      name: 'subject_view',
      parameters: {
        'section_title': sectionTitle,
        'subject_id': subjectId,
      },
    );
  }

  Future<void> logLessonStarted({
    required String sectionTitle,
    required String lessonTitle,
    String? category,
  }) async {
    await _analytics.logEvent(
      name: 'lesson_started',
      parameters: {
        'lesson_id': sectionTitle,
        'lesson_title': lessonTitle,
      },
    );
  }

  Future<void> logLessonCompleted({
    required String sectionTitle,
    required String lessonTitle,

  }) async {
    await _analytics.logEvent(
      name: 'lesson_completed',
      parameters: {
        'lesson_id': sectionTitle,
        'lesson_title': lessonTitle,
      },
    );
  }

  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }
}
