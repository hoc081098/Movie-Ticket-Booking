import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../../../domain/model/movie.dart';
import '../../../domain/model/product.dart';
import '../../../domain/model/show_time.dart';
import '../../../domain/model/theatre.dart';
import '../../../domain/model/ticket.dart';

class CheckoutPage extends StatefulWidget {
  static const routeName = 'home/detail/tickets/combo/checkout';

  final ShowTime showTime;
  final Theatre theatre;
  final Movie movie;
  final BuiltList<Ticket> tickets;
  final BuiltList<Tuple2<Product, int>> products;

  const CheckoutPage({
    Key key,
    @required this.tickets,
    @required this.showTime,
    @required this.theatre,
    @required this.movie,
    @required this.products,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
