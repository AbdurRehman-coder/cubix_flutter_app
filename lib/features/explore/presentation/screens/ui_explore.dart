import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/explore/presentation/screens/ui_course_details.dart';
import 'package:cubix_app/features/explore/presentation/widgets/w_explore_shimmer.dart';

import '../../../../core/widgets/w_custom_message.dart' show MessageWidget;

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final subjectsAsync = ref.watch(subjectsProvider);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: Text(
              'Explore',
              style: AppTextStyles.headingTextStyle.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
                height: 22 / 30,
              ),
            ),
          ),

          Divider(height: 1, thickness: 1, color: Color(0xffE3E3E4)),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 27),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    CourseCategory.values
                        .map(
                          (category) => Padding(
                            padding: EdgeInsets.only(
                              right: getProportionateScreenWidth(10),
                            ),
                            child: CategoryTab(category: category),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),

          subjectsAsync.when(
            loading: () => ExploreShimmer(),
            error:
                (error, _) => MessageWidget(
                  title: 'Something went wrong!',
                  subtitle: 'There is something wrong with the server or your request is invalid.',
                ),
            data: (subjects) {
              if (subjects == null) {
                return Center(
                  child: Text(
                    "No subjects found.",
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.textSecondaryColor,
                    ),
                  ),
                );
              }

              List<Subject> tempList = getSubjectsForCategory(
                selectedCategory,
                subjects,
              );

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: getProportionateScreenWidth(16),
                      mainAxisSpacing: getProportionateScreenHeight(30),
                    ),
                    itemCount: tempList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CourseDetailsScreen(
                                    subjectId: tempList[index].id,
                                  ),
                            ),
                          );
                        },
                        child: CourseCard(subject: tempList[index]),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Subject> getSubjectsForCategory(
    CourseCategory category,
    SubjectsData subjects,
  ) {
    switch (category) {
      case CourseCategory.core:
        return subjects.gen;
      case CourseCategory.business:
        return subjects.busiEcon;
      case CourseCategory.mind:
        return subjects.psyHuman;
      case CourseCategory.humanities:
        return subjects.artsHuman;
      case CourseCategory.health:
        return subjects.innovation;
      case CourseCategory.gen:
        return subjects.healLife;
    }
  }
}
