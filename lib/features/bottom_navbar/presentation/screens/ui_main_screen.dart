import 'package:cubix_app/features/bottom_navbar/presentation/widgets/w_custom_navbar.dart';
import 'package:cubix_app/features/bottom_navbar/provider/navbar_provider.dart';
import 'package:cubix_app/features/explore/presentation/screens/ui_explore.dart';
import 'package:cubix_app/features/home/presentation/screens/ui_home.dart';
import 'package:cubix_app/features/lessons/presentation/screens/ui_lessons.dart';
import 'package:cubix_app/features/settings/presentation/screens/ui_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/w_custom_dialog.dart';

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
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  void showWelcomeDialog(BuildContext context) {
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
