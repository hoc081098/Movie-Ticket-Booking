import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';

import '../../../domain/repository/reservation_repository.dart';
import '../../../utils/streams.dart';

class ReservationsPage extends StatefulWidget {
  static const routeName = '/profile/reservations';

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<ReservationRepository>(context)
        .getReservation(
          page: 1,
          perPage: 16,
        )
        .debug('RESERVATIONS')
        .listen(null);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
