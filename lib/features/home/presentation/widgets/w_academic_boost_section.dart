import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_section_card.dart';

class AcademicBoostSection extends StatelessWidget {
  const AcademicBoostSection({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = ['Geography', 'Biology', 'Chemistry', 'Business'];

    return SectionCard(
      title: 'Academic Boost',
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              child: Stack(
                children: [
                  SvgPicture.asset(AppAssets.bookIcon, width: 97, height: 112),
                  Positioned(
                    top: 16,
                    bottom: 0,
                    left: 20,
                    right: 6,
                    child: Text(
                      subjects[index],
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
