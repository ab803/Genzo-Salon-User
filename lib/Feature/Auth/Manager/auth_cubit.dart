import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userbarber/Feature/Auth/AuthRepo.dart';
import 'package:userbarber/core/Models/AuthUser.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  /// Save credentials locally
  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
    await prefs.setString("password", password);
  }

  /// Clear credentials from local storage
  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("email");
    await prefs.remove("password");
  }

  /// Get credentials
  Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");
    final password = prefs.getString("password");
    if (email != null && password != null) {
      return {"email": email, "password": password};
    }
    return null;
  }

  /// 🔹 Sign Up
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    int? phoneNumber,
  }) async {
    try {
      emit(AuthLoading());
      final user = await _authRepository.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber ?? 0,
      );
      if (user != null) {
        await _saveCredentials(email, password); // save locally
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError("Sign up failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// 🔹 Sign In
  Future<void> signIn({
    required String email,
    required String password,
    bool saveCredentials = true,
  }) async {
    try {
      emit(AuthLoading());
      final firebaseUser = await _authRepository.signIn(
        email: email,
        password: password,
      );

      if (firebaseUser != null) {
        final profile =
        await _authRepository.getUserProfile(firebaseUser.uid);
        if (profile != null) {
          if (saveCredentials) {
            await _saveCredentials(email, password);
          }
          emit(AuthAuthenticated(profile));
        } else {
          emit(AuthError("User profile not found"));
        }
      } else {
        emit(AuthError("Sign in failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// 🔹 Auto Sign In (using saved credentials)
  Future<void> autoSignIn() async {
    final creds = await getSavedCredentials();
    if (creds != null) {
      await signIn(
        email: creds["email"]!,
        password: creds["password"]!,
        saveCredentials: false,
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// 🔹 Reset Password
  Future<void> resetPassword(String email) async {
    try {
      emit(AuthLoading());
      await _authRepository.resetPassword(email);
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// 🔹 Sign Out
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      await _clearCredentials();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// 🔹 Load Current User (from Firebase session or saved credentials)
  Future<void> loadCurrentUser() async {
    try {
      final currentUser = _authRepository.currentUser;
      if (currentUser != null) {
        final profile = await _authRepository.getUserProfile(currentUser.uid);
        if (profile != null) {
          emit(AuthAuthenticated(profile));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        // try auto login if firebase session is empty
        await autoSignIn();
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// 🔹 Explicitly Get User Profile (for drawer refresh, etc.)
  Future<void> getUserProfile(String uid) async {
    try {
      emit(AuthLoading());
      final profile = await _authRepository.getUserProfile(uid);
      if (profile != null) {
        emit(AuthAuthenticated(profile));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
