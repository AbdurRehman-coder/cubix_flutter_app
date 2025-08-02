import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_custom_cube.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class BusinessSection extends StatelessWidget {
  const BusinessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': 'assets/icons/psychology.svg',
        'title': 'ECON 101',
        'subtitle': 'Microeconomics',
      },
      {
        'icon': 'assets/icons/literature.svg',
        'title': 'MKT 101',
        'subtitle': 'Marketing ',
      },
      {
        'icon': 'assets/icons/finance.svg',
        'title': 'ACC 101',
        'subtitle': 'Accounting I',
      },
      {
        'icon': 'assets/icons/tech.svg',
        'title': 'BUS 201',
        'subtitle': 'Business Law',
      },
    ];

    return SectionCard(
      title: 'Business & Econ',
      child: SizedBox(
        height: 130,
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 60,
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
