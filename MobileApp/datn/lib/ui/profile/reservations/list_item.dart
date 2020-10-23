import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/model/reservation.dart';

class ReservationListItem extends StatelessWidget {
  final Reservation item;
  final DateFormat dateFormat;

  const ReservationListItem({Key key, this.item, this.dateFormat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.showTime.movie.title),
    );
  }
}
