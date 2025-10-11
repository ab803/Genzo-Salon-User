import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:userbarber/core/Models/AuthUser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  /// Sign up with email & password + extra fields
  Future<AuthUser?> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required int phoneNumber,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = userCredential.user;
    if (user != null) {
      final authUser = AuthUser(
        uid: user.uid,
        email: email.trim(),
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );

      await _db.collection("users").doc(user.uid).set(authUser.toMap());
      return authUser;
    }
    return null;
  }

  /// Sign in
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return userCredential.user;
  }

  /// Update current user's password
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw Exception("No user is currently signed in.");
    }
  }

  /// Forgot password
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Fetch profile from Firestore
  Future<AuthUser?> getUserProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    if (doc.exists) {
      return AuthUser.fromMap(doc.id, doc.data()!);
    }
    return null;
  }
}
