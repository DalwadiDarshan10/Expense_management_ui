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

  // Update Display Name
  Future<void> updateDisplayName(String displayName) async {
    try {
      AppLogger.info('Updating display name to: $displayName');
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'Update Display Name Error: ${e.code} - ${e.message}',
        e,
        e.stackTrace,
      );
      throw _handleAuthException(e);
    } catch (e, stack) {
      AppLogger.error('Unknown Update Display Name Error', e, stack);
      throw 'An unknown error occurred';
    }
  }

  // Update Email
  Future<void> updateEmail(String email) async {
    try {
      AppLogger.info('Updating email to: $email');
      await _auth.currentUser?.verifyBeforeUpdateEmail(email);
      await _auth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'Update Email Error: ${e.code} - ${e.message}',
        e,
        e.stackTrace,
      );
      throw _handleAuthException(e);
    } catch (e, stack) {
      AppLogger.error('Unknown Update Email Error', e, stack);
      throw 'An unknown error occurred';
    }
  }

  // Reload User Data
  Future<void> reloadUser() async {
    try {
      AppLogger.info('Reloading user data');
      await _auth.currentUser?.reload();
    } catch (e, stack) {
      AppLogger.error('Reload User Error', e, stack);
    }
  }

  // Change Password with Re-authentication
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      AppLogger.info('Attempting to change password');
      User? user = _auth.currentUser;
      if (user == null) throw 'User not logged in';

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      AppLogger.info('Password changed successfully');
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'Change Password Error: ${e.code} - ${e.message}',
        e,
        e.stackTrace,
      );
      throw _handleAuthException(e);
    } catch (e, stack) {
      AppLogger.error('Unknown Change Password Error', e, stack);
      throw 'An unknown error occurred';
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
      case 'requires-recent-login':
        return 'This operation is sensitive and requires recent authentication. Please log in again.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
