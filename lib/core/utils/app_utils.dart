import 'dart:io';

import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUtils {
  /// Returns the initials of a name (e.g., "John Doe" -> "JD")
  static String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  /// Returns the app version as semantic version only (e.g., "1.2.3")
  /// Excludes build number
  static Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      return '1.0.0'; // fallback version
    }
  }

  static void showUpdateDialog({
    required BuildContext context,
    required String message,
  }) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => CustomDialog(
            title: 'Upgrade Required',
            description: message,
            buttonText: 'Upgrade Now',
            onPressed: () async {
              Navigator.of(ctx, rootNavigator: true).pop();

              final url =
                  Platform.isAndroid
                      ? "https://play.google.com/store/apps/"
                      : "https://apps.apple.com/";

              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
    );
  }
}
