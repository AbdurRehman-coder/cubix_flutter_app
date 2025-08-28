import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CourseDetailsShimmer extends StatelessWidget {
  const CourseDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        _shimmerBanner(),
        const SizedBox(height: 24),
        ...List.generate(3, (_) => _shimmerSectionBlock()),
      ],
    );
  }

  Widget _shimmerBanner() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _shimmerSectionBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerTitle(),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: 2,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) => _shimmerIconItem(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerTitle() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(width: double.infinity, height: 16, color: Colors.white),
    );
  }

  Widget _shimmerIconItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
