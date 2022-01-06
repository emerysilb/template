part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoggedIn extends AuthState {
  final UserAccount user;
  AuthLoggedIn({
    required this.user,
  });
}

class AuthSignedOut extends AuthState {}

class AuthLoading extends AuthState {}
