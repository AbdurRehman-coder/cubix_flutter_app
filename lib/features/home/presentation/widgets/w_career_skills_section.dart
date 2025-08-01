import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class CareerSkillsSection extends StatelessWidget {
  const CareerSkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Career Communication', 'sections': '4 Sections'},
      {'title': 'Leadership', 'sections': '4 Sections'},
      {'title': 'Leadership', 'sections': '4 Sections'},
      {'title': 'Leadership', 'sections': '4 Sections'},
    ];

    return SectionCard(
      title: 'Career Skills',
      child: SizedBox(
        height: 80,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 7, 16),
              width: 178,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F0FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['sections']!,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    width: 20,
                    height: 20,
                    child: IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        iconSize: 12,
                        backgroundColor: AppColors.whiteColor,
                      ),
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
