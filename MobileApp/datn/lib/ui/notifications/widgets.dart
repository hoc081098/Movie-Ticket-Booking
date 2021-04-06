import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:intl/intl.dart';

import '../../domain/model/notification.dart';
import '../../domain/model/reservation.dart';
import '../../generated/l10n.dart';
import '../../utils/utils.dart';
import '../widgets/age_type.dart';

class NotificationItemWidget extends StatelessWidget {
  final startTimeFormat = DateFormat('dd/MM/yy, EEE, hh:mm a');

  final Notification item;
  final DateFormat dateFormat;
  final Function1<Notification, void> onDelete;
  final Function1<Reservation, void> onTapItem;

  NotificationItemWidget(
      this.item, this.dateFormat, this.onDelete, this.onTapItem);

  @override
  Widget build(BuildContext context) {
    final reservation = item.reservation;
    final showTime = reservation.showTime!;
    final movie = showTime.movie!;
    final theatre = showTime.theatre!;

    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.headline6!.copyWith(
      fontSize: 15,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
    final timeStyle = textTheme.subtitle1!.copyWith(
      color: Colors.white,
      fontSize: 10,
      fontStyle: FontStyle.italic,
    );
    final textStyle = textTheme.subtitle1!.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w300,
      color: Colors.white.withOpacity(0.9),
    );

    final textStyle2 = textTheme.subtitle1!.copyWith(
      fontSize: 14,
      color: Colors.white.withOpacity(0.9),
      fontWeight: FontWeight.w600,
    );

    return InkWell(
      onTap: () => onTapItem(reservation),
      child: Container(
        margin: const EdgeInsets.only(
          top: 8,
          left: 8,
          right: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: Offset(2, 2),
              blurRadius: 4,
              spreadRadius: 2,
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 186,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: movie.posterUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      color: Colors.black45,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  left: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        item.title,
                        style: titleStyle,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                            text: S.of(context).startAt,
                            style: textStyle,
                            children: [
                              TextSpan(
                                text:
                                    startTimeFormat.format(showTime.start_time),
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
                    ],
                  ),
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  right: 8,
                  child: Text(
                    dateFormat.format(item.createdAt),
                    style: timeStyle,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Row(
                    children: [
                      AgeTypeWidget(
                        ageType: movie.ageType,
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () => onDelete(item),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white70,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
