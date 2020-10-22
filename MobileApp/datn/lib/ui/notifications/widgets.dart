import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:datn/ui/widgets/age_type.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:intl/intl.dart';

import '../../domain/model/notification.dart';

class NotificationItemWidget extends StatelessWidget {
  final startTimeFormat = DateFormat('dd/MM/yy, EE, hh:mm a');

  final Notification item;
  final DateFormat dateFormat;

  NotificationItemWidget(this.item, this.dateFormat);

  @override
  Widget build(BuildContext context) {
    final showTime = item.reservation.showTime;
    final movie = item.reservation.showTime.movie;
    final theatre = item.reservation.showTime.theatre;

    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.headline6.copyWith(
      fontSize: 15,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
    final timeStyle = textTheme.subtitle1.copyWith(
      color: Colors.white,
      fontSize: 10,
      fontStyle: FontStyle.italic,
    );
    final textStyle = textTheme.subtitle1.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w300,
      color: Colors.white.withOpacity(0.9),
    );

    final textStyle2 = textTheme.subtitle1.copyWith(
      fontSize: 14,
      color: Colors.white.withOpacity(0.9),
      fontWeight: FontWeight.w600,
    );

    return Container(
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
            color: Colors.grey.shade400,
            offset: Offset(2, 4),
            blurRadius: 10,
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
                          text: 'Start at: ',
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
                          text: 'Theatre: ',
                          style: textStyle,
                          children: [
                            TextSpan(
                              text: theatre.name,
                              style: textStyle2,
                            ),
                            TextSpan(
                              text: ' Room: ',
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
                child: AgeTypeWidget(
                  ageType: movie.ageType,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
