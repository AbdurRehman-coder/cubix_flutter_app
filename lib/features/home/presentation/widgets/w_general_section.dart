import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_custom_cube.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class GeneralEducationSection extends StatelessWidget {
  const GeneralEducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'ENG 101'},
      {'title': 'COM 101'},
      {'title': 'LIT 101'},
      {'title': 'HIST 101'},
      {'title': 'PHIL 101'},
    ];

    return SectionCard(
      title: 'General Education',
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            items.map((item) {
              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/english_image.png',
                      height: 45,
                      width: 45,
                    ),
                    const SizedBox(height: 8),
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
