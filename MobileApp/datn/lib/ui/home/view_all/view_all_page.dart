import 'package:flutter/material.dart';

import '../home_page.dart';

class ViewAllPage extends StatefulWidget {
  static const routeName = '/home/view_all';

  final MovieType movieType;

  const ViewAllPage({Key key, @required this.movieType}) : super(key: key);

  @override
  _ViewAllPageState createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movieType.toString()),
      ),
    );
  }
}
