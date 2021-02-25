import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/model/reservation.dart';
import '../../domain/model/ticket.dart';

class ReservationListItem extends StatelessWidget {
  final Reservation item;
  final NumberFormat currencyFormat;
  static final startTimeFormat = DateFormat('dd/MM/yy, EE, hh:mm a');

  const ReservationListItem({Key key, this.item, this.currencyFormat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final promotion = item.promotion;
    final tickets = item.tickets ?? BuiltList.of(<Ticket>[]);

    final textTheme = Theme.of(context).textTheme;
    final textStyle = textTheme.subtitle1.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color(0xff98A8BA),
    );

    final textStyle2 = textTheme.subtitle1.copyWith(
      fontSize: 14,
      color: const Color(0xff687189),
      fontWeight: FontWeight.w600,
    );

    final accentColor = Theme.of(context).accentColor;

    final seatStyle = Theme.of(context).textTheme.caption.copyWith(
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
          RichText(
            text:
                TextSpan(text: 'User full name: ', style: textStyle, children: [
              TextSpan(
                text: item.user?.fullName ?? 'N/A',
                style: textStyle2,
              ),
            ]),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(text: 'User email: ', style: textStyle, children: [
              TextSpan(
                text: item.user?.email ?? 'N/A',
                style: textStyle2,
              ),
            ]),
          ),
          const SizedBox(height: 6),
          const Divider(),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(text: 'Email: ', style: textStyle, children: [
              TextSpan(
                text: item.email,
                style: textStyle2,
              ),
            ]),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(text: 'Phone number: ', style: textStyle, children: [
              TextSpan(
                text: item.phoneNumber,
                style: textStyle2,
              ),
            ]),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(text: 'Booked when: ', style: textStyle, children: [
              TextSpan(
                text: startTimeFormat.format(item.createdAt),
                style: textStyle2,
              ),
            ]),
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 6),
          const Divider(),
          const SizedBox(height: 4),
          if (promotion != null) ...[
            RichText(
              text: TextSpan(
                text: 'Coupon code: ',
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
                text: 'Discount: ',
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
              text: 'Original price: ',
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
              text: 'Total price: ',
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
    );
  }
}
