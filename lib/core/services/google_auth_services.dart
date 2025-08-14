import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '461575555761-vv76t6q5rn7lsabl46v8i0n6su27rmpa.apps.googleusercontent.com',
  );

  Future<GoogleUserData?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      final auth = await account.authentication;

      return GoogleUserData(
        account: account,
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
    } catch (e) {
      log("Google sign-in error: $e");
      return null;
    }
  }

  Future<void> handleSignOut() async {
    await _googleSignIn.signOut();
  }

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
      log("Silent sign-in error: $e");
      return null;
    }
  }
}

class GoogleUserData {
  final GoogleSignInAccount account;
  final String? accessToken;
  final String? idToken;

  GoogleUserData({required this.account, this.accessToken, this.idToken});
}
