import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class GeneralEducationSection extends StatelessWidget {
  final List<Subject> subjects;
  const GeneralEducationSection({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'General Education',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              subjects.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  CourseDetailsScreen(subjectId: item.id),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppAssets.getIconPath(item.abbreviation),
                          height: 45,
                          width: 45,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.abbreviation,
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackColor,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
