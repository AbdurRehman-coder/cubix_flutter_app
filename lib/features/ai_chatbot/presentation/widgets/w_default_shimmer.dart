import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:shimmer/shimmer.dart';

class DefaultChatShimmer extends StatelessWidget {
  const DefaultChatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Close button shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(width: 220, height: 30, radius: 6),
              ShimmerBox(width: 30, height: 30, radius: 8),
            ],
          ),
          const SizedBox(height: 10),

          // Subtitle shimmer
          ShimmerBox(width: 180, height: 20, radius: 6),

          SizedBox(height: getProportionateScreenHeight(60)),

          // Logo/GIF shimmer
          Center(
            child: ShimmerBox(
              width: getProportionateScreenHeight(120),
              height: getProportionateScreenHeight(120),
              radius: 60,
            ),
          ),

          SizedBox(height: getProportionateScreenHeight(80)),

          // "Try telling me" shimmer
          ShimmerBox(width: 160, height: 26, radius: 6),
          const SizedBox(height: 20),

          // Grid shimmer placeholders
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.9,
            ),
            itemCount: 4, // show 4 shimmer items
            itemBuilder: (context, index) {
              return ShimmerBox(width: double.infinity, height: 60, radius: 8);
            },
          ),

          SizedBox(height: getProportionateScreenHeight(50)),
          ShimmerBox(width: double.infinity, height: 52, radius: 6),
        ],
      ),
    );
  }
}

/// Helper shimmer box widget
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
