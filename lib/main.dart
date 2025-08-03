import 'package:flutter/services.dart';
import 'core/utils/app_exports.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
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
        home: const SplashScreen(),
      ),
    );
  }
}
