import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../../domain/model/reservation.dart';
import '../../../domain/model/ticket.dart';
import '../../../domain/repository/reservation_repository.dart';
import '../../../generated/l10n.dart';
import '../../../utils/error.dart';
import '../../widgets/error_widget.dart';

class ReservationDetailPage extends StatelessWidget {
  static const routeName = '/profile/reservations/detail';

  final Reservation reservation;

  ReservationDetailPage({Key? key, required this.reservation})
      : super(key: key);

  final dateFormat = DateFormat('dd MMM, yyyy');
  final timeFormat = DateFormat('hh:mm a');

  @override
  Widget build(BuildContext context) {
    final showTime = reservation.showTime!;
    final movie = showTime.movie!;
    final theatre = showTime.theatre!;
    final tickets = reservation.tickets ?? BuiltList.of(<Ticket>[]);

    final size = MediaQuery.of(context).size.width - 16 * 2 - 8 * 2;
    final seatSize = (size - 7 * 4) / 8;
    final accentColor = Theme.of(context).accentColor;
    final seatStyle = Theme.of(context).textTheme.caption!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        );

    final repo = Provider.of<ReservationRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myTicket),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Spacer(),
                    Text(
                      S.of(context).tickets,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
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
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
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
                  S.of(context).title,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontSize: 15,
                        color: const Color(0xff687189),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff687189),
                      ),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: InfoWidget(
                        title: S.of(context).date,
                        subtitle: dateFormat.format(showTime.start_time),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: 3,
                      child: InfoWidget(
                        title: S.of(context).time,
                        subtitle: timeFormat.format(showTime.start_time),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: 2,
                      child: InfoWidget(
                        title: S.of(context).myTicket_room,
                        subtitle: showTime.room,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: InfoWidget(
                        title: S.of(context).myTicket_theatre,
                        subtitle: theatre.name,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: 5,
                      child: InfoWidget(
                        title: S.of(context).address + ': ',
                        subtitle: theatre.address,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InfoWidget(
                        title: S.of(context).orderId,
                        subtitle: '#${reservation.id}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                if (reservation.productIdWithCounts.isNotEmpty) ...[
                  buildCombo(context, reservation.productIdWithCounts),
                  const SizedBox(height: 16),
                ],
                const MySeparator(),
                const SizedBox(height: 16),
                LoaderWidget<Uint8List>(
                  blocProvider: () => LoaderBloc<Uint8List>(
                    loaderFunction: () => repo.getQrCode(reservation.id),
                    logger: print,
                  ),
                  builder: (context, state, bloc) {
                    if (state.isLoading) {
                      return Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      );
                    }

                    if (state.error != null) {
                      return Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: MyErrorWidget(
                              errorText: S.of(context).error_with_message(
                                  context.getErrorMessage(state.error!)),
                              onPressed: bloc.fetch,
                            ),
                          ),
                        ),
                      );
                    }

                    final qrCodeSize = size * 0.7;
                    return Center(
                      child: Image.memory(
                        state.content!,
                        width: qrCodeSize,
                        height: qrCodeSize,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: S.of(context).checkYourMail,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff687189),
                        ),
                        children: [
                          TextSpan(
                            text: reservation.email,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xffFF0120),
                            ),
                          ),
                        ],
                      ),
                      maxLines: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCombo(
    BuildContext context,
    BuiltList<ProductAndQuantity> productIdWithCounts,
  ) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');

    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.subtitle2!.copyWith(fontSize: 15);
    final caption = textTheme.caption;
    final countStyle = titleStyle.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
    final priceStyle = textTheme.subtitle1!.copyWith(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.w500,
    );

    return Column(
      children: productIdWithCounts.map((item) {
        final product = item.product!;

        return Container(
          color: Colors.white,
          child: ExpansionTile(
            title: Text(
              product.name,
              style: titleStyle,
            ),
            subtitle: Text(
              '${currencyFormat.format(product.price)} VND',
              style: priceStyle,
            ),
            leading: OctoImage(
              image: NetworkImage(product.image),
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, event) {
                return const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
            childrenPadding: const EdgeInsets.all(8.0),
            trailing: Text(
              item.quantity.toString(),
              style: countStyle,
            ),
            children: [
              Text(
                product.description,
                style: caption,
              ),
            ],
          ),
        );
      }).toList(growable: false),
    );
  }
}

class InfoWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const InfoWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xff8690A0),
              ),
          maxLines: 2,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
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

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = const Color(0xff695DCC)});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 4.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
