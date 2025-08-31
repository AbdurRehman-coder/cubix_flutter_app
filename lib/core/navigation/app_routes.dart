import 'package:cubix_app/features/auth/presentation/screens/ui_signin.dart';
import 'package:cubix_app/features/bottom_navbar/presentation/screens/ui_main_screen.dart';
import 'package:cubix_app/features/explore/presentation/screens/ui_course_details.dart';
import 'package:cubix_app/features/lessons/presentation/screens/ui_lesson_details.dart';
import 'package:cubix_app/features/splash/presentation/screens/ui_splash.dart';
import 'package:flutter/material.dart';

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
              (_) =>
                  const Scaffold(body: Center(child: Text("No route defined"))),
        );
    }
  }
}
