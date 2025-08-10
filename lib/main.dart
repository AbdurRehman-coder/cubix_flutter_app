import 'package:cubix_app/core/services/app_services.dart';
import 'package:cubix_app/google_login.dart';
import 'package:flutter/services.dart';
import 'core/utils/app_exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  await initServices();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveConfig().init(context);
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        title: 'Cubix App',
        home: const SignInDemo(),
      ),
    );
  }
}
