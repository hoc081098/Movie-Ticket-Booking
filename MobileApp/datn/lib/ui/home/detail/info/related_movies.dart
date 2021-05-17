import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:octo_image/octo_image.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../../../domain/model/movie.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/error.dart';
import '../../../app_scaffold.dart';
import '../../../widgets/age_type.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../movie_detail_page.dart';

class RelatedMovies extends StatelessWidget {
  final LoaderBloc<BuiltList<Movie>> bloc;

  RelatedMovies({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RxStreamBuilder<LoaderState<BuiltList<Movie>>>(
      stream: bloc.state$,
      builder: (context, state) {
        if (state.error != null) {
          return SliverToBoxAdapter(
            child: Container(
              color: Color(0xFFFCFCFC),
              constraints: BoxConstraints.expand(height: 350),
              child: MyErrorWidget(
                errorText: S
                    .of(context)
                    .error_with_message(context.getErrorMessage(state.error!)),
                onPressed: bloc.fetch,
              ),
            ),
          );
        }

        if (state.isLoading) {
          return SliverToBoxAdapter(
            child: Container(
              color: Color(0xFFFCFCFC),
              constraints: BoxConstraints.expand(height: 350),
              child: Center(
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballClipRotatePulse,
                  ),
                ),
              ),
            ),
          );
        }

        final movies = state.content!;

        if (movies.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              color: Color(0xFFFCFCFC),
              constraints: BoxConstraints.expand(height: 350),
              child: Center(
                child: EmptyWidget(message: S.of(context).emptyRelatedMovie),
              ),
            ),
          );
        }

        final titleTextStyle =
            Theme.of(context).textTheme.headline6!.copyWith(fontSize: 13);

        final reviewstextStyle =
            Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontSize: 10,
                  color: Color(0xff5B64CF),
                );

        final minStyle = Theme.of(context).textTheme.overline!.copyWith(
              fontSize: 10,
            );

        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = movies[index];

              return InkWell(
                onTap: () {
                  AppScaffold.navigatorOfCurrentIndex(context).pushNamedX(
                    MovieDetailPage.routeName,
                    arguments: item,
                  );
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 10,
                        clipBehavior: Clip.antiAlias,
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
                    Container(
                      margin: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            item.title,
                            style: titleTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                height: 16,
                                child: IgnorePointer(
                                  child: Center(
                                    child: RatingBar.builder(
                                      initialRating: item.rateStar,
                                      allowHalfRating: true,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      itemSize: 14,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: const Color(0xff5B64CF),
                                      ),
                                      onRatingUpdate: (_) {},
                                      tapOnlyMode: true,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                S.of(context).total_rate_review(item.totalRate),
                                style: reviewstextStyle,
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#' + S.of(context).duration_minutes(item.duration),
                            style: minStyle,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            childCount: movies.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.8,
            crossAxisSpacing: 4,
            mainAxisSpacing: 12,
          ),
        );
      },
    );
  }
}
