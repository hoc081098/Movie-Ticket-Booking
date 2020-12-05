import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';

import '../../domain/model/show_time.dart';
import '../../domain/model/theatre.dart';
import '../app_scaffold.dart';
import 'ticket_page.dart';

class ShowTimeItem extends StatelessWidget {
  final ShowTime item;
  final Theatre theatre;
  static final showTimeDateFormat = DateFormat('dd/MM/yyyy, hh:mm a');

  ShowTimeItem({Key key, this.item, this.theatre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: () {
          AppScaffold.of(context).pushNamed(
            TicketsPage.routeName,
            arguments: {
              'showTime': item,
              'theatre': theatre,
            },
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: OctoImage(
                image: NetworkImage(item.movie.posterUrl ?? ''),
                width: 128,
                height: 86,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, event) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (context, e, s) {
                  return Center(
                    child: Icon(
                      Icons.error,
                      color: Theme.of(context).accentColor,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(item.movie.title),
                  const SizedBox(height: 4),
                  Text(
                    '${item.movie.duration} mins',
                    style: textTheme.caption.copyWith(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xffD1DBE2),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            showTimeDateFormat.format(item.startTime),
                            textAlign: TextAlign.center,
                            style: textTheme.subtitle1.copyWith(
                              fontSize: 18,
                              color: const Color(0xff687189),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
