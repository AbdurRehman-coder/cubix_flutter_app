import 'package:cubix_app/core/utils/app_exports.dart';

class CustomBottomNavBar extends ConsumerWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final notifier = ref.read(bottomNavIndexProvider.notifier);

    List<_NavItem> navItems = const [
      _NavItem(icon: AppAssets.homeIcon, label: 'Home'),
      _NavItem(icon: AppAssets.lessonsIcon, label: 'Lessons'),
      _NavItem(icon: AppAssets.exploreIcon, label: 'Explore'),
      _NavItem(icon: AppAssets.settingsIcon, label: 'Settings'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        border: Border(top: BorderSide(color: AppColors.whiteColor, width: 1)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final item = navItems[index];
          final isSelected = index == currentIndex;
          return Expanded(
            child: InkWell(
              onTap: () => notifier.state = index,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    item.icon,
                    height: getProportionateScreenHeight(24),
                    colorFilter: ColorFilter.mode(
                      isSelected
                          ? AppColors.primaryOrangeColor
                          : AppColors.greyColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 12,
                      color:
                          isSelected
                              ? AppColors.blackColor
                              : AppColors.greyColor,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
