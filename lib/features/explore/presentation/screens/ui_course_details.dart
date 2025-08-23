import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:collection/collection.dart';
import 'package:cubix_app/core/utils/text_formatter.dart';
import 'package:cubix_app/features/explore/presentation/widgets/w_downloading_widget.dart';

class CourseDetailsScreen extends ConsumerWidget {
  final String subjectId;

  CourseDetailsScreen({super.key, required this.subjectId});

  final analytics = locator<AnalyticServices>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectDetailAsync = ref.watch(subjectDetailProvider(subjectId));

    return Scaffold(
      body: subjectDetailAsync.when(
        loading: () => CourseDetailsShimmer(),
        error:
            (error, _) => MessageWidget(
              title: 'Something went wrong!',
              subtitle:
                  'There is something wrong with the server or your request is invalid.',
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
                    color: AppColors.getCategoryColor(subject.category),
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
                          SvgPicture.asset(
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

                      RichText(
                        text: TextFormatter.formatText(
                          subject.overview,
                          AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 15,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
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
                      (context, index) => const SizedBox(height: 30),
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
                    final isLoading = ref
                        .watch(downloadManagerProvider)
                        .contains("$subjectId|${chapter.sectionTitle}");

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            SizedBox(width: 12),
                            if (needToGenerate)
                              isLoading
                                  ? Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: DownloadingWidget(),
                                  )
                                  : IconButton(
                                    onPressed: () {
                                      analytics.logSubjectDownloadStart(
                                        sectionTitle: chapter.sectionTitle,
                                        subjectId: subjectId,
                                      );

                                      ref
                                          .read(
                                            downloadManagerProvider.notifier,
                                          )
                                          .start(
                                            subjectId,
                                            chapter.sectionTitle,
                                          );
                                    },

                                    icon: SvgPicture.asset(
                                      AppAssets.downloadIcon,
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          children:
                              chapter.topics.asMap().entries.map((entry) {
                                final topicIndex = entry.key;
                                final topic = entry.value;
                                final isLastTopic =
                                    topicIndex == chapter.topics.length - 1;

                                final progressData = ref
                                    .watch(progressProvider)
                                    .maybeWhen(
                                      data:
                                          (data) => data?.firstWhereOrNull(
                                            (p) => p.subject == subjectId,
                                          ),
                                      orElse: () => null,
                                    );

                                final completedTopics =
                                    progressData?.topicProgress ?? [];

                                final isCompleted = completedTopics.contains(
                                  topic.topicTitle,
                                );

                                final lastCompletedIndex = chapter.topics
                                    .indexWhere(
                                      (t) =>
                                          t.topicTitle ==
                                          completedTopics.lastOrNull,
                                    );

                                // ✅ Ready if the topic is exactly next after the last completed one
                                // AND that completed one wasn't the last topic in this chapter
                                final isReady =
                                    lastCompletedIndex != -1 &&
                                    topicIndex == lastCompletedIndex + 1 &&
                                    lastCompletedIndex <
                                        chapter.topics.length - 1;

                                final isLocked = !isCompleted && !isReady;

                                return TopicItem(
                                  topic: topic,
                                  needToGenerate: needToGenerate,
                                  showConnector: !(isLastTopic),
                                  isCompleted: isCompleted,
                                  isLocked: isLocked,
                                  isReady: isReady,
                                  isLoading: isLoading,
                                  sectionTitle: chapter.sectionTitle,
                                  onCompletion: () async {
                                    final progressService =
                                        locator.get<ProgressServices>();

                                    final progressList = await ref.read(
                                      progressProvider.future,
                                    );

                                    // Find progress for this specific subject
                                    final existingProgress = progressList
                                        ?.firstWhereOrNull(
                                          (p) => p.subject == subjectId,
                                        ); // ✅ safe

                                    String? progressId;

                                    if (existingProgress == null) {
                                      // No progress exists for this subject, so create it
                                      final createdProgress =
                                          await progressService.createProgress(
                                            subjectId: subjectId,
                                          );
                                      if (createdProgress != null) {
                                        progressId = createdProgress.id;
                                      }
                                    } else {
                                      // Use the existing progress
                                      progressId = existingProgress.id;
                                    }

                                    final isLastTopic =
                                        topicIndex == chapter.topics.length - 1;

                                    if (progressId != null) {
                                      bool updated = false;

                                      // Update topic
                                      final topicSuccess = await progressService
                                          .updateProgress(
                                            progressId: progressId,
                                            title: topic.topicTitle,
                                            type: 'topic',
                                          );

                                      if (topicSuccess) updated = true;

                                      // If it's the last topic, update section too
                                      if (isLastTopic) {
                                        final sectionSuccess =
                                            await progressService
                                                .updateProgress(
                                                  progressId: progressId,
                                                  title: chapter.sectionTitle,
                                                  type: 'section',
                                                );
                                        if (sectionSuccess) updated = true;

                                        analytics.logLessonCompleted(
                                          lessonTitle: topic.topicTitle,
                                          sectionTitle: chapter.sectionTitle,
                                        );
                                      }

                                      if (updated) {
                                        if (!context.mounted) return;
                                        ref.invalidate(progressProvider);
                                        Navigator.pop(context);
                                      }

                                      // 🚀 Auto-download logic for the next section
                                      final isSecondLastTopic =
                                          topicIndex ==
                                          chapter.topics.length -
                                              2; // second last

                                      final isNotLastSection =
                                          chapterIndex <
                                          subject.sections.length - 1;

                                      if (isSecondLastTopic &&
                                          isNotLastSection) {
                                        final nextSection =
                                            subject.sections[chapterIndex + 1];
                                        final needToGenerateNext =
                                            nextSection
                                                .topics
                                                .first
                                                .pages
                                                ?.isEmpty ??
                                            true;

                                        if (needToGenerateNext) {
                                          if (!context.mounted) return;
                                          ref
                                              .read(
                                                downloadManagerProvider
                                                    .notifier,
                                              )
                                              .startSilent(
                                                subjectId,
                                                nextSection.sectionTitle,
                                              );
                                        }
                                      }
                                    }
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
