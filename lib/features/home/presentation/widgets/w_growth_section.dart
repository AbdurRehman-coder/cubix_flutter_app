import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class GrowthSection extends StatelessWidget {
  final List<Subject> subjects;
  const GrowthSection({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Growth',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate((subjects.length / 2).ceil(), (colIndex) {
            final firstItem = subjects[colIndex * 2];
            final secondItem =
                (colIndex * 2 + 1 < subjects.length)
                    ? subjects[colIndex * 2 + 1]
                    : null;
            return SizedBox(
              width: getProportionateScreenWidth(230),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildItem(firstItem, context),
                  if (secondItem != null) ...[
                    SizedBox(height: getProportionateScreenHeight(15)),
                    _buildItem(secondItem, context),
                  ],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildItem(Subject item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator.get<AnalyticServices>().logSubjectView(
          subjectTitle: item.title,
          subjectCategory: item.category,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsScreen(subjectId: item.id),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.getIconPath(item.abbreviation),
            height: 55,
            width: 55,
          ),
          SizedBox(width: getProportionateScreenWidth(12)),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.abbreviation,
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
                  item.title,
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
      ),
    );
  }
}
