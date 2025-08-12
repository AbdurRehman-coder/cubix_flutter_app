import 'dart:developer';
import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:dio/dio.dart';

class AuthServices {
  final ApiClient apiClient;
  final GoogleAuthService googleAuthService;
  final AppleAuthServices appleAuthServices;
  final SharedPrefServices localDBServices;

  AuthServices({
    required this.apiClient,
    required this.googleAuthService,
    required this.appleAuthServices,
    required this.localDBServices,
  });

  ///
  /// Handle Auth Token

  Future<void> handleLogin() async {
    const String url = "/login";
    try {
      Response response = await apiClient.dio.get(url);
      if (response.statusCode == 200 && response.data['data'] != null) {
        final dataJson = response.data['data'];
        log('Login success: ${dataJson.toString()}');
        localDBServices.saveAccessToken(dataJson['access_token']);
      }
    } catch (e) {
      log('Failed to fetch subjects: $e');
      throw Exception("Failed to fetch subjects: $e");
    }
  }

  ///
  /// Handle Google Auth
  Future<void> handleGoogleAuth(BuildContext context) async {
    try {
      final userData = await googleAuthService.signIn();
      if (userData != null) {
        localDBServices.saveAccessToken(userData.accessToken ?? '');
        log('Name: ${userData.account.displayName}');
        log('Email: ${userData.account.email}');
        log('Access Token: ${userData.accessToken}');
        log('ID Token: ${userData.idToken}');
        if (!context.mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (route) => false,
        );
      } else {
        if (!context.mounted) return;
        _showError(context, 'Sign-in cancelled by user');
      }
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, e.toString());
      log('Sign-in error: $e');
    }
  }

  ///
  /// Sign out
  ///

  Future<void> handleSignOut(BuildContext context) async {
    googleAuthService.handleSignOut();
    locator.get<SharedPrefServices>().clearAccessToken();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  ///
  /// Delete account
  ///

  Future<void> handleDelete(BuildContext context) async {
    googleAuthService.handleSignOut();
    locator.get<SharedPrefServices>().clearAccessToken();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
