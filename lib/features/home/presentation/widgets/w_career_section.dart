import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class CareerSection extends StatelessWidget {
  final List<Subject> subjects;
  const CareerSection({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Careers',
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
                locator.get<AnalyticServices>().logSubjectView(
                  subjectTitle: item.title,
                  subjectCategory: item.category,
                );
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
                      color: const Color(0xFFE6F0FE),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 15,
                    ),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        color: AppColors.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 14,
                    child: SvgPicture.asset(
                      AppAssets.getIconPath(item.abbreviation, item.category),
                      height: 45,
                      width: 40,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      // Career section
    );
  }
}
