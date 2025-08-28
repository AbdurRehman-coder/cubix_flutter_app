import 'package:cubix_app/core/utils/app_exports.dart';

bool _isLoadingDialogOpen = false;

extension LoadingDialogExt on BuildContext {
  void showLoading() {
    if (_isLoadingDialogOpen) return;
    _isLoadingDialogOpen = true;

    showDialog(
      context: this,
      barrierDismissible: false,
      builder:
          (_) => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryOrangeColor,
            ),
          ),
    ).then((_) {
      _isLoadingDialogOpen = false; // reset when closed
    });
  }

  void hideLoading() {
    if (_isLoadingDialogOpen &&
        Navigator.of(this, rootNavigator: true).canPop()) {
      Navigator.of(this, rootNavigator: true).pop();
      _isLoadingDialogOpen = false;
    }
  }
}
