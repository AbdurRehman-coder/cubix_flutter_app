import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class ArtsHumanitiesSection extends StatelessWidget {
  final List<Subject> subjects;
  const ArtsHumanitiesSection({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Arts & Humanities',
      child: SizedBox(
        height: getProportionateScreenHeight(100),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: subjects.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final item = subjects[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CourseDetailsScreen(subjectId: item.id),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: 123,
                    height: 100,
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
                      item.title,
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
                    child: SvgPicture.asset(AppAssets.maskCurve, height: 93),
                  ),
                  Positioned(
                    top: 8,
                    right: 14,
                    child: Image.asset(
                      AppAssets.getIconPath(item.abbreviation),

                      height: 40,
                      width: 40,
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
