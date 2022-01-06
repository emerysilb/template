import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:template/auth/auth_service.dart';
import 'package:template/auth/cubit/authswitch_cubit.dart';
import 'package:template/auth/loading_dialog.dart';
import 'package:template/models/user.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupFormBloc(),
      child: Builder(builder: (context) {
        final loginFormBloc = context.read<SignupFormBloc>();
        return Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Sign Up'),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: SingleChildScrollView(
              child: FormBlocListener<SignupFormBloc, String, String>(
                  onSubmitting: (context, state) {
                    // print('Loading');
                    LoadingDialog.show(context);
                  },
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);
                    Navigator.canPop(context)
                        ? Navigator.pop(context)
                        : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Signed In!")));
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.failureResponse ?? "")));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Container(
                              width: 150,
                              height: 150,
                              child: Image.asset('assets/app_icon.png')),
                        ),
                        // Username
                        TextFieldBlocBuilder(
                          textFieldBloc: loginFormBloc.username,
                          autofillHints: [
                            AutofillHints.username,
                          ],
                          suffixButton: SuffixButton.asyncValidating,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
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
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 25,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<AuthswitchCubit>().ShowLogin();
                            },
                            child: Text("Already have an account?"),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        );
      }),
    );
  }
}

class SignupFormBloc extends FormBloc<String, String> {
  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      _min4Char,
    ],
    asyncValidatorDebounceTime: Duration(milliseconds: 300),
  );
  AuthService _authService = AuthService();

  SignupFormBloc() {
    addFieldBlocs(fieldBlocs: [
      username,
      email,
      password,
    ]);
    username.addAsyncValidators([_checkUsername]);
  }

  @override
  void onSubmitting() async {
    print(email.value);
    print(password.value);
    // print(showSuccessResponse.value);
    // AuthService _authService = AuthService();
    try {
      UserAccount userAccount = await _authService.SignUp(
          username.value, email.value, password.value);
      if (userAccount.uid.isNotEmpty) {
        emitSuccess();
      } else {
        emitFailure(failureResponse: 'Sorry we had trouble signing you up');
      }
    } catch (e) {
      emitFailure(failureResponse: 'Sorry we had trouble signing you up');
    }
  }

  // final username = TextFieldBloc(
  //   name: 'Username',
  //   validators: [
  //     FieldBlocValidators.required,
  //     _min4Char,
  //   ],
  //   asyncValidatorDebounceTime: Duration(milliseconds: 300),
  // );
  // AsyncFieldValidationFormBloc() {
  //   username.addAsyncValidators([_checkUsername]);
  //   // addFieldBlocs(fieldBlocs: [username]);
  // }

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

  static String? _min4Char(String username) {
    if (username.length < 4) {
      return 'The username must have at least 4 characters';
    }
    return null;
  }

  Future<String?> _checkUsername(String username) async {
    List<String> usernames = [];
    // usernames = await _authService.GetUsernames();
    if (usernames.length == 0) {
      try {
        List<String> users = await _authService.GetUsernames();
        users.forEach((e) {
          usernames.add(e.toLowerCase());
        });
      } catch (e) {
        return null;
      }
    }
    try {
      if (usernames.contains(username.toLowerCase())) {
        return 'That username is taken.';
      } else {
        return null;
      }

      // print(usernames);
      // if (usernames.contains(username)) {
      //   return 'That username is already taken';
      // }
    } catch (e) {
      return Future.error('Trouble getting usernames');
    }
    // } else {
    //   // await Future.delayed(Duration(milliseconds: 500));
    //   return null;
    // }
  }
}
