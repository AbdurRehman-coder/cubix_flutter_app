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
      if (userData == null) {
        if (context.mounted) {
          context.hideLoading();
          _showError(context, 'Error signing in with Google');
        }
        return;
      }

      final names = (userData.account.displayName ?? '').split(' ');
      final authResponse = await handleSignup(
        authRequestModel: AuthRequestModel(
          firstName: names.first,
          lastName: names.length > 1 ? names.sublist(1).join(' ') : '',
          idToken: userData.idToken!,
        ),
      );

      if (authResponse != null && context.mounted) {
        localDBServices.saveLoggedUser(authResponse);
        context.hideLoading();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
          (_) => false,
        );
      }
    } catch (e) {
      context.hideLoading();
      if (context.mounted) _showError(context, e.toString());
      log('Error signing in with Google');
    }
  }

  Future<void> handleSignOut(BuildContext context) async {
    googleAuthService.handleSignOut();
    localDBServices.clearTokens();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (_) => false,
    );
  }

  Future<void> handleDelete(BuildContext context) async {
    await handleSignOut(context);
  }

  Future<AuthResponse?> handleRefreshToken() async {
    try {
      final authResponse = await localDBServices.getLoggedUser();
      if (authResponse == null) return null;

      final response = await apiClient.dio.post(
        "/auth/refresh",
        options: Options(
          headers: {
            "Authorization": "Bearer ${authResponse.refreshToken}",
            "Content-Type": "application/json",
          },
        ),
      );

      final data = response.data['data'];
      if (response.statusCode == 200 && data != null) {
        return authResponse.copyWith(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
        );
      }

      return null;
    } catch (e) {
      log('❌ Refresh token request failed: $e');
      return null;
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
