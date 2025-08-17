import 'dart:developer';
import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/core/utils/app_extensions.dart';
import 'package:cubix_app/features/auth/models/auth_request_model.dart';
import 'package:cubix_app/features/auth/models/auth_response_model.dart';
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

  Future<AuthResponse?> handleSignup({
    required AuthRequestModel authRequestModel,
  }) async {
    try {
      final response = await apiClient.dio.post(
        "/auth/sign-in/google",
        data: authRequestModel.toJson(),
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      final data = response.data['data'];
      if (response.statusCode == 200 && data != null) {
        final authResponse = AuthResponse.fromJson(data);
        log('Signup success: ${authResponse.toJson()}');
        return authResponse;
      }

      return null;
    } catch (e) {
      log('Signup request error: $e');
      throw Exception("Signup request failed: $e");
    }
  }

  Future<void> handleGoogleAuth(BuildContext context) async {
    try {
      context.showLoading();
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
        _showError(context, 'Error signing in with google');
      }
    } catch (e) {
      context.hideLoading();
      if (context.mounted) _showError(context, e.toString());
      log('Error signing in with Google');
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
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (_) => false,
    );
  }

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
