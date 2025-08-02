import 'package:cubix_app/features/lessons/provider/lessons_provider.dart';
import 'package:cubix_app/core/utils/app_exports.dart';

class LessonDetailsScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String chapterId;

  const LessonDetailsScreen({
    super.key,
    required this.courseId,
    required this.chapterId,
  });

  @override
  ConsumerState<LessonDetailsScreen> createState() =>
      _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends ConsumerState<LessonDetailsScreen> {
  int currentStep = 0;

  final List<LessonContent> lessonContents = [
    LessonContent(
      type: LessonContentType.objectives,
      title: 'Methods for Studying the Brain',
    ),
    LessonContent(type: LessonContentType.eegImage, title: 'EEG'),
    LessonContent(type: LessonContentType.methodChoice, title: 'Method Choice'),
  ];

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(coursesNotifierProvider);
    final course = courses.firstWhere((c) => c.id == widget.courseId);
    final chapter = course.chapters.firstWhere(
      (ch) => ch.id == widget.chapterId,
    );

    return Scaffold(
      body: Column(
        children: [
          // Header with progress
          Container(
            decoration: BoxDecoration(
              color: Colors.white,

              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: AppColors.blackColor.withValues(alpha: 0.25),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 21,
              bottom: 14,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 30,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: (currentStep + 1) / lessonContents.length,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrangeColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(child: _buildStepContent()),

          // Action Button
          Padding(
            padding: const EdgeInsets.all(30),
            child: PrimaryButton(
              borderRadius: 12,
              text: _getButtonText(),
              onPressed: _handleButtonPress,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (lessonContents[currentStep].type) {
      case LessonContentType.objectives:
        return _buildObjectivesContent();
      case LessonContentType.eegImage:
        return _buildEEGImageContent();
      case LessonContentType.methodChoice:
        return _buildMethodChoiceContent();
    }
  }

  Widget _buildObjectivesContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Methods for Studying the Brain',
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'By the end of this lesson, you will be able to:',
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff242425),
              height: 1.2,
            ),
          ),

          const SizedBox(height: 16),

          _buildObjectivePoint(
            'Describe the core principles of EEG, fMRI, PET, and lesion/stimulation methods.',
          ),

          const SizedBox(height: 16),

          _buildObjectivePoint(
            'Compare their temporal and spatial resolutions, invasiveness, and typical uses.',
          ),

          const SizedBox(height: 16),

          _buildObjectivePoint(
            'Select the optimal method for a given research scenario.',
          ),
        ],
      ),
    );
  }

  Widget _buildObjectivePoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, right: 12),
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff242425),
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEEGImageContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // EEG Image placeholder - replace with actual image
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // This should be your actual EEG image
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: const Center(
                    child: Text(
                      'EEG Image\n(Replace with actual image asset)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          const Text(
            'EEG',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 32),

          _buildSection('What & How', [
            'Definition: EEG (electroencephalography) records voltage fluctuations on the scalp.',
            'Mechanism: Electrodes pick up summed post-synaptic potentials from thousands of neurons firing together.',
          ]),

          const SizedBox(height: 24),

          _buildSection('Key Strength', [
            'Temporal Resolution: Millisecond-level precision—ideal for tracking when brain events occur.',
          ]),

          const SizedBox(height: 24),

          _buildSection('Key Limitation', [
            'Spatial Resolution: Signals blur across the skull, so it\'s hard to localize deep sources.',
          ]),

          const SizedBox(height: 24),

          _buildSection('Practical Notes', [
            'Non-invasive & Low Cost: Common in clinics and labs.',
            'Artifacts to Watch: Muscle activity (e.g., eye blinks) can contaminate recordings.',
          ]),

          const SizedBox(height: 24),

          _buildSection('Common Uses', [
            'Sleep staging',
            'Epilepsy monitoring',
            'Brain–computer interfaces',
          ]),
        ],
      ),
    );
  }

  Widget _buildMethodChoiceContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Method Choice',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Choosing among EEG, fMRI, PET, and lesions/stimulation involves trade-offs:',
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 24),

          _buildMethodPoint(
            'EEG',
            'best temporal, poorest spatial, non-invasive, low cost',
          ),

          const SizedBox(height: 16),

          _buildMethodPoint(
            'fMRI',
            'best spatial, poor temporal, non-invasive, high cost',
          ),

          const SizedBox(height: 16),

          _buildMethodPoint(
            'PET',
            'moderate spatial/temporal, invasive, very high cost',
          ),

          const SizedBox(height: 16),

          _buildMethodPoint(
            'Lesion/TMS',
            'causal inference, variable resolution, ethical constraints',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...points
            .map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildMethodPoint(String method, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, right: 12),
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: '$method: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getButtonText() {
    if (currentStep < lessonContents.length - 1) {
      return 'Continue';
    } else {
      return 'Finish';
    }
  }

  void _handleButtonPress() {
    if (currentStep < lessonContents.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      // Complete all lessons in the chapter
      final courses = ref.read(coursesNotifierProvider);
      final course = courses.firstWhere((c) => c.id == widget.courseId);
      final chapter = course.chapters.firstWhere(
        (ch) => ch.id == widget.chapterId,
      );

      for (final lesson in chapter.lessons) {
        ref
            .read(coursesNotifierProvider.notifier)
            .completeLesson(widget.courseId, widget.chapterId, lesson.id);
      }

      Navigator.pop(context);
    }
  }
}

enum LessonContentType { objectives, eegImage, methodChoice }

class LessonContent {
  final LessonContentType type;
  final String title;

  LessonContent({required this.type, required this.title});
}
