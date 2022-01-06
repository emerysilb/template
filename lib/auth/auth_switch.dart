import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:template/auth/cubit/authswitch_cubit.dart';
import 'package:template/auth/reset_pass_page.dart';
import 'package:template/auth/sign_in_page.dart';
import 'package:template/auth/sign_up_page.dart';

class AuthSwitch extends StatelessWidget {
  const AuthSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthswitchCubit, AuthswitchState>(
      builder: (context, state) {
        if (state is AuthShowLogin) {
          return SignInPage();
        } else if (state is AuthShowSignUp) {
          return SignupPage();
        } else if (state is AuthShowReset) {
          return ResetPassPage();
        } else {
          return SignupPage();
        }
      },
    );
  }
}
