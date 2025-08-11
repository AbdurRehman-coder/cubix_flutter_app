import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static const String _clientId =
      '461575555761-rq83mkuh591p25vkl2isusn8jovl1qh5.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn;

  GoogleAuthService()
    : _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: _clientId,
      );

  /// Signs in the user and returns GoogleSignInAccount + tokens
  Future<GoogleUserData?> signIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return null; // User cancelled sign-in

      final auth = await account.authentication;

      return GoogleUserData(
        account: account,
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Silently signs in the user if already authenticated
  Future<GoogleUserData?> signInSilently() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account == null) return null;

      final auth = await account.authentication;

      return GoogleUserData(
        account: account,
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  /// Disconnects and revokes all permissions
  Future<void> disconnect() async {
    await _googleSignIn.disconnect();
  }

  /// Returns current signed-in user
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  /// Checks if a user is signed in
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
}

/// A simple data holder for user info + tokens
class GoogleUserData {
  final GoogleSignInAccount account;
  final String? accessToken;
  final String? idToken;

  GoogleUserData({required this.account, this.accessToken, this.idToken});
}
