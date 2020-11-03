import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.theatre.name),
      ),
    );
  }
}
