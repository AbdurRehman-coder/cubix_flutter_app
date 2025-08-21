import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class BooksSection extends StatelessWidget {
  final List<Subject> subjects;
  const BooksSection({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Books',
      child: SizedBox(
        height: getProportionateScreenHeight(160),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 0),
              child: GestureDetector(
                onTap: () {
                  locator.get<AnalyticServices>().logSubjectView(
                    subjectTitle: subjects[index].title,
                    subjectCategory: subjects[index].category,
                  );
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          AppAssets.bookIcon,
                          height: getProportionateScreenHeight(140),
                        ),
                        Positioned(
                          left: getProportionateScreenWidth(10),
                          right: 0,
                          top: getProportionateScreenHeight(40),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: getProportionateScreenWidth(80),
                                child: Text(
                                  subjects[index].title,
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodyTextStyle.copyWith(
                                    fontSize: 12,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Text(
                        subjects[index].abbreviation,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 11,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w400,
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
