import 'package:flutter/material.dart';

import '../../../domain/model/movie.dart';
import '../../../generated/l10n.dart';
import 'comments/comments_page.dart';
import 'info/movie_info_page.dart';
import 'show_times_page.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/home/detail';

  final Movie movie;

  const MovieDetailPage({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = <Widget>[
      ShowTimesPage(movie: widget.movie),
      CommentsPage(movieId: widget.movie.id),
      MovieInfoPage(movieId: widget.movie.id),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final tabBar = TabBar(
      tabs: [
        Tab(
          text: S.of(context).showTimes,
          iconMargin: const EdgeInsets.only(bottom: 8),
        ),
        Tab(
          text: S.of(context).comments,
          iconMargin: const EdgeInsets.only(bottom: 8),
        ),
        Tab(
          text: S.of(context).information,
          iconMargin: const EdgeInsets.only(bottom: 8),
        ),
      ],
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2, color: primaryColor),
      ),
      labelColor: primaryColor,
      unselectedLabelStyle: Theme.of(context).textTheme.caption!.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
      labelStyle: Theme.of(context).textTheme.caption!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
      unselectedLabelColor: const Color(0xff4A4B57),
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottom: CustomTabBar(tabBar: tabBar),
          title: Text(
            widget.movie.title,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
          ),
        ),
        body: TabBarView(children: pages),
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar tabBar;

  const CustomTabBar({Key? key, required this.tabBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: tabBar.preferredSize.height - 8,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        child: tabBar,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(tabBar.preferredSize.height - 8);
}
