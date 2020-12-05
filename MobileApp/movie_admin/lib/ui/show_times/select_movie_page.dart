import 'package:flutter/material.dart';

import '../../domain/model/theatre.dart';

class SelectMoviePage extends StatefulWidget {
  static const routeName = '/home/show-times/select-movie';

  final Theatre theatre;

  const SelectMoviePage({Key key, this.theatre}) : super(key: key);

  @override
  _SelectMoviePageState createState() => _SelectMoviePageState();
}

class _SelectMoviePageState extends State<SelectMoviePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
