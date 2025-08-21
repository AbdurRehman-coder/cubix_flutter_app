import 'package:cubix_app/core/utils/app_exports.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final ScrollController _categoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedCategory = ref.read(selectedCategoryProvider);
      final index = CourseCategory.values.indexOf(selectedCategory);

      if (index != -1) {
        _categoryScrollController.animateTo(
          index * getProportionateScreenWidth(60),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  final analytics = locator<AnalyticServices>();

  @override
  Widget build(BuildContext context) {
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
              controller: _categoryScrollController,
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
                  subtitle:
                      'There is something wrong with the server or your request is invalid.',
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: getProportionateScreenWidth(16),
                      mainAxisSpacing: getProportionateScreenHeight(30),
                    ),
                    itemCount: tempList.length,
                    itemBuilder: (context, index) {
                      bool isLastRow = index >= (tempList.length - 2);

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              isLastRow ? getProportionateScreenHeight(10) : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            analytics.logSubjectView(
                              subjectTitle: tempList[index].title,
                              subjectCategory: tempList[index].category,
                            );
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
                        ),
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
      case CourseCategory.creativity:
        return subjects.creativity;
      case CourseCategory.curiosity:
        return subjects.curiosity;
      case CourseCategory.book:
        return subjects.books;
      case CourseCategory.careers:
        return subjects.careers;
      case CourseCategory.growth:
        return subjects.growth;
    }
  }
}
