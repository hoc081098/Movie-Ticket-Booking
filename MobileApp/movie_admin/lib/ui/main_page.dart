import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:movie_admin/domain/repository/manager_repository.dart';
import 'package:movie_admin/ui/users/manager_users_bloc.dart';
import 'package:movie_admin/ui/users/manager_users_page.dart';

import '../domain/model/user.dart';
import '../domain/repository/user_repository.dart';
import '../utils/optional.dart';
import 'app_scaffold.dart';
import 'home/home_page.dart';
import 'login/login_page.dart';
import 'login_update_profile/login_update_profile_page.dart';
import 'profile/profile_page.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with DisposeBagMixin {
  static final homeRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) => HomePage(),
    ManagerUsersPage.routeName: (context, setting) {
      final managerRepository = Provider.of<ManagerRepository>(context);
      return BlocProvider<ManagerUsersBloc>(
        child: ManagerUsersPage(),
        initBloc: () => ManagerUsersBloc(managerRepository),
      );
    }
  };

  static final profileRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) => ProfilePage(),
    UpdateProfilePage.routeName: (context, settings) {
      final args = settings.arguments;
      assert(args != null && args is User);
      return UpdateProfilePage(user: args);
    },
  };

  dynamic listenToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listenToken ??= Provider.of<UserRepository>(context)
        .user$
        .where((userOptional) => userOptional != null && userOptional is None)
        .listen((event) => Navigator.of(context).pushNamedAndRemoveUntil(
              LoginPage.routeName,
              (route) => false,
            ))
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      builders: [
        (context, settings) => homeRoutes[settings.name](context, settings),
        (context, settings) => profileRoutes[settings.name](context, settings),
      ],
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
