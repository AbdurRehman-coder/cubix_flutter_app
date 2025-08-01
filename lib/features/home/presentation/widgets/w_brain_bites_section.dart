import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_custom_cube.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class BrainBitesSection extends StatelessWidget {
  const BrainBitesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': 'assets/icons/psychology.svg',
        'title': 'Psychology',
        'subtitle': 'Personality Types\n(MBTI, Enneagram)',
      },
      {
        'icon': 'assets/icons/literature.svg',
        'title': 'Literature',
        'subtitle': 'Poetry Basics',
      },
      {
        'icon': 'assets/icons/finance.svg',
        'title': 'Everyday Life Skills',
        'subtitle': 'Budgeting & Saving',
      },
      {
        'icon': 'assets/icons/tech.svg',
        'title': 'Technology',
        'subtitle': 'Artificial Intelligence',
      },
    ];

    return SectionCard(
      title: 'Brain Bites',
      child: SizedBox(
        height: 130,
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 16,
          childAspectRatio: 2.8,
          physics: const NeverScrollableScrollPhysics(),
          children:
              items.map((item) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Cube3D(
                      size: 36,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF199051), Color(0xFF8CC7A8)],
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(20)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            item['title']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyTextStyle.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondaryColor,
                              height: 18 / 11,
                            ),
                          ),
                          Text(
                            item['subtitle']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackColor,
                              height: 18 / 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
