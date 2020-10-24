import 'package:flutter/material.dart';

import '../../../domain/model/reservation.dart';

class ReservationDetailPage extends StatefulWidget {
  static const routeName = '/profile/reservations/detail';

  final Reservation reservation;

  const ReservationDetailPage({Key key, @required this.reservation})
      : super(key: key);

  @override
  _ReservationDetailPageState createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
