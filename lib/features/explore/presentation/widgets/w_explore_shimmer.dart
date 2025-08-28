import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:shimmer/shimmer.dart';

class ExploreShimmer extends StatelessWidget {
  const ExploreShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: 6,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: getProportionateScreenWidth(16),
          mainAxisSpacing: getProportionateScreenHeight(30),
        ),
        itemBuilder: (_, __) => const CourseCardShimmer(),
      ),
    );
  }
}

class CourseCardShimmer extends StatelessWidget {
  const CourseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top colored image container
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
              ),
            ),
            // Text placeholders
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 17, 14),
                child: Column(
                  children: [
                    Container(height: 10, width: 50, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.white,
                    ),
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
