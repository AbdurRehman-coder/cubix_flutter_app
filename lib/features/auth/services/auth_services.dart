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
        // Call backend API
        const String url = "/auth/google";
        final requestBody = {
          "idToken": userData.idToken,
          "accessToken": userData.accessToken,
          if (userData.serverAuthCode != null)
            "serverAuthCode": userData.serverAuthCode,
        };

        Response response = await apiClient.dio.post(url, data: requestBody);

        if (response.statusCode == 200 && response.data['ok'] == true) {
          final dataJson = response.data;
          log('Google sign-in success: ${dataJson.toString()}');

          // Save session data from backend response
          if (dataJson['session'] != null &&
              dataJson['session']['access_token'] != null) {
            localDBServices.saveAccessToken(
              dataJson['session']['access_token'],
            );
          }

          if (dataJson['user'] != null) {
            log('User: ${dataJson['user'].toString()}');
          }

          if (!context.mounted) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
          );
        } else {
          throw Exception('Backend authentication failed');
        }
      } else {
        if (!context.mounted) return;
        _showError(context, 'Error signing in with google');
      }
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, e.toString());
      log('Sign-in error: $e');
    }
  }

  ///
  /// Handle Apple Auth
  Future<void> signInWithApple(BuildContext context) async {
    try {
      final payload = await appleAuthServices.signIn();

      // Call backend API
      const String url = "/auth/apple";
      final requestBody = {
        "identityToken": payload.identityToken,
        "authorizationCode": payload.authorizationCode,
        "nonce": payload.rawNonce,
        "givenName": payload.givenName,
        "familyName": payload.familyName,
      };

      Response response = await apiClient.dio.post(url, data: requestBody);

      if (response.statusCode == 200 && response.data['ok'] == true) {
        final dataJson = response.data;
        log('Apple sign-in success: ${dataJson.toString()}');

        // Save session data similar to Google auth
        if (dataJson['session'] != null &&
            dataJson['session']['access_token'] != null) {
          localDBServices.saveAccessToken(dataJson['session']['access_token']);
        }

        if (dataJson['user'] != null) {
          log('User: ${dataJson['user'].toString()}');
        }

        if (!context.mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (route) => false,
        );
      } else {
        throw Exception('Backend authentication failed');
      }
    } on AppleAuthCancelledException {
      // User cancelled - don't show error, just stop loading
      log('Apple sign-in cancelled by user');
      return;
    } on AppleAuthUnsupportedException {
      if (!context.mounted) return;
      _showError(context, 'Apple Sign-In is only available on iOS devices');
    } on AppleAuthFailedException catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Apple Sign-In failed: ${e.message}');
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Apple Sign-In failed: $e');
      log('Apple sign-in error: $e');
    }
  }

  ///
  /// Sign out
  ///

  Future<void> handleSignOut(BuildContext context) async {
    googleAuthService.handleSignOut();
    appleAuthServices.signOut();
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
    appleAuthServices.signOut();
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
