part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthSignedIn extends AuthEvent {
  final User? user;
  AuthSignedIn({
    this.user,
  });
}

class AuthLoggedOut extends AuthEvent {}

class AuthInit extends AuthEvent {}
