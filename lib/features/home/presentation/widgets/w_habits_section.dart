import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_custom_cube.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class HabitsSection extends StatelessWidget {
  const HabitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Habit Mastery', 'icon': 'assets/icons/habit.svg'},
      {'title': 'Daily Routines', 'icon': 'assets/icons/routine.svg'},
      {'title': 'Better Habits', 'icon': 'assets/icons/better.svg'},
      {'title': 'Life Systems', 'icon': 'assets/icons/life.svg'},
      {'title': 'Personal Systems', 'icon': 'assets/icons/personal.svg'},
    ];

    return SectionCard(
      title: 'Master Your Habits',
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            items.map((item) {
              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Cube3D(
                      size: 36,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFE7101), Color(0xFFFFB880)],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title']!,
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
