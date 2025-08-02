import 'package:cubix_app/features/bottom_navbar/presentation/widgets/w_custom_navbar.dart';
import 'package:cubix_app/features/bottom_navbar/provider/navbar_provider.dart';
import 'package:cubix_app/features/explore/presentation/screens/ui_explore.dart';
import 'package:cubix_app/features/home/presentation/screens/ui_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static final _pages = [
    HomeScreen(),
    HomeScreen(),
    ExploreScreen(),
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
