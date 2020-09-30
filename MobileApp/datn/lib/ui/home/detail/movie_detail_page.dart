import 'package:flutter/material.dart';

import '../../../domain/model/movie.dart';
import 'comments/comments_page.dart';
import 'info/movie_info_page.dart';
import 'show_times_page.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/home/detail';

  final Movie movie;

  const MovieDetailPage({
    Key key,
    @required this.movie,
  }) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  List<Widget> pages;

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.date_range),
              ),
              Tab(
                icon: Icon(Icons.comment),
              ),
              Tab(
                icon: Icon(Icons.info_outlined),
              ),
            ],
          ),
          title: Text(
            widget.movie.title,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                ),
          ),
        ),
        body: TabBarView(children: pages),
      ),
    );
  }
}
