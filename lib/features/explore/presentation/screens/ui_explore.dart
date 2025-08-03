import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/explore/models/course_model.dart';
import 'package:cubix_app/features/explore/presentation/screens/ui_course_details.dart';
import 'package:cubix_app/features/explore/presentation/widgets/w_course_card.dart';
import 'package:cubix_app/features/explore/presentation/widgets/w_course_tab.dart';
import 'package:cubix_app/features/explore/providers/course_provider.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider);
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

          // Category tabs
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

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: getProportionateScreenWidth(16),
                  mainAxisSpacing: getProportionateScreenHeight(30),
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  CourseDetailsScreen(course: courses[index]),
                        ),
                      );
                    },
                    child: CourseCard(course: courses[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
