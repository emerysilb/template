import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'authswitch_state.dart';

class AuthswitchCubit extends Cubit<AuthswitchState> {
  AuthswitchCubit() : super(AuthShowLogin());
  ShowLogin() => emit(AuthShowLogin());
  ShowSignUp() => emit(AuthShowSignUp());
  ResetPass() => emit(AuthShowReset());
}
