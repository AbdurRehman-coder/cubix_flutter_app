import 'core/utils/app_exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  AppUtils.initFirebaseCrashlytics(true);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  await dotenv.load(fileName: ".env");
  await initServices();

  runApp(const ProviderScope(child: MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAndroid14OrAbove = false;

  @override
  void initState() {
    super.initState();
    _checkAndroidVersion();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveConfig().init(context);
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: isAndroid14OrAbove,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
        theme: AppTheme.lightTheme,
        title: 'Cubix App',
        home: SplashScreen(),
      ),
    );
  }

  Future<void> _checkAndroidVersion() async {
    bool status = await AppUtils.checkAndroidVersion();
    WidgetsBinding.instance.addPostFrameCallback((v){
      setState(() {
        isAndroid14OrAbove = status;
      });
    });
  }
}
