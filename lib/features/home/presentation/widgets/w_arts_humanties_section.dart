import 'package:cubix_app/core/theming/app_colors.dart';
import 'package:cubix_app/core/utils/text_styles.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ArtsHumanitiesSection extends StatelessWidget {
  const ArtsHumanitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Music Appreciation'},
      {'title': 'Art History'},
      {'title': 'Film Studies'},
    ];

    return SectionCard(
      title: 'Arts & Humanities',
      child: SizedBox(
        height: 98,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return Stack(
              children: [
                Container(
                  width: 123,
                  height: 93,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFFFFF5CB),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 15,
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    item['title']!,
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/icons/mask_curve.svg',
                    height: 93,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 14,
                  child: Image.asset(
                    'assets/images/award_image.png',
                    height: 40,
                    width: 40,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
