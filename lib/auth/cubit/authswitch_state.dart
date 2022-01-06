part of 'authswitch_cubit.dart';

@immutable
abstract class AuthswitchState {}

class AuthswitchInitial extends AuthswitchState {}

class AuthShowLogin extends AuthswitchState {}

class AuthShowSignUp extends AuthswitchState {}

class AuthShowReset extends AuthswitchState {}
