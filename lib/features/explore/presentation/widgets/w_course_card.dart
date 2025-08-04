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
                color:
                    subject.category == CourseCategory.core.displayName
                        ? Color(0xffFFDBBF)
                        : subject.category ==
                            CourseCategory.business.displayName
                        ? Color(0xffC5E3D3)
                        : subject.category == CourseCategory.mind.displayName
                        ? Color(0xffC1DBFD)
                        : Color(0xffFFDBBF),

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Image.asset(
                  subject.category == CourseCategory.core.displayName
                      ? 'assets/images/english_image.png'
                      : 'assets/images/brain_image.png',
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
}
