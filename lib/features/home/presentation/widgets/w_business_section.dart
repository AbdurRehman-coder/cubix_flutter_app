import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_custom_cube.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class BusinessSection extends StatelessWidget {
  const BusinessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'ECON 101', 'subtitle': 'Microeconomics'},
      {'title': 'MKT 101', 'subtitle': 'Marketing '},
      {'title': 'ACC 101', 'subtitle': 'Accounting I'},
      {'title': 'BUS 201', 'subtitle': 'Business Law'},
    ];

    return SectionCard(
      title: 'Business & Econ',
      child: SizedBox(
        height: getProportionateScreenHeight(130),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate((items.length / 2).ceil(), (colIndex) {
              final firstItem = items[colIndex * 2];
              final secondItem =
                  (colIndex * 2 + 1 < items.length)
                      ? items[colIndex * 2 + 1]
                      : null;
              return SizedBox(
                width: 237,
                child: Column(
                  children: [
                    _buildItem(firstItem),
                    if (secondItem != null)
                      SizedBox(height: getProportionateScreenHeight(15)),
                    if (secondItem != null) _buildItem(secondItem),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(Map<String, String> item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/brain_image.png', height: 55, width: 55),
        SizedBox(width: getProportionateScreenWidth(18)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title']!,
                maxLines: 1,
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
  }
}
