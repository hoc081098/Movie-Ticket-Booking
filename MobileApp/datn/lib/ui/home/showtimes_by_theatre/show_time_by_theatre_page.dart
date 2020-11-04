import 'package:datn/domain/repository/movie_repository.dart';
import 'package:datn/ui/home/detail/movie_detail_page.dart';
import 'package:datn/utils/streams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';

import '../../../domain/model/theatre.dart';

class ShowTimesByTheatrePage extends StatefulWidget {
  static const routeName = '/home/show_time_by_theatre';

  final Theatre theatre;

  const ShowTimesByTheatrePage({Key key, @required this.theatre})
      : super(key: key);

  @override
  _ShowTimesByTheatrePageState createState() => _ShowTimesByTheatrePageState();
}

class _ShowTimesByTheatrePageState extends State<ShowTimesByTheatrePage> {
  List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = <Widget>[
      Container(
        color: Colors.red,
      ),
      Container(
        color: Colors.green,
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<MovieRepository>(context)
        .getShowTimesByTheatreId(widget.theatre.id)
        .debug('<3')
        .listen(null);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final tabBar = TabBar(
      tabs: [
        Tab(
          text: 'Showtimes',
          iconMargin: const EdgeInsets.only(bottom: 8),
        ),
        Tab(
          text: 'Information',
          iconMargin: const EdgeInsets.only(bottom: 8),
        ),
      ],
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2, color: primaryColor),
      ),
      labelColor: primaryColor,
      unselectedLabelStyle: Theme.of(context).textTheme.caption.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
      labelStyle: Theme.of(context).textTheme.caption.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
      unselectedLabelColor: const Color(0xff4A4B57),
    );

    return DefaultTabController(
      length: pages.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottom: CustomTabBar(tabBar: tabBar),
          title: Text(
            widget.theatre.name,
            style: Theme.of(context).textTheme.headline6.copyWith(
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
