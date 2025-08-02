import 'package:cubix_app/core/theming/app_colors.dart';
import 'package:cubix_app/core/utils/text_styles.dart';
import 'package:cubix_app/features/explore/models/course_model.dart';
import 'package:cubix_app/features/explore/providers/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryTab extends ConsumerWidget {
  final CourseCategory category;

  const CategoryTab({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        ref.read(selectedCategoryProvider.notifier).state = category;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff096EF9) : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          category.displayName,
          style: AppTextStyles.bodyTextStyle.copyWith(
            color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
