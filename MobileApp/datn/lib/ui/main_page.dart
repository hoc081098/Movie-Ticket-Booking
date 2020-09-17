import 'package:datn/ui/home/home_page.dart';
import 'package:datn/ui/profile/profile_page.dart';
import 'package:flutter/material.dart';

import 'app_scaffold.dart';

class MainPage extends StatelessWidget {
  static const routeName = '/main';

  static final homeRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) => HomePage(),
  };

  static final profileRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) => ProfilePage(),
  };

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
