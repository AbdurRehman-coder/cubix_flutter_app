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

  Future<AuthResponse?> _signup(
    String path,
    AuthRequestModel request,
    BuildContext context,
  ) async {
    try {
      final res = await apiClient.dio.post(
        path,
        data: request.toJson(),
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      final data = res.data['data'];
      final message = res.data['message'] ?? 'Unexpected error';

      if (res.statusCode == 200 && data != null) {
        final auth = AuthResponse.fromJson(data);
        await localDBServices.saveLoggedUser(auth);
        log('✅ Signup success: ${auth.toJson()}');
        return auth;
      }
      if (!context.mounted) return null;
      context.hideLoading();
      _handleError(context, res.statusCode, message);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg = e.response?.data['message'] ?? e.message ?? 'Network error';

      log('❌ Dio signup error: $msg (status: $status)');

      if (!context.mounted) return null;
      context.hideLoading();
      _handleError(context, status, msg);
    } catch (e, s) {
      log('❌ Unexpected signup error: $e\n$s');
      if (context.mounted) {
        context.hideLoading();
        _showError(context, 'Something went wrong');
      }
    }
    return null;
  }

  Future<void> handleGoogleAuth(BuildContext context) async {
    try {
      context.showLoading();
      final user = await googleAuthService.signIn();
      if (user == null) {
        if (context.mounted) _showError(context, 'Google sign-in failed');
        return;
      }

      final names = (user.account.displayName ?? '').split(' ');
      final appVersion = await AppUtils.getAppVersion();

      final req = AuthRequestModel(
        idToken: user.idToken ?? '',
        firstName: names.first,
        lastName: names.length > 1 ? names.sublist(1).join(' ') : '',
        fcmToken: '',
        appVersion: appVersion,
      );

      final auth = await _signup("/auth/sign-in/google", req, context);
      if (auth != null && context.mounted) {
        _navigateToMain(context);
      }
    } catch (e) {
      log('❌ Google auth error: $e');
      if (context.mounted) _showError(context, e.toString());
    } finally {
      if (context.mounted) context.hideLoading();
    }
  }

  Future<void> handleAppleAuth(BuildContext context) async {
    try {
      context.showLoading();

      final payload = await appleAuthServices.signIn();

      final appVersion = await AppUtils.getAppVersion();
      final req = AuthRequestModel(
        identityToken: payload.identityToken,
        userIdentifier: payload.userIdentifier,
        firstName: payload.givenName ?? '',
        lastName: payload.familyName ?? '',
        fcmToken: '',
        appVersion: appVersion,
      );

      final auth = await _signup("/auth/sign-in/apple", req, context);
      if (auth != null && context.mounted) {
        _navigateToMain(context);
      }
    } on AppleAuthCancelledException {
      log('🚫 Apple sign-in cancelled by user');
      // No error dialog here because cancellation is intentional
    } on AppleAuthUnsupportedException {
      if (context.mounted) {
        _showError(context, 'Apple Sign-In is only available on iOS devices');
      }
    } catch (e, s) {
      log('❌ Apple sign-in error: $e\n$s');
      if (context.mounted) {
        _showError(context, 'Something went wrong during Apple sign-in');
      }
    } finally {
      if (context.mounted) context.hideLoading();
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

  Future<void> handleDeleteAccount(BuildContext context) async {
    String url = '/users';
    try {
      final res = await apiClient.dio.delete(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      final data = res.data['data'];
      if (res.statusCode == 200 && data != null) {
        if (!context.mounted) return;
        handleSignOut(context);
      }
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, e.toString());
      log('❌ delete account error: $e');
    }
  }

  void _navigateToMain(BuildContext context) {
    context.hideLoading();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MainScreen()),
      (_) => false,
    );
  }

  void _handleError(BuildContext context, int? status, String msg) {
    if (status == 426) {
      AppUtils.showUpdateDialog(context: context, message: msg);
    } else {
      _showError(context, msg);
    }
  }

  void _showError(BuildContext context, String msg) {
    context.hideLoading();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
