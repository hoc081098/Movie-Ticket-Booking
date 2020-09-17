import 'package:datn/domain/repository/user_repository.dart';
import 'package:datn/ui/home/home_page.dart';
import 'package:datn/ui/login/login_page.dart';
import 'package:datn/ui/profile/edit_profile/edit_profile_page.dart';
import 'package:datn/ui/profile/profile_page.dart';
import 'package:datn/utils/optional.dart';
import 'package:flutter/material.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';

import 'app_scaffold.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with DisposeBagMixin {
  static const routeName = '/main';

  static final homeRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) => HomePage(),
  };

  static final profileRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) => ProfilePage(),
    EditProfilePage.routeName: (context, settings) => EditProfilePage(),
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
              (route) => route.isFirst,
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
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Profile'),
        ),
      ],
    );
  }
}
