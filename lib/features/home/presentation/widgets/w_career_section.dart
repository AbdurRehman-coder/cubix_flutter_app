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
        height: 80,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: subjects.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
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
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 7, 16),
                width: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F0FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 2,
                            style: AppTextStyles.bodyTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.abbreviation,
                            style: AppTextStyles.bodyTextStyle.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
