import 'dart:developer';
import 'package:cubix_app/core/utils/app_exports.dart';

class CourseCard extends StatelessWidget {
  final Subject subject;

  const CourseCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: getCategoryColor(subject.category),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Image.asset(
                  AppAssets.getIconPath(subject.abbreviation),
                  fit: BoxFit.cover,
                  height: 91,
                  width: 91,
                ),
              ),
            ),
          ),
          // Text content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 17, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    subject.abbreviation,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subject.title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyTextStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getCategoryColor(String categoryName) {
    switch (categoryName) {
      case 'gen':
        return const Color(0xffFFDBBF);
      case 'busi_econ':
        return const Color(0xffC5E3D3);
      case 'psy_human':
        return const Color(0xffC1DBFD);
      case 'arts_human':
        return const Color(0xffFFF5CB);
      case 'heal_life':
        return const Color(0xffE5D3F1);
      case 'Innovation':
        return const Color(0xffD4F8E8);
      default:
        return const Color(0xffF0F0F0); // fallback color
    }
  }
}
