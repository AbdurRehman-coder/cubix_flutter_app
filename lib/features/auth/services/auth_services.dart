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
        locator<AnalyticServices>().setUserId(auth.user.id);
        log('✅ Signup success: ${auth.toJson()}');
        return auth;
      }
      if (!context.mounted) return null;
      context.hideLoading();
      _handleError(context, res.statusCode, message, request.userIdentifier);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg = e.response?.data['message'] ?? e.message ?? 'Network error';

      log('❌ Dio signup error: $msg (status: $status)');

      if (!context.mounted) return null;
      context.hideLoading();
      _handleError(context, status, msg, request.userIdentifier);
    } catch (e, s) {
      log('❌ Unexpected signup error: $e\n$s');
      if (context.mounted) {
        context.hideLoading();
        _showMessage(context, 'Something went wrong');
      }
    }
    return null;
  }

  Future<void> handleGoogleAuth(BuildContext context) async {
    try {
      context.showLoading();
      final user = await googleAuthService.signIn();
      if (user == null) {
        if (context.mounted) _showMessage(context, 'Google sign-in failed');
        return;
      }

      final names = (user.account.displayName ?? '').split(' ');
      final appVersion = await AppUtils.getAppVersion();

      final req = AuthRequestModel(
        idToken: user.idToken ?? '',
        firstName: names.first,
        userIdentifier: user.account.id,
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
      if (context.mounted) _showMessage(context, e.toString());
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
        _showMessage(context, 'Apple Sign-In is only available on iOS devices');
      }
    } catch (e, s) {
      log('❌ Apple sign-in error: $e\n$s');
      if (context.mounted) {
        _showMessage(context, 'Something went wrong during Apple sign-in');
      }
    } finally {
      if (context.mounted) context.hideLoading();
    }
  }

  Future<AuthResponse?> handleRefreshToken(BuildContext context) async {
    final user = await localDBServices.getLoggedUser();
    if (user?.refreshToken == null) return null;

    try {
      final appVersion = await AppUtils.getAppVersion();

      final refreshDio = Dio(
        BaseOptions(baseUrl: apiClient.dio.options.baseUrl),
      )..options.headers['Authorization'] = 'Bearer ${user!.refreshToken}';

      final res = await refreshDio.post(
        '/auth/refresh',
        data: {"appVersion": appVersion},
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      log('🔄 Refresh token response: ${res.data}');
      final data = res.data['body'];
      final message = res.data['message'] ?? 'Unexpected error';

      if (res.statusCode == 200 && data != null) {
        final updatedUser = user.copyWith(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );

        await localDBServices.saveLoggedUser(updatedUser);

        // ✅ update Dio global headers
        apiClient.dio.options.headers['Authorization'] =
            'Bearer ${updatedUser.accessToken}';

        return updatedUser;
      }

      if (context.mounted) {
        _handleError(context, res.statusCode, message, '');
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg = e.response?.data['message'] ?? e.message ?? 'Network error';

      log('❌ Dio refresh error: $msg (status: $status)');

      if (context.mounted) {
        _handleError(context, status, msg, '');
      }
    } catch (e, s) {
      log('❌ Unexpected refresh error: $e\n$s');
    }

    return null;
  }

  Future<void> handleSignOut(BuildContext context, WidgetRef ref) async {
    googleAuthService.handleSignOut();
    appleAuthServices.signOut();
    localDBServices.clearUserData();
    clearAllCache(ref);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (_) => false,
    );
  }

  Future<void> handleDeleteAccount(BuildContext context, WidgetRef ref) async {
    String url = '/users';
    try {
      final res = await apiClient.dio.delete(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (res.statusCode == 200) {
        if (!context.mounted) return;
        _showMessage(context, 'User deleted successfully.');
        handleSignOut(context, ref);
      }
    } catch (e) {
      if (!context.mounted) return;
      _showMessage(context, e.toString());
      log('❌ delete account error: $e');
    }
  }

  Future<void> handleReactivateUser(
    BuildContext context,
    String authUserId,
  ) async {
    const url = '/users/re-activate';
    try {
      final res = await apiClient.dio.patch(
        url,
        data: {"authUserID": authUserId},
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      if (res.statusCode == 200) {
        if (!context.mounted) return;
        Navigator.pop(context);
        _showMessage(context, res.data['message']);
      } else {
        final msg = res.data['message'] ?? 'Failed to reactivate user';
        Navigator.pop(context);
        if (context.mounted) _showMessage(context, msg);
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);

      if (e is DioException) {
        final errorMessage =
            e.response?.data['message'] ?? 'Something went wrong';
        _showMessage(context, errorMessage);
        log('❌ Reactivate user error: $errorMessage');
      } else {
        _showMessage(context, e.toString());
        log('❌ Reactivate user error: $e');
      }
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

  void _handleError(
    BuildContext context,
    int? status,
    String msg,
    String? authUserId,
  ) {
    if (status == 426) {
      AppUtils.showUpdateDialog(context: context, message: msg);
    }
    if (status == 410) {
      AppUtils.showReactivateDialog(
        context: context,
        onPressed: () => handleReactivateUser(context, authUserId!),
      );
    } else {
      _showMessage(context, msg);
    }
  }

  void _showMessage(BuildContext context, String msg) {
    context.hideLoading();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void clearAllCache(WidgetRef ref) {
    ref.invalidate(progressProvider);
    ref.invalidate(subjectsProvider);
    ref.invalidate(subjectDetailProvider);
    ref.invalidate(selectedTabProvider);
    ref.invalidate(selectedCategoryProvider);
    ref.invalidate(downloadManagerProvider);
    ref.invalidate(bannerPageProvider);
    ref.invalidate(notificationsProvider);
    ref.invalidate(soundsProvider);
    ref.invalidate(hapticsProvider);
    ref.invalidate(bottomNavIndexProvider);
  }
}
