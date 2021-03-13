import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

import '../../../domain/model/movie.dart';
import '../../../generated/l10n.dart';
import '../../app_scaffold.dart';
import '../../widgets/age_type.dart';
import '../detail/movie_detail_page.dart';

class ViewAllListItem extends StatelessWidget {
  final Movie item;

  const ViewAllListItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const imageHeight = 164.0;
    const imageWidth = imageHeight * 0.7;

    final titleStyle = Theme.of(context).textTheme.headline6!.copyWith(
          fontSize: 17,
          color: const Color(0xff687189),
          fontWeight: FontWeight.w600,
        );
    final durationStyle =
        Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 12);

    final rateStyle = titleStyle.copyWith(fontSize: 20);

    return Container(
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 2,
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => AppScaffold.navigatorOfCurrentIndex(context).pushNamedX(
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
                        child: OctoImage(
                          image: NetworkImage(item.posterUrl ?? ''),
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (_, __) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          errorBuilder: (_, __, ___) => Center(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
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
                      '#' + S.of(context).duration_minutes(item.duration),
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
                      S.of(context).total_rate_review(item.totalRate),
                      style: durationStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.of(context).total_favorite(item.totalFavorite),
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
