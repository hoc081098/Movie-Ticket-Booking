import 'package:datn/domain/repository/user_repository.dart';
import 'package:datn/ui/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_provider/flutter_provider.dart';

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
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<bool> checkAuthFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkAuthFuture ??= Provider.of<UserRepository>(context).checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    final routes = Provider.of<Map<String, WidgetBuilder>>(context);

    return FutureBuilder<bool>(
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

        return snapshot.data
            ? routes[HomePage.routeName](context)
            : routes[LoginPage.routeName](context);
      },
    );
  }
}
