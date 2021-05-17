import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../domain/model/movie.dart';
import '../../domain/repository/favorites_repository.dart';
import '../../generated/l10n.dart';
import '../../utils/error.dart';
import '../../utils/utils.dart';
import '../app_scaffold.dart';
import '../home/detail/movie_detail_page.dart';
import '../widgets/age_type.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with DisposeBagMixin {
  LoaderBloc<BuiltList<Movie>>? bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bloc ??= () {
      final repo = Provider.of<FavoritesRepository>(context);
      final loaderBloc = LoaderBloc<BuiltList<Movie>>(
        loaderFunction: repo.favoritesMovie,
        initialContent: BuiltList.of(<Movie>[]),
        logger: print,
      );

      AppScaffold.currentIndexStream(context)
          .where((i) => i == AppScaffoldIndex.favorites)
          .take(1)
          .debug(identifier: '>>> FAVORITES', log: streamDebugPrint)
          .listen((event) => bloc!.fetch())
          .disposedBy(bag);

      return loaderBloc;
    }();
  }

  @override
  void dispose() {
    bloc!.dispose();
    bloc = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<FavoritesRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).favorites),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: RxStreamBuilder<LoaderState<BuiltList<Movie>>>(
          stream: bloc!.state$,
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: LoadingIndicator(
                    color: Theme.of(context).accentColor,
                    indicatorType: Indicator.ballScaleMultiple,
                  ),
                ),
              );
            }

            if (state.error != null) {
              return Center(
                child: MyErrorWidget(
                  errorText: S
                      .of(context)
                      .error_with_message(getErrorMessage(state.error!)),
                  onPressed: bloc!.fetch,
                ),
              );
            }

            final items = state.content!;

            if (items.isEmpty) {
              return Center(
                child: EmptyWidget(
                  message: S.of(context).empty_favorite_movie,
                ),
              );
            }

            return FavoritesList(items, repo.refresh);
          },
        ),
      ),
    );
  }
}

class FavoritesList extends StatefulWidget {
  final BuiltList<Movie> items;
  final Future<void> Function() onRefresh;

  FavoritesList(this.items, this.onRefresh);

  @override
  _FavoritesListState createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> with DisposeBagMixin {
  final toggleS = PublishSubject<Movie>(sync: true);
  Object? token;

  @override
  void initState() {
    super.initState();
    toggleS.disposedBy(bag);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    token ??= () {
      final repo = Provider.of<FavoritesRepository>(context);
      toggleS
          .groupBy((movie) => movie.id)
          .flatMap((movie$) => movie$.exhaustMap((movie) {
                final title = movie.title.length > 24
                    ? '${movie.title.substring(0, 24)}...'
                    : movie.title;

                return repo
                    .toggleFavorite(movie.id)
                    .doOnData((_) => context.showSnackBar(S
                        .of(context)
                        .fav_removed_successfully_with_title(title)))
                    .doOnError((e, s) => context.showSnackBar(
                        S.of(context).fav_removed_failed_with_title(title)));
              }))
          .listen(null)
          .disposedBy(bag);

      return const Object();
    }();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        itemBuilder: (context, index) => FavoriteItem(
          widget.items[index],
          toggleS.add,
        ),
        itemCount: widget.items.length,
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final Movie item;
  final Function1<Movie, void> onToggle;

  FavoriteItem(this.item, this.onToggle);

  @override
  Widget build(BuildContext context) {
    const imageHeight = 154.0;
    const imageWidth = imageHeight * 0.7;

    final titleStyle = Theme.of(context).textTheme.headline6!.copyWith(
          fontSize: 17,
          color: const Color(0xff687189),
        );
    final durationStyle =
        Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 14);

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
          onTap: () => AppScaffold.navigatorOfCurrentIndex(context,
                  switchToNewIndex: AppScaffoldIndex.home)
              .pushNamedX(
            MovieDetailPage.routeName,
            arguments: item,
          ),
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: [
              IconSlideAction(
                caption: S.of(context).remove,
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => onToggle(item),
              ),
            ],
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
                        S.of(context).duration_minutes(item.duration),
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
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
