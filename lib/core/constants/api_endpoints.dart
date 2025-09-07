// core/services/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = "https://api.example.com";

  // Auth
  static const String loginWithGoogle = "/auth/sign-in/google";
  static const String loginWithApple = "/auth/sign-in/apple";
  static const String refreshToken = "/auth/refresh";
  static const String users = "/users";
  static const String reactivateAccount = "/users/re-activate";

  // Subjects
  static const String subjects = "/subjects";
  static String subjectDetail(String subjectId) => "/subjects/$subjectId";
  static const String subjectSections = "/subjects/section";
  static const String feedbacks = "/feedbacks";

  // Progress
  static const String progress = "/progress";
  static String progressDetail(String progressId) => "/progress/$progressId";

  // Profile
  static const String profile = "$baseUrl/user/profile";

  // Chat
  static const String assistant = "/assistant";
  static const String assistantSubject = '/assistant/subject';

  static String getAssistantSubject(String subjectId) =>
      "/assistant/subject/$subjectId";
}
