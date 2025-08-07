import 'dart:developer';

import 'package:cubix_app/features/explore/providers/exposure_provider.dart';
import 'package:cubix_app/features/home/models/subject_details_model.dart';
import 'package:cubix_app/features/lessons/models/progress_model.dart';
import 'package:cubix_app/features/lessons/provider/progress_provider.dart';
import 'package:cubix_app/core/utils/app_exports.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    final lessonProvider = ref.watch(progressProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: Text(
              'Lessons',
              style: AppTextStyles.headingTextStyle.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
                height: 22 / 30,
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(18)),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab('Ongoing', 0, selectedTab, ref),

                _buildTab('Completed', 1, selectedTab, ref),
              ],
            ),
          ),

          const SizedBox(height: 16),

          lessonProvider.when(
            loading: () => ExploreShimmer(),
            error:
                (error, _) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Text(
                      'Error loading the subjects',
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                  ),
                ),
            data: (progressList) {
              if (progressList == null || progressList.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You haven’t started any courses yet.",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 22,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),

                        Text(
                          "Let’s pick a course and get learning!",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 14,
                            color: AppColors.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: getProportionateScreenWidth(36),
                      mainAxisSpacing: getProportionateScreenHeight(24),
                    ),
                    itemCount: progressList.length,
                    itemBuilder: (context, index) {
                      final subjectDetailAsync = ref.watch(
                        subjectDetailProvider(progressList[index].subject),
                      );

                      return subjectDetailAsync.when(
                        loading: () => CourseCardShimmer(),
                        error: (err, _) => const Text("Failed to load"),
                        data: (subjectDetail) {
                          if (subjectDetail == null) {
                            return const Text("No data");
                          }

                          return _buildSubjectCard(
                            context,
                            progressList[index],
                            ref,
                            subjectDetail,
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int tabIndex, int selectedTab, WidgetRef ref) {
    final isSelected = selectedTab == tabIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(selectedTabProvider.notifier).state = tabIndex,
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                height: 1.5,
                color:
                    isSelected ? AppColors.blackColor : const Color(0xFF8E8E93),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? AppColors.primaryOrangeColor
                        : Color(0xFF8E8E93).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context,
    ProgressModel progress,
    WidgetRef ref,
    SubjectDetail subject,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsScreen(subjectId: subject.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.whiteColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Icon
            Container(
              width: double.infinity,
              height: getProportionateScreenHeight(96),
              decoration: BoxDecoration(
                color: AppAssets.getCategoryColor(subject.category),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Image.asset(
                  //'assets/images/brain_image.png',
                  AppAssets.getIconPath(subject.abbreviation),
                  fit: BoxFit.cover,
                  height: getProportionateScreenHeight(85),
                  width: getProportionateScreenHeight(85),
                ),
              ),
            ),

            SizedBox(height: 9),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.abbreviation,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subject.title,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 11,
                            color: AppColors.textSecondaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '${progress.sectionProgress.length} / ${progress.totalSections}',
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 11,
                            color: AppColors.textSecondaryColor,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value:
                            progress.totalSections > 0
                                ? progress.sectionProgress.length /
                                    progress.totalSections
                                : 0,
                        minHeight: 4,
                        backgroundColor: const Color(
                          0xFF8E8E93,
                        ).withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryOrangeColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
