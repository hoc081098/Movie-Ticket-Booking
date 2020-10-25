import 'package:built_collection/built_collection.dart';
import 'package:datn/domain/model/ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final dateFormat = DateFormat('dd MMM, yyyy');
  final timeFormat = DateFormat('hh:mm a');

  @override
  Widget build(BuildContext context) {
    final reservation = widget.reservation;

    final showTime = reservation.showTime;
    final movie = showTime.movie;
    final theatre = showTime.theatre;
    final tickets = reservation.tickets ?? BuiltList.of(<Ticket>[]);

    final seatSize =
        (MediaQuery.of(context).size.width - 24 * 2 - 16 * 2 - 7 * 4) / 8;
    final accentColor = Theme.of(context).accentColor;
    final seatStyle = Theme.of(context).textTheme.caption.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('My ticket'),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xffB881F9),
              Color(0xff545AE9),
            ],
            begin: AlignmentDirectional.topEnd,
            end: AlignmentDirectional.bottomStart,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Spacer(),
                  Text(
                    'Tickets',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: const Color(0xff687189),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: const Color(0xff687189),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (reservation.tickets?.length ?? 0).toString(),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: const Color(0xff687189),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Title',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontSize: 15,
                      color: const Color(0xff687189),
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headline4.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff687189),
                    ),
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: InfoWidget(
                      title: 'Date',
                      subtitle: dateFormat.format(showTime.start_time),
                    ),
                    flex: 3,
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: InfoWidget(
                      title: 'Time',
                      subtitle: timeFormat.format(showTime.start_time),
                    ),
                    flex: 3,
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: InfoWidget(
                      title: 'Room',
                      subtitle: showTime.room,
                    ),
                    flex: 2,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: InfoWidget(
                      title: 'Theatre',
                      subtitle: theatre.name,
                    ),
                    flex: 3,
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: InfoWidget(
                      title: 'Address',
                      subtitle: theatre.address,
                    ),
                    flex: 5,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: InfoWidget(
                      title: 'Order ID',
                      subtitle: '#${reservation.id}',
                    ),
                    flex: 1,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                runSpacing: 4,
                children: tickets.map((t) {
                  final seat = t.seat;

                  return Container(
                    width: seatSize,
                    height: seatSize,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        '${seat.row}${seat.column}',
                        style: seatStyle,
                      ),
                    ),
                  );
                }).toList(growable: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const InfoWidget({
    Key key,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xff8690A0),
              ),
          maxLines: 2,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xff687189),
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
