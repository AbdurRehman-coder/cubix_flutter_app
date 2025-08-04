import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_feedback_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectsProvider);

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
          vertical: getProportionateScreenHeight(21),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/app_logo_2.svg',
                fit: BoxFit.scaleDown,
              ),
              GestureDetector(
                child: SvgPicture.asset(
                  AppAssets.feedbackIcon,
                  height: getProportionateScreenHeight(25),
                ),
                onTap: () => showFeedbackDialog(context),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),

          subjectsAsync.when(
            loading: () => HomeShimmer(),
            error:
                (error, _) => Center(
                  child: Text(
                    'Error loading the subjects',
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.textSecondaryColor,
                    ),
                  ),
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeBannerSlider(),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  GeneralEducationSection(subjects: subjects.gen),
                  SizedBox(height: getProportionateScreenHeight(24)),
                  BusinessSection(subjects: subjects.busiEcon),
                  SizedBox(height: getProportionateScreenHeight(24)),
                  PsychologySection(subjects: subjects.psyHuman),
                  SizedBox(height: getProportionateScreenHeight(24)),
                  ArtsHumanitiesSection(subjects: subjects.artsHuman),
                  SizedBox(height: getProportionateScreenHeight(24)),
                  HealthScienceSection(subjects: subjects.healLife),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const FeedbackDialog(),
    );
  }
}
