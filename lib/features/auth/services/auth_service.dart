import 'package:expense/core/utils/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current User
  User? get currentUser => _auth.currentUser;

  // Sign Up with Email & Password
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Attempting sign up with email: $email');
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'SignUp Error: ${e.code} - ${e.message}',
        e,
        e.stackTrace,
      );
      throw _handleAuthException(e);
    } catch (e, stack) {
      AppLogger.error('Unknown SignUp Error', e, stack);
      throw 'An unknown error occurred';
    }
  }

  // Sign In with Email & Password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Attempting sign in with email: $email');
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'SignIn Error: ${e.code} - ${e.message}',
        e,
        e.stackTrace,
      );
      throw _handleAuthException(e);
    } catch (e, stack) {
      AppLogger.error('Unknown SignIn Error', e, stack);
      throw 'An unknown error occurred';
    }
  }

  // Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      AppLogger.info('Sending password reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'Reset Password Error: ${e.code} - ${e.message}',
        e,
        e.stackTrace,
      );
      throw _handleAuthException(e);
    } catch (e, stack) {
      AppLogger.error('Unknown Reset Password Error', e, stack);
      throw 'An unknown error occurred';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      AppLogger.info('Signing out');
      await _auth.signOut();
    } catch (e, stack) {
      AppLogger.error('SignOut Error', e, stack);
    }
  }

  // Helper to parse Firebase Exceptions
  String _handleAuthException(FirebaseAuthException e) {
    AppLogger.warning('Handling Auth Exception: ${e.code}');
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
