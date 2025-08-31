import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/lessons/presentation/screens/ui_lesson_details.dart';

class AppRoutes {
  static const String splash = '/';
  static const String signIn = '/signin';
  static const String mainScreen = '/main';
  static const String courseDetails = '/courseDetails';
  static const String lessonDetails = '/lessonDetails';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case mainScreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case courseDetails:
        final subjectId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CourseDetailsScreen(subjectId: subjectId),
        );
      case lessonDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:
              (_) => LessonDetailsScreen(
                subjectTopic: args['subjectTopic'],
                onCompletion: args['onCompletion'],
              ),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text(
                    "No route defined",
                    style: AppTextStyles.bodyTextStyle,
                  ),
                ),
              ),
        );
    }
  }
}
