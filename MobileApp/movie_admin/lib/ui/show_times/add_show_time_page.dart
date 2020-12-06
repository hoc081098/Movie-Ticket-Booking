import 'package:flutter/material.dart';
import 'package:movie_admin/domain/model/movie.dart';
import 'package:movie_admin/domain/model/theatre.dart';

class AppShowTimePage extends StatefulWidget {
  static const routeName = '/show-times/add';

  final Theatre theatre;
  final Movie movie;

  const AppShowTimePage({Key key, @required this.theatre, @required this.movie})
      : super(key: key);

  @override
  _AppShowTimePageState createState() => _AppShowTimePageState();
}

class _AppShowTimePageState extends State<AppShowTimePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
