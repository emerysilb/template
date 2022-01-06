import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:template/auth/auth_service.dart';
import 'package:template/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    AuthService _authService = AuthService();
    _authService.AuthStream().listen((event) {
      if (event != null) {
        add(AuthSignedIn(user: event));
      } else {
        add(AuthLoggedOut());
      }
    });
    on<AuthSignedIn>((event, emit) async {
      emit(AuthLoading());
      UserAccount? userAccount = await _authService.getCurrentUser();
      if (userAccount != null) {
        FirebaseAnalytics.instance.logEvent(name: 'Logged In');
        emit(
          AuthLoggedIn(
            user: userAccount,
          ),
        );
      } else {
        emit(AuthSignedOut());
      }
    });
    on<AuthLoggedOut>((event, emit) {
      FirebaseAnalytics.instance.logEvent(name: 'Logged Out');
      emit(AuthSignedOut());
    });
    on<AuthInit>((event, emit) async {
      UserAccount? userAccount = await _authService.getCurrentUser();
      if (userAccount != null) {
        emit(
          AuthLoggedIn(
            user: userAccount,
          ),
        );
      } else {
        emit(AuthSignedOut());
      }
    });
  }
}
