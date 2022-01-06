import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:template/auth/auth_service.dart';
import 'package:template/auth/cubit/authswitch_cubit.dart';
import 'package:template/auth/loading_dialog.dart';
import 'package:template/models/user.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginFormBloc(),
      child: Builder(builder: (context) {
        final loginFormBloc = context.read<LoginFormBloc>();
        return Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Sign In'),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: FormBlocListener<LoginFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);
                  Navigator.canPop(context)
                      ? Navigator.pop(context)
                      : ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Signed In!")));
                },
                onFailure: (context, state) {
                  print('Failure');
                  LoadingDialog.hide(context);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.failureResponse.toString())));
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Container(
                            width: 150,
                            height: 150,
                            child: Image.asset('assets/images/app_icon.png'),
                          ),
                        ),
                        //Email
                        TextFieldBlocBuilder(
                          textFieldBloc: loginFormBloc.email,
                          autofillHints: [
                            AutofillHints.email,
                            AutofillHints.username,
                          ],
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                        ),

                        //Password
                        TextFieldBlocBuilder(
                          textFieldBloc: loginFormBloc.password,
                          autofillHints: [AutofillHints.password],
                          suffixButton: SuffixButton.obscureText,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.password),
                            border: OutlineInputBorder(),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: ElevatedButton(
                            onPressed: loginFormBloc.submit,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<AuthswitchCubit>().ShowSignUp();
                            },
                            child: Text("Don't have an account?"),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              context.read<AuthswitchCubit>().ResetPass();
                            },
                            child: Text("Forgot password?")),
                      ],
                    ),
                  ),
                )),
          ),
        );
      }),
    );
  }
}

class LoginFormBloc extends FormBloc<String, String> {
  LoginFormBloc() {
    addFieldBlocs(fieldBlocs: [
      email,
      password,
    ]);
  }

  @override
  void onSubmitting() async {
    print(email.value);
    print(password.value);
    // print(showSuccessResponse.value);
    AuthService _authService = AuthService();
    try {
      UserAccount userAccount = await _authService.SignIn(
          email: email.value, password: password.value);
      if (userAccount.uid.isNotEmpty) {
        emitSuccess();
      } else {
        emitFailure(failureResponse: 'Sorry we had trouble logging you in');
      }
    } catch (e) {
      emitFailure(failureResponse: 'Sorry we had trouble logging you in');
    }

    //   if (showSuccessResponse.value) {
    //     emitSuccess();
    //   } else {
    //     emitFailure(failureResponse: 'This is an awesome error!');
    //   }
  }

  final email = TextFieldBloc(
    name: 'Email',
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );
  final password = TextFieldBloc(
    name: 'Password',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  //
}
