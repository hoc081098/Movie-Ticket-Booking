import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/model/movie.dart';
import '../../../../domain/model/show_time.dart';
import '../../../../domain/model/theatre.dart';
import '../../../../domain/model/ticket.dart';
import '../../../../generated/l10n.dart';
import '../../../widgets/age_type.dart';

class HeaderWidget extends StatelessWidget {
  final startTimeFormat = DateFormat('dd/MM/yy, EEE, hh:mm a');

  final Movie movie;
  final ShowTime showTime;
  final Theatre theatre;
  final BuiltList<Ticket> tickets;
  final Widget? child;

  HeaderWidget({
    Key? key,
    required this.movie,
    required this.showTime,
    required this.theatre,
    required this.tickets,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const h = 128.0;
    const w = h / 1.3;

    final textTheme = Theme.of(context).textTheme;
    final textStyle = textTheme.subtitle1!.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: const Color(0xff98A8BA),
    );

    final textStyle2 = textTheme.subtitle1!.copyWith(
      fontSize: 16,
      color: const Color(0xff687189),
      fontWeight: FontWeight.w600,
    );

    final movieTitleStyle = textTheme.headline4!.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: const Color(0xff687189),
    );

    final accentColor = Theme.of(context).accentColor;

    final seatStyle = Theme.of(context).textTheme.caption!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        );

    final seatSize = (MediaQuery.of(context).size.width - 16 - 9 * 8) / 8;

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      movie.title,
                      style: movieTitleStyle,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        AgeTypeWidget(ageType: movie.ageType),
                        const SizedBox(width: 8),
                        Text(S.of(context).duration_minutes(movie.duration)),
                      ],
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: w,
                  height: h,
                  child: CachedNetworkImage(
                    imageUrl: movie.posterUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (_, __, ___) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.error,
                            color: Theme.of(context).accentColor,
                          ),
                          SizedBox(height: 4),
                          Text(
                            S.of(context).load_image_error,
                            style: textTheme.subtitle2!.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
                text: S.of(context).startAt,
                style: textStyle,
                children: [
                  TextSpan(
                    text: startTimeFormat.format(showTime.start_time),
                    style: textStyle2,
                  ),
                ]),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
                text: S.of(context).theatre,
                style: textStyle,
                children: [
                  TextSpan(
                    text: theatre.name,
                    style: textStyle2,
                  ),
                  TextSpan(
                    text: S.of(context).room,
                    style: textStyle,
                  ),
                  TextSpan(
                    text: showTime.room,
                    style: textStyle2,
                  ),
                ]),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
                text: S.of(context).address + ': ',
                style: textStyle,
                children: [
                  TextSpan(
                    text: theatre.address,
                    style: textStyle2,
                  ),
                ]),
          ),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
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
          if (child != null) ...[
            const SizedBox(height: 6),
            child!,
          ],
        ],
      ),
    );
  }
}
