import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_models.dart';

class GoogleAuth {
  static const _apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const _appId = String.fromEnvironment('FIREBASE_APP_ID');
  static const _senderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const _webClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
  static const provider = 'Google via Firebase';

  bool get isConfigured =>
      _apiKey.isNotEmpty &&
      _appId.isNotEmpty &&
      _senderId.isNotEmpty &&
      _projectId.isNotEmpty &&
      _webClientId.isNotEmpty;

  Future<void>? _initialization;

  Future<void> _initialize() => _initialization ??= _initializeFirebase();

  Future<void> _initializeFirebase() async {
    if (!isConfigured) {
      throw const AuthFailure('Firebase configuration is missing.');
    }
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: _apiKey,
          appId: _appId,
          messagingSenderId: _senderId,
          projectId: _projectId,
        ),
      );
    }
    await GoogleSignIn.instance.initialize(serverClientId: _webClientId);
  }

  AuthProfile _profile(User user) => AuthProfile(
    name: user.displayName ?? user.email ?? 'Google account',
    email: user.email ?? '',
    provider: provider,
  );

  Future<AuthProfile> signIn() async {
    await _initialize();
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final token = account.authentication.idToken;
      if (token == null) {
        throw const AuthFailure('Google did not return an ID token.');
      }
      final credential = GoogleAuthProvider.credential(idToken: token);
      final result = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = result.user;
      if (user == null) {
        throw const AuthFailure('Firebase did not return a user profile.');
      }
      return _profile(user);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthFailure('Google sign-in was canceled.');
      }
      throw const AuthFailure(
        'Google sign-in failed. Check the Firebase setup and try again.',
      );
    } on FirebaseAuthException {
      throw const AuthFailure(
        'Firebase could not authenticate this Google account.',
      );
    }
  }

  Future<AuthProfile?> restore() async {
    if (!isConfigured) return null;
    await _initialize();
    final user = await FirebaseAuth.instance.authStateChanges().first;
    return user == null ? null : _profile(user);
  }

  Future<void> signOut() async {
    await _initialize();
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
  }
}
