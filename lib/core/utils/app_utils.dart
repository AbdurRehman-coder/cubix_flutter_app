import 'package:package_info_plus/package_info_plus.dart';

class AppUtils {
  String getInitials(String? name) {
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
}
