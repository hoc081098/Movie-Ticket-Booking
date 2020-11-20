import 'package:flutter/material.dart';

class ShowTimesPage extends StatefulWidget {
  static const routeName = '/home/show-times';

  @override
  _ShowTimesPageState createState() => _ShowTimesPageState();
}

class _ShowTimesPageState extends State<ShowTimesPage> {
  var isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show times'),
      ),
    );
  }
}
