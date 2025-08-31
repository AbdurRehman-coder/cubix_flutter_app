import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/ai_chatbot/presentation/screens/ui_chatbot.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      showWelcomeDialog(context);
    });
  }

  static final _pages = [
    HomeScreen(),
    LessonsScreen(),
    ExploreScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    return Scaffold(
      body: _pages[currentIndex],
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: AppColors.primaryOrangeColor,
        child: Icon(Icons.message_outlined, color: AppColors.whiteColor),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatBotScreen()),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Future<void> showWelcomeDialog(BuildContext context) async {
    final isFirstTime =
        await locator.get<SharedPrefServices>().isFirstTimeUser();
    if (isFirstTime && context.mounted) {
      showDialog(
        context: context,
        builder:
            (_) => CustomDialog(
              title: '🎉 Welcome to Cubix 🎉',
              description:
                  'You’re one of the first to try our\nearly version — totally free while\nwe build.',
              buttonText: 'Let\'s Go',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
      );
    }
  }
}
