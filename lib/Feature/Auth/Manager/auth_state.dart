import 'package:equatable/equatable.dart';
import 'package:userbarber/core/Models/AuthUser.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial
class AuthInitial extends AuthState {}

/// Loading
class AuthLoading extends AuthState {}

/// Authenticated
class AuthAuthenticated extends AuthState {
  final AuthUser user;

  AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated
class AuthUnauthenticated extends AuthState {}

/// Error
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
