import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/model/reservation.dart';
import '../../../domain/model/ticket.dart';
import '../../../generated/l10n.dart';
import '../../app_scaffold.dart';
import '../../home/checkout/widgets/header.dart';
import '../reservation_detail/reservation_detail_page.dart';

class ReservationListItem extends StatelessWidget {
  final Reservation item;
  final DateFormat dateFormat;
  final NumberFormat currencyFormat;

  const ReservationListItem({
    Key? key,
    required this.item,
    required this.dateFormat,
    required this.currencyFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showTime = item.showTime;
    final promotion = item.promotion;

    final textTheme = Theme.of(context).textTheme;
    final textStyle = textTheme.subtitle1!.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: const Color(0xff98A8BA),
    );

    final textStyle2 = textTheme.subtitle1!.copyWith(
      fontSize: 14,
      color: const Color(0xff687189),
      fontWeight: FontWeight.w600,
    );

    return InkWell(
      onTap: () => AppScaffold.navigatorOfCurrentIndex(context).pushNamedX(
        ReservationDetailPage.routeName,
        arguments: item,
      ),
      child: HeaderWidget(
        movie: showTime!.movie!,
        showTime: showTime,
        theatre: showTime.theatre!,
        tickets: item.tickets ?? BuiltList.of(<Ticket>[]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(),
            const SizedBox(height: 4),
            if (promotion != null) ...[
              RichText(
                text: TextSpan(
                  text: S.of(context).couponCode,
                  style: textStyle,
                  children: [
                    TextSpan(
                      text: promotion.code.length > 24
                          ? promotion.code.substring(0, 24) + '...'
                          : promotion.code,
                      style: textStyle2,
                    ),
                  ],
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  text: S.of(context).discount,
                  style: textStyle,
                  children: [
                    TextSpan(
                      text: '${(promotion.discount * 100).toInt()} %',
                      style: textStyle2,
                    ),
                  ],
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
            ],
            RichText(
              text: TextSpan(
                text: S.of(context).originalPrice,
                style: textStyle,
                children: [
                  TextSpan(
                    text: currencyFormat.format(item.originalPrice) + ' VND',
                    style: textStyle2,
                  ),
                ],
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: S.of(context).totalPrice,
                style: textStyle,
                children: [
                  TextSpan(
                    text: currencyFormat.format(item.totalPrice) + ' VND',
                    style: textStyle2,
                  ),
                ],
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
