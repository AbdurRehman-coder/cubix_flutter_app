import 'package:cubix_app/core/theming/app_colors.dart';
import 'package:cubix_app/core/utils/text_styles.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';
import 'package:flutter/material.dart';

class SelfInsightSection extends StatelessWidget {
  const SelfInsightSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Emotional\nIntelligence'},
      {'title': 'Self-Confidence'},
      {'title': 'Biology'},
    ];

    return SectionCard(
      title: 'Self Insight',
      child: SizedBox(
        height: 88,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.yellow[100],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //SvgPicture.asset(item['icon']!, height: 20),
                  const SizedBox(height: 26),
                  Text(
                    item['title']!,
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.bold,
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
