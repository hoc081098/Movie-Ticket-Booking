import 'package:datn/domain/model/show_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';

import '../domain/model/movie.dart';
import '../domain/model/user.dart';
import '../domain/repository/comment_repository.dart';
import '../domain/repository/user_repository.dart';
import '../utils/optional.dart';
import 'app_scaffold.dart';
import 'home/detail/comments/add_comment/add_commen_page.dart';
import 'home/detail/comments/add_comment/add_comment_bloc.dart';
import 'home/detail/movie_detail_page.dart';
import 'home/home_page.dart';
import 'home/tickets/ticket_page.dart';
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
    MovieDetailPage.routeName: (context, settings) {
      final movie = settings.arguments as Movie;
      return MovieDetailPage(
        movieId: movie.id,
        title: movie.title,
      );
    },
    AddCommentPage.routeName: (context, settings) {
      final repo = Provider.of<CommentRepository>(context);
      final movieId = settings.arguments as String;

      return BlocProvider<AddCommentBloc>(
        child: AddCommentPage(),
        initBloc: () => AddCommentBloc(repo, movieId),
      );
    },
    TicketsPage.routeName: (context, settings) {
      return TicketsPage(
        showTime: settings.arguments as ShowTime,
      );
    },
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
