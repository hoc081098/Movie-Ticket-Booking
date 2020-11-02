import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/model/movie.dart';
import '../../app_scaffold.dart';
import '../../widgets/age_type.dart';
import '../detail/movie_detail_page.dart';

class ViewAllListItem extends StatelessWidget {
  final Movie item;

  const ViewAllListItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const imageHeight = 154.0;
    const imageWidth = imageHeight * 0.7;

    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          fontSize: 17,
          color: const Color(0xff687189),
        );
    final durationStyle =
        Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14);

    final rateStyle = titleStyle.copyWith(fontSize: 20);

    return Container(
      margin: const EdgeInsets.only(
        left: 6,
        right: 8,
        top: 8,
        bottom: 12,
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
      child: Material(
        child: InkWell(
          onTap: () => AppScaffold.of(context).pushNamed(
            MovieDetailPage.routeName,
            arguments: item,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: imageWidth,
                  height: imageHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: item.posterUrl ?? '',
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
                                  'Load image error',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: AgeTypeWidget(
                          ageType: item.ageType,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: titleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.duration} minutes',
                      style: durationStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_rounded,
                          size: 32,
                          color: Color(0xff8690A0),
                        ),
                        const SizedBox(width: 4),
                        RichText(
                          text: TextSpan(
                            text: item.rateStar.toStringAsFixed(2),
                            style: rateStyle,
                            children: [
                              TextSpan(
                                text: ' / 5',
                                style: durationStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.totalRate} reviews',
                      style: durationStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
