import 'dart:io';

import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
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
                  Platform.isIOS
                      ? "https://apps.apple.com/app/idXXXXXXXXX"
                      : "https://play.google.com/store/apps/details?id=com.cubixaiapp.mobile";

              final uri = Uri.parse(url);
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
    );
  }

  static void showReactivateDialog({
    required BuildContext context,
    required Function() onPressed,
  }) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder:
          (ctx) => CustomDialog(
            title: 'Reactivate Account',
            description:
                'Looks like your account was deleted. Want it back? Tap here to reactivate.',
            buttonText: 'Reactivate Now',
            onPressed: onPressed,
          ),
    );
  }

  /// Responsible for firebase crash analytics
  static initFirebaseCrashlytics(bool overrideDebug) async {
    if (kReleaseMode || overrideDebug) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
  }
}
