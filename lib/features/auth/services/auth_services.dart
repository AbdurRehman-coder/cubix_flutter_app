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

  Future<AuthResponse?> _signup(String path, AuthRequestModel request) async {
    try {
      final res = await apiClient.dio.post(
        path,
        data: request.toJson(),
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      final data = res.data['data'];
      if (res.statusCode == 200 && data != null) {
        final auth = AuthResponse.fromJson(data);
        await localDBServices.saveLoggedUser(auth);
        log('✅ Signup success: ${auth.toJson()}');
        return auth;
      }
    } catch (e) {
      log('❌ Signup error: $e');
    }
    return null;
  }

  Future<void> handleGoogleAuth(BuildContext context) async {
    try {
      context.showLoading();
      final user = await googleAuthService.signIn();
      if (user == null) {
        if (!context.mounted) return;
        context.hideLoading();
        if (context.mounted) _showError(context, 'Google sign-in failed');
        return;
      }

      final names = (user.account.displayName ?? '').split(' ');
      final req = AuthRequestModel(
        idToken: user.idToken ?? '',
        firstName: names.first,
        lastName: names.length > 1 ? names.sublist(1).join(' ') : '',
      );

      final auth = await _signup("/auth/sign-in/google", req);
      if (auth != null && context.mounted) {
        context.hideLoading();
        _navigateToMain(context);
      }
    } catch (e) {
      if (!context.mounted) return;
      context.hideLoading();
      if (context.mounted) _showError(context, e.toString());
    }
  }

  Future<void> handleAppleAuth(BuildContext context) async {
    try {
      context.showLoading();
      final payload = await appleAuthServices.signIn();
      final req = AuthRequestModel(
        identityToken: payload.identityToken,
        userIdentifier: payload.userIdentifier,
        firstName: payload.givenName ?? '',
        lastName: payload.familyName ?? '',
      );

      final auth = await _signup("/auth/sign-in/apple", req);
      if (auth != null && context.mounted) {
        context.hideLoading();
        _navigateToMain(context);
      }
    } on AppleAuthCancelledException {
      if (!context.mounted) return;
      context.hideLoading();
      log('🚫 Apple sign-in cancelled');
    } on AppleAuthUnsupportedException {
      if (context.mounted) {
        context.hideLoading();
        _showError(context, 'Apple Sign-In is only available on iOS');
      }
    } catch (e) {
      if (!context.mounted) return;
      context.hideLoading();
      if (context.mounted) _showError(context, 'Apple sign-in failed: $e');
    }
  }

  Future<void> handleSignOut(BuildContext context) async {
    googleAuthService.handleSignOut();
    appleAuthServices.signOut();
    localDBServices.clearTokens();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (_) => false,
    );
  }

  Future<AuthResponse?> handleRefreshToken() async {
    try {
      final user = await localDBServices.getLoggedUser();
      if (user == null) return null;

      final res = await apiClient.dio.post(
        "/auth/refresh",
        options: Options(
          headers: {
            "Authorization": "Bearer ${user.refreshToken}",
            "Content-Type": "application/json",
          },
        ),
      );

      final data = res.data['data'];
      if (res.statusCode == 200 && data != null) {
        final auth = AuthResponse.fromJson(data);
        await localDBServices.saveLoggedUser(auth);
        log('🔄 Token refreshed: ${auth.toJson()}');
        return auth;
      }
    } catch (e) {
      log('❌ Refresh token failed: $e');
    }
    return null;
  }

  void _navigateToMain(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MainScreen()),
      (_) => false,
    );
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
