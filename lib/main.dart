import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:template/auth/bloc/auth_bloc.dart';
import 'package:template/auth/cubit/authswitch_cubit.dart';
import 'package:template/bloc_observer.dart';
import 'auth/auth_switch.dart';
import 'auth/reset_pass_page.dart';
import 'auth/sign_in_page.dart';
import 'auth/sign_up_page.dart';
import 'homepage/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory(),
    );
    await Firebase.initializeApp();
    //   HydratedBlocOverrides.runZoned(
    //   () =>
    //   storage: storage,
    // );
    HydratedBlocOverrides.runZoned(
      () => runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthBloc()..add(AuthInit())),
            BlocProvider(create: (context) => AuthswitchCubit()),
          ],
          child: const MyApp(),
        ),
      ),
      blocObserver: SimpleBlocObserver(),
      storage: storage,
    );
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color(0xff022B3A),
          secondary: Color(0xff1F7A8C),
          // tertiary: Colors.indigo[200],
        ),
        brightness: Brightness.light,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Color(0xff1F7A8C),
          secondary: Color(0xff1F7A8C),
        ),
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
      routes: {
        'home': (_) => MyHomePage(),
        'signin': (_) => SignInPage(),
        'signup': (_) => SignupPage(),
        'forgotpass': (_) => ResetPassPage(),
        'auth': (_) => AuthSwitch(),
      },
    );
  }
}
