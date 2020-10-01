import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import '../../../domain/model/movie.dart';
import '../../../domain/model/show_time.dart';
import '../../../domain/model/theatre.dart';
import '../../../domain/model/ticket.dart';

class ComboPage extends StatefulWidget {
  static const routeName = 'home/detail/tickets/combo';

  final BuiltList<Ticket> tickets;
  final ShowTime showTime;
  final Theatre theatre;
  final Movie movie;

  const ComboPage({
    Key key,
    @required this.tickets,
    @required this.showTime,
    @required this.theatre,
    @required this.movie,
  }) : super(key: key);

  @override
  _ComboPageState createState() => _ComboPageState();
}

class _ComboPageState extends State<ComboPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
