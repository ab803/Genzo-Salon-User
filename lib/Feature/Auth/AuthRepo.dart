import 'package:firebase_auth/firebase_auth.dart';
import 'package:userbarber/core/Models/AuthUser.dart';
import 'package:userbarber/core/Services/AuthService.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  /// Sign up and return AuthUser
  Future<AuthUser?> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required int phoneNumber,
  }) async {
    return await _authService.signUp(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
  }

  /// Sign in (returns Firebase User)
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    return await _authService.signIn(
      email: email,
      password: password,
    );
  }

  /// Get Firestore user profile
  Future<AuthUser?> getUserProfile(String uid) async {
    return await _authService.getUserProfile(uid);
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("No user found for this email");
      } else if (e.code == 'invalid-email') {
        throw Exception("Invalid email address");
      } else {
        throw Exception("Failed to send reset email: ${e.message}");
      }
    }
  }
  /// Sign out
  Future<void> signOut() async {
    await _authService.signOut();
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    await _authService.updatePassword(newPassword);
  }


  /// Current Firebase user
  User? get currentUser => _authService.currentUser;
}
