import 'package:cubix_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int length;

  const DotIndicator({
    super.key,
    required this.currentIndex,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final isSelected = currentIndex == index;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: isSelected ? 6 : 6,
          height: isSelected ? 6 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isSelected
                    ? AppColors.whiteColor
                    : AppColors.whiteColor.withValues(alpha: 0.6),
          ),
        );
      }),
    );
  }
}
