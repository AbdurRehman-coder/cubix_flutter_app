import 'package:cubix_app/core/services/app_services.dart';
import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/explore/data/exposure_provider.dart';
import 'package:cubix_app/features/explore/presentation/widgets/w_course_details_shimmer.dart';
import 'package:cubix_app/features/explore/presentation/widgets/w_topic_item.dart';
import 'package:cubix_app/features/lessons/data/progress_services.dart';

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
                  decoration: BoxDecoration(
                    color: AppAssets.getCategoryColor(subject.category),
                  ),
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
                            AppAssets.getIconPath(subject.abbreviation),
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

                    bool needToGenerate =
                        subject
                            .sections[chapterIndex]
                            .topics
                            .first
                            .pages
                            ?.isEmpty ??
                        true;
                    final isLoading = ref.watch(
                      sectionLoadingProvider(chapter.sectionTitle),
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Chapter ${chapterIndex + 1}: ${chapter.sectionTitle}',
                                  style: AppTextStyles.bodyTextStyle.copyWith(
                                    fontSize: 18,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (needToGenerate)
                                isLoading
                                    ? Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: SizedBox(
                                        width: 27,
                                        height: 27,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 4.5,
                                          strokeCap: StrokeCap.round,
                                          backgroundColor: Color(0xfffFFDBBF),
                                          color: AppColors.primaryOrangeColor,
                                        ),
                                      ),
                                    )
                                    : IconButton(
                                      onPressed: () {
                                        createSectionAndRefresh(
                                          ref: ref,
                                          context: context,
                                          subjectId: subjectId,
                                          sectionTitle: chapter.sectionTitle,
                                        );
                                      },

                                      icon: SvgPicture.asset(
                                        'assets/icons/download_icon.svg',
                                      ),
                                    ),
                            ],
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
                                  needToGenerate: needToGenerate,
                                  showConnector: !(isLastTopic),
                                  onCompletion: () async {
                                    final success = await locator.get<ProgressServices>().createProgress(
                                      deviceId: "abcd1234",
                                      subjectId: "6890c1497e1f43eb1d09982c",
                                    );
                                  },
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
