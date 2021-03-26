import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_provider/flutter_provider.dart';

import 'domain/repository/user_repository.dart';
import 'generated/l10n.dart';
import 'locale_bloc.dart';
import 'ui/login/login_bloc.dart';
import 'ui/login/login_page.dart';
import 'ui/login_update_profile/login_update_profile_page.dart';
import 'ui/main_page.dart';
import 'ui/register/register_bloc.dart';
import 'ui/register/register_page.dart';
import 'ui/reset_password/reset_password_bloc.dart';
import 'ui/reset_password/reset_password_page.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void>? cacheImage;

  final routes = <String, WidgetBuilder>{
    MainPage.routeName: (context) => MainPage(),
    LoginPage.routeName: (context) {
      return BlocProvider<LoginBloc>(
        initBloc: (context) => LoginBloc(context.get()),
        child: LoginPage(),
      );
    },
    RegisterPage.routeName: (context) {
      return BlocProvider<RegisterBloc>(
        initBloc: (context) => RegisterBloc(context.get()),
        child: RegisterPage(),
      );
    },
    UpdateProfilePage.routeName: (context) => UpdateProfilePage(user: null),
    ResetPasswordPage.routeName: (context) {
      return BlocProvider<ResetPasswordBloc>(
        initBloc: (context) => ResetPasswordBloc(context.get()),
        child: ResetPasswordPage(),
      );
    },
  };

  final themeData = ThemeData(
    primarySwatch: Colors.purple,
    primaryColor: const Color(0xff7a69ef),
    primaryColorDark: const Color(0xff5353cf),
    accentColor: const Color(0xff02a3f7),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Montserrat',
    brightness: Brightness.light,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    cacheImage ??= Future.wait([
      precacheImage(
        AssetImage('assets/images/splash_bg.png'),
        context,
      ),
      precacheImage(
        AssetImage('assets/images/enjoy.png'),
        context,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final localeBloc = BlocProvider.of<LocaleBloc>(context);

    return Provider<Map<String, WidgetBuilder>>.value(
      routes,
      child: RxStreamBuilder<Locale?>(
        stream: localeBloc.locale$,
        builder: (context, data) {
          print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $data');

          if (data == null) {
            return Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
            );
          }

          return MaterialApp(
            title: 'Movie ticket',
            theme: themeData,
            home: SplashPage(),
            routes: routes,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: data,
          );
        },
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const minSplashDuration = Duration(seconds: 2);
  Future<AuthState>? checkAuthFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    checkAuthFuture ??= () async {
      final stopwatch = Stopwatch()..start();
      final authState = await Provider.of<UserRepository>(context).checkAuth();
      stopwatch.stop();

      final extraDelay = minSplashDuration - stopwatch.elapsed;
      print('>> extraDelay=${extraDelay.inMilliseconds}');
      if (extraDelay > Duration.zero) {
        await Future.delayed(extraDelay);
      }

      return authState;
    }();
  }

  @override
  Widget build(BuildContext context) {
    final routes = Provider.of<Map<String, WidgetBuilder>>(context);
    final textStyle = Theme.of(context).textTheme.headline6!.copyWith(
          fontSize: 18,
          color: Colors.white,
        );

    return FutureBuilder<AuthState>(
      future: checkAuthFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return routes[MainPage.routeName]!(context);
        }

        if (!snapshot.hasData) {
          return Material(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    height: 100,
                    constraints: BoxConstraints.expand(),
                    child: Image.asset(
                      'assets/images/splash_bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          const Color(0xffB881F9).withOpacity(0.6),
                          const Color(0xff545AE9).withOpacity(0.8),
                        ],
                        stops: [0, 0.45],
                        begin: AlignmentDirectional.topEnd,
                        end: AlignmentDirectional.bottomStart,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0, -0.4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset('assets/images/enjoy.png'),
                      const SizedBox(height: 24),
                      Text(
                        'Book your movie ticket anytime,',
                        style: textStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'anywhere with enjoy',
                        style: textStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }

        switch (snapshot.requireData) {
          case AuthState.loggedIn:
            return routes[MainPage.routeName]!(context);
          case AuthState.notLoggedIn:
            return routes[LoginPage.routeName]!(context);
          case AuthState.notCompletedLogin:
            return routes[UpdateProfilePage.routeName]!(context);
        }
      },
    );
  }
}
