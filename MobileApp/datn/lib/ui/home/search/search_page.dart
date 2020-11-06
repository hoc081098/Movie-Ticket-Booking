import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/home/search';

  final String query;

  const SearchPage({Key key, @required this.query}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.query),
      ),
    );
  }
}
