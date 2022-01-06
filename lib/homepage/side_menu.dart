import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:template/auth/auth_service.dart';

import 'dart:io' show Platform;

import 'package:template/auth/bloc/auth_bloc.dart';
import 'package:template/auth/cubit/authswitch_cubit.dart';

Widget homeDrawer(BuildContext context) => Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Builder(
                  builder: (context) {
                    if (authState is AuthLoggedIn) {
                      return AutoSizeText(
                        'Welcome ' + authState.user.username,
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Theme.of(context).canvasColor),
                        maxLines: 2,
                      );
                    } else {
                      return Text(
                        'Template',
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Theme.of(context).brightness ==
                                    Brightness.light
                                ? Theme.of(context).canvasColor
                                : Theme.of(context).textTheme.headline3?.color),
                      );
                    }
                  },
                ),
              ),
              Builder(builder: (context) {
                if (authState is AuthLoggedIn) {
                  return ListTile(
                    leading: Icon(Icons.logout),
                    title: const Text('Sign Out'),
                    onTap: () async {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Sign Out'),
                              content: Text(
                                  'Hey, just want to double check that you want to sign out.'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    AuthService authService = AuthService();
                                    authService.Signout();

                                    Navigator.pop(context);
                                  },
                                  child: Text('Sign Out'),
                                )
                              ],
                            );
                          });
                    },
                  );
                } else {
                  return ListTile(
                    title: const Text('Log In'),
                    leading: Icon(Icons.login),
                    onTap: () async {
                      context.read<AuthswitchCubit>().ShowSignUp();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'auth');
                    },
                  );
                }
              }),
            ],
          );
        },
      ),
    );
