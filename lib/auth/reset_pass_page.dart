import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:template/auth/auth_service.dart';
import 'package:template/auth/cubit/authswitch_cubit.dart';

class ResetPassPage extends StatelessWidget {
  const ResetPassPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginFormBloc(),
      child: Builder(builder: (context) {
        final loginFormBloc = context.read<LoginFormBloc>();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Reset Password'),
          ),
          body: FormBlocListener<LoginFormBloc, String, String>(
              onSubmitting: (context, state) {
                // LoadingDialog.show(context);
              },
              onSuccess: (context, state) {
                Fluttertoast.showToast(
                    msg:
                        "If you have an account, we've sent you a password reset email.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    // backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Colors.white,
                    fontSize: 16.0);
                context.read<AuthswitchCubit>().ShowLogin();

                // LoadingDialog.hide(context);

                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (_) => SuccessScreen()));
              },
              onFailure: (context, state) {
                Fluttertoast.showToast(
                    msg: "There was an error sending a password reset email.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    // backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Colors.white,
                    fontSize: 16.0);
                // LoadingDialog.hide(context);

                // ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text(state.failureResponse)));
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
                            child: Image.asset('assets/images/app_icon.png')),
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

                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: ElevatedButton(
                          onPressed: loginFormBloc.submit,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<AuthswitchCubit>().ShowSignUp();
                          },
                          child: Text("Don't have an account?"),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      }),
    );
  }
}

class LoginFormBloc extends FormBloc<String, String> {
  LoginFormBloc() {
    addFieldBlocs(fieldBlocs: [
      email,
    ]);
  }

  @override
  void onSubmitting() async {
    print(email.value);
    // print(showSuccessResponse.value);
    AuthService _authService = AuthService();
    try {
      await _authService.resetPassword(email.value);
      emitSuccess();
    } catch (e) {
      emitFailure();
    }

    //   if (showSuccessResponse.value) {
    //     emitSuccess();
    //   } else {
    //     emitFailure(failureResponse: 'This is an awesome error!');
    //   }
  }

  final username = TextFieldBloc(
    name: 'Username',
    validators: [
      FieldBlocValidators.required,
    ],
    asyncValidatorDebounceTime: Duration(milliseconds: 300),
  );

  final email = TextFieldBloc(
    name: 'Email',
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );
}
