import 'package:datn/domain/model/exception.dart';
import 'package:datn/domain/repository/user_repository.dart';
import 'package:datn/ui/login/login_bloc.dart';
import 'package:datn/ui/login_update_profile/login_update_profile_page.dart';
import 'package:datn/ui/register/register_page.dart';
import 'package:datn/ui/reset_password/reset_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:tuple/tuple.dart';

import 'ui/home/home_page.dart';
import 'ui/login/login_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routes = <String, WidgetBuilder>{
      HomePage.routeName: (context) => HomePage(),
      LoginPage.routeName: (context) {
        return BlocProvider<LoginBloc>(
          child: LoginPage(),
          initBloc: () {
            final userRepository = Provider.of<UserRepository>(context);
            return LoginBloc(userRepository);
          },
        );
      },
      RegisterPage.routeName: (context) => RegisterPage(),
      LoginUpdateProfilePage.routeName: (context) => LoginUpdateProfilePage(),
      ResetPasswordPage.routeName: (context) => ResetPasswordPage(),
    };

    final themeData = ThemeData(
      primaryColor: const Color(0xff7a69ef),
      primaryColorDark: const Color(0xff5353cf),
      accentColor: const Color(0xff02a3f7),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return Provider<Map<String, WidgetBuilder>>(
      value: routes,
      child: MaterialApp(
        title: 'Movie ticket',
        theme: themeData,
        home: SplashPage(),
        routes: routes,
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<Tuple2<bool, NotCompletedLoginException>> checkAuthFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkAuthFuture ??= Provider.of<UserRepository>(context).checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    final routes = Provider.of<Map<String, WidgetBuilder>>(context);

    return FutureBuilder<Tuple2<bool, NotCompletedLoginException>>(
      future: checkAuthFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return routes[HomePage.routeName](context);
        }

        if (!snapshot.hasData) {
          return Container(
            width: double.infinity,
            height: double.infinity,
          );
        }

        final data = snapshot.data;
        if (data.item1) {
          return routes[HomePage.routeName](context);
        }

        return data.item2 != null
            ? routes[LoginUpdateProfilePage.routeName](context)
            : routes[LoginPage.routeName](context);
      },
    );
  }
}
