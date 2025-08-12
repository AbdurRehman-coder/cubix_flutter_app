import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class HealthScienceSection extends StatelessWidget {
  final List<Subject> subjects;
  const HealthScienceSection({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Health & Life Science',
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CourseDetailsScreen(
                            subjectId: subjects[index].id,
                          ),
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.bookIcon,
                      height: getProportionateScreenHeight(120),
                    ),
                    Positioned(
                      left: getProportionateScreenWidth(10),
                      right: 0,
                      top: getProportionateScreenHeight(16),
                      bottom: getProportionateScreenHeight(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            subjects[index].title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyTextStyle.copyWith(
                              fontSize: 14,
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Image.asset(
                            AppAssets.getIconPath(subjects[index].abbreviation),

                            height: getProportionateScreenHeight(35),
                          ),
                        ],
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
