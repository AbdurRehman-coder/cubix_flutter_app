import 'package:cubix_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

extension LoadingDialogExt on BuildContext {
  void showLoading() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder:
          (_) => PopScope(
            canPop: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.primaryOrangeColor,
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void hideLoading() {
    if (Navigator.of(this, rootNavigator: true).canPop()) {
      Navigator.of(this, rootNavigator: true).pop();
    }
  }
}
