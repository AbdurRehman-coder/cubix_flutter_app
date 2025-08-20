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
              //SvgPicture.asset(AppAssets.appIcon2, fit: BoxFit.scaleDown),
              Text(
                'CUBIX',
                style: AppTextStyles.headingTextStyle.copyWith(
                  fontSize: 30,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  height: 30 / 22,
                ),
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
          SizedBox(height: getProportionateScreenHeight(20)),

          subjectsAsync.when(
            loading: () => HomeShimmer(),
            error:
                (error, _) => MessageWidget(
                  title: 'Something went wrong!',
                  subtitle:
                      'There is something wrong with the server or your request is invalid.',
                ),
            data: (subjects) {
              if (subjects == null) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Text(
                      "No subjects found.",
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeBannerSlider(),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  CreativitySection(subjects: subjects.creativity),
                  SizedBox(height: getProportionateScreenHeight(24)),
                  GrowthSection(subjects: subjects.growth),
                  SizedBox(height: getProportionateScreenHeight(24)),
                  CareerSection(subjects: subjects.career),
                  SizedBox(height: getProportionateScreenHeight(24)),
                  CuriositySection(subjects: subjects.curiosity),
                  SizedBox(height: getProportionateScreenHeight(24)),
                  BooksSection(subjects: subjects.books),
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
