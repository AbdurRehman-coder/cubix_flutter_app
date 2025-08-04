import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/explore/presentation/widgets/w_course_details_shimmer.dart';
import 'package:cubix_app/features/explore/presentation/widgets/w_topic_item.dart';

class CourseDetailsScreen extends ConsumerWidget {
  final String subjectId;

  const CourseDetailsScreen({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectDetailAsync = ref.watch(subjectDetailProvider(subjectId));
    return Scaffold(
      body: subjectDetailAsync.when(
        loading: () => CourseDetailsShimmer(),
        error:
            (error, _) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Text(
                  'Error loading the details',
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
              ),
            ),
        data: (subject) {
          if (subject == null) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Text(
                  "No details found.",
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xFFC5E3D3)),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 12, 24, 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.close_sharp,
                                size: 30,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/brain_image.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 21,
                    horizontal: 17,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.abbreviation,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 11,
                          color: AppColors.greyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      Text(
                        subject.title,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 18,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Text(
                        subject.overview,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 14,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: const Color(0xffE3E3E4),
                  ),
                ),
                // Lessons content
                ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 29,
                  ),
                  itemCount: subject.sections.length,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 72),
                  itemBuilder: (context, chapterIndex) {
                    final chapter = subject.sections[chapterIndex];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Chapter ${chapterIndex + 1}: ${chapter.sectionTitle}',
                            style: AppTextStyles.bodyTextStyle.copyWith(
                              fontSize: 18,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        Column(
                          children:
                              chapter.topics.asMap().entries.map((entry) {
                                final topicIndex = entry.key;
                                final topic = entry.value;
                                final isLastTopic =
                                    topicIndex == chapter.topics.length - 1;
                                return TopicItem(
                                  topic: topic,
                                  showConnector: !(isLastTopic),
                                );
                              }).toList(),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
