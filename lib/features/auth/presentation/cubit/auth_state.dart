import 'package:furrpal/features/auth/domain/entities/user/user_entity.dart';

abstract class AuthState {}

//initial state
class AuthInitial extends AuthState {}

//loading state
class AuthLoading extends AuthState {}

//authenticated
class Authenticated extends AuthState {
  final UserEntity user;
  Authenticated(this.user);
}

//unauthenticated
class UnAuthenticated extends AuthState {}

//error state
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
