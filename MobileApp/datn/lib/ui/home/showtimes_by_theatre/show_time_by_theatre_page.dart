import 'package:flutter/material.dart';

import '../../../domain/model/theatre.dart';
import '../../../generated/l10n.dart';
import '../detail/movie_detail_page.dart';
import 'show_times_page.dart';
import 'theatre_info_page.dart';

class ShowTimesByTheatrePage extends StatefulWidget {
  static const routeName = '/home/show_time_by_theatre';

  final Theatre theatre;

  const ShowTimesByTheatrePage({Key? key, required this.theatre})
      : super(key: key);

  @override
  _ShowTimesByTheatrePageState createState() => _ShowTimesByTheatrePageState();
}

class _ShowTimesByTheatrePageState extends State<ShowTimesByTheatrePage> {
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = <Widget>[
      ShowTimesPage(theatre: widget.theatre),
      TheatreInfoPage(theatre: widget.theatre),
    ];
  }

  @override
  void didUpdateWidget(covariant ShowTimesByTheatrePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.theatre != widget.theatre) {
      pages = <Widget>[
        ShowTimesPage(theatre: widget.theatre),
        TheatreInfoPage(theatre: widget.theatre),
      ];
    }
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
      length: pages.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottom: CustomTabBar(tabBar: tabBar),
          title: Text(
            widget.theatre.name,
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
