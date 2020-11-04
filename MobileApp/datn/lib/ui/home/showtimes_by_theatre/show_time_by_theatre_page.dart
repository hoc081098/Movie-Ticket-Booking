import 'package:datn/domain/repository/movie_repository.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.theatre.name),
      ),
    );
  }
}
