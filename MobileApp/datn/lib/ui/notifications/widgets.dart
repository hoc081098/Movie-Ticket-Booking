import 'package:cached_network_image/cached_network_image.dart';
import 'package:datn/ui/widgets/age_type.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:intl/intl.dart';

import '../../domain/model/notification.dart';

class NotificationItemWidget extends StatelessWidget {
  final Notification item;
  final DateFormat dateFormat;

  NotificationItemWidget(this.item, this.dateFormat);

  @override
  Widget build(BuildContext context) {
    final movie = item.reservation.showTime.movie;

    const imageHeight = 128.0;
    const imageWidth = imageHeight * 0.7;

    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.headline6.copyWith(
      fontSize: 17,
      color: Colors.white,
    );
    final timeStyle = textTheme.subtitle1.copyWith(
      color: Colors.white,
      fontSize: 12,
      fontStyle: FontStyle.italic,
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
            color: Colors.grey.shade300,
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
          width: imageWidth,
          height: imageHeight,
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
                child: Container(
                  color: Colors.black54,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                left: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.title,
                      style: titleStyle,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(item.body),
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
