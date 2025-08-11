// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs, avoid_print

import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

// Import the new test screen
class UserInfoScreen extends StatelessWidget {
  final GoogleSignInAccount user;
  final String? accessToken;
  final String? idToken;

  const UserInfoScreen({
    super.key,
    required this.user,
    this.accessToken,
    this.idToken,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('✅ Google Sign-In Success'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '👤 User Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (user.photoUrl != null)
                      Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user.photoUrl!),
                        ),
                      ),
                    const SizedBox(height: 12),
                    _buildInfoRow('📧 Email:', user.email),
                    _buildInfoRow(
                      '👤 Name:',
                      user.displayName ?? 'Not provided',
                    ),
                    _buildInfoRow('🆔 ID:', user.id),
                    if (user.photoUrl != null)
                      _buildInfoRow('🖼️ Photo URL:', user.photoUrl!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tokens Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔑 Authentication Tokens',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (accessToken != null)
                      _buildTokenRow('Access Token:', accessToken!),
                    if (idToken != null) _buildTokenRow('ID Token:', idToken!),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('🚪 Back to Sign-In Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenRow(String label, String token) {
    final truncated =
        token.length > 50 ? '${token.substring(0, 50)}...' : token;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              truncated,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

const List<String> _scopes = <String>['email'];

class SignInDemo extends StatefulWidget {
  const SignInDemo({super.key});

  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  String _contactText = '';
  String _errorMessage = '';

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _signIn();
  }

  void _setUser(GoogleSignInAccount? user) {
    setState(() {
      _currentUser = user;
    });
    if (user != null) {
      _handleGetContact(user);
    }
  }

  Future<void> _signIn() async {
    try {
      print("🔍 DEBUG: Initializing Google Sign-In...");
      print("🔍 DEBUG: Package Name: com.cubixaiapp.mobile");
      print(
        "🔍 DEBUG: Client ID: 461575555761-rq83mkuh591p25vkl2isusn8jovl1qh5.apps.googleusercontent.com",
      );

      final GoogleSignInAccount? result = await _googleSignIn.signInSilently();
      _setUser(result);
    } catch (e) {
      print("❌ DEBUG: Silent sign-in failed: $e");
      setState(() {
        _errorMessage = 'Silent sign-in failed: $e';
      });
    }
  }

  Future<void> _handleAuthorizeScopes(GoogleSignInAccount user) async {
    setState(() {
      _isAuthorized = true;
      _errorMessage = '';
    });
    await _handleGetContact(user);
  }

  Future<Map<String, String>?> _getAuthHeaders(GoogleSignInAccount user) async {
    final GoogleSignInAuthentication auth = await user.authentication;
    if (auth.accessToken == null) {
      return null;
    }

    return <String, String>{
      'Authorization': 'Bearer ${auth.accessToken}',
      'X-Goog-AuthUser': '0',
    };
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final Map<String, String>? headers = await _getAuthHeaders(user);
    setState(() {
      _isAuthorized = headers != null;
    });
    if (headers == null) {
      return;
    }
    final http.Response response = await http.get(
      Uri.parse(
        'https://people.googleapis.com/v1/people/me/connections'
        '?requestMask.includeField=person.names',
      ),
      headers: headers,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText =
            'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final int contactCount =
        (data['connections'] as List<dynamic>?)?.length ?? 0;
    setState(() {
      _contactText = '$contactCount contacts found';
    });
  }

  Future<void> _handleSignIn() async {
    try {
      print("🔍 DEBUG: Starting manual sign-in process...");

      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        print("✅ DEBUG: Sign-in successful!");
        print("👤 DEBUG: User: ${account.displayName} (${account.email})");
        print("🆔 DEBUG: User ID: ${account.id}");

        if (account.photoUrl != null) {
          print("🖼️ DEBUG: Photo URL: ${account.photoUrl}");
        }

        // Get authentication details
        final GoogleSignInAuthentication auth = await account.authentication;

        print("🔑 DEBUG: Access Token available: ${auth.accessToken}");
        print("🔑 DEBUG: ID Token available: ${auth.idToken != null}");

        if (auth.accessToken != null) {
          print(
            "🔑 DEBUG: Access Token preview: ${auth.accessToken!.substring(0, 20)}...",
          );
        }
        if (auth.idToken != null) {
          print(
            "🔑 DEBUG: ID Token preview: ${auth.idToken!.substring(0, 20)}...",
          );
        }

        _setUser(account);

        // Navigate to success screen
        if (mounted) {
          print("🔍 DEBUG: Navigating to UserInfoScreen...");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => UserInfoScreen(
                    user: account,
                    accessToken: auth.accessToken,
                    idToken: auth.idToken,
                  ),
            ),
          );
        }
      } else {
        print("❌ DEBUG: Sign-in was cancelled by user");
        setState(() {
          _errorMessage = 'Sign-in was cancelled';
        });
      }
    } catch (e, stackTrace) {
      print("❌ DEBUG: Unexpected error during sign-in: $e");
      print("📍 DEBUG: Stack trace: $stackTrace");
      setState(() {
        _errorMessage = 'Sign-in failed: $e';
      });
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    _setUser(null);
  }

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        if (user != null) ...<Widget>[
          ListTile(
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
          if (_isAuthorized) ...<Widget>[
            // The user has Authorized all required scopes.
            if (_contactText.isNotEmpty) Text(_contactText),
            ElevatedButton(
              child: const Text('REFRESH'),
              onPressed: () => _handleGetContact(user),
            ),
          ] else ...<Widget>[
            // The user has NOT Authorized all required scopes.
            const Text('Authorization needed to read your contacts.'),
            ElevatedButton(
              onPressed: () => _handleAuthorizeScopes(user),
              child: const Text('REQUEST PERMISSIONS'),
            ),
          ],
        ] else ...<Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            onPressed: _handleSignIn,
            child: const Text('SIGN IN'),
          ),
        ],
        if (_errorMessage.isNotEmpty) Text(_errorMessage),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign In')),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
    );
  }
}
