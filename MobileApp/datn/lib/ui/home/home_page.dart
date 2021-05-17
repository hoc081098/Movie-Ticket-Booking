import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:octo_image/octo_image.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../domain/model/city.dart';
import '../../domain/model/movie.dart';
import '../../domain/model/theatre.dart';
import '../../domain/repository/city_repository.dart';
import '../../domain/repository/movie_repository.dart';
import '../../domain/repository/theatre_repository.dart';
import '../../generated/l10n.dart';
import '../../utils/error.dart';
import '../../utils/intl.dart';
import '../../utils/utils.dart';
import '../app_scaffold.dart';
import '../widgets/age_type.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import 'change_language_button.dart';
import 'detail/movie_detail_page.dart';
import 'movie_type.dart';
import 'search_delegate.dart';
import 'showtimes_by_theatre/show_time_by_theatre_page.dart';
import 'view_all/view_all_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with DisposeBagMixin {
  late LoaderBloc<BuiltList<Movie>> nowPlayingBloc;
  late LoaderBloc<BuiltList<Movie>> comingSoonBloc;
  late LoaderBloc<BuiltList<Movie>> recommendedBloc;
  late LoaderBloc<BuiltList<Movie>> mostFavoriteBloc;
  late LoaderBloc<BuiltList<Movie>> mostRateBloc;
  late LoaderBloc<BuiltList<Theatre>> theatresBloc;
  Object? token;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    [
      nowPlayingBloc,
      comingSoonBloc,
      recommendedBloc,
      mostFavoriteBloc,
      mostRateBloc,
      theatresBloc,
    ].forEach((b) => b.dispose());

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    token ??= () {
      final cityRepo = Provider.of<CityRepository>(context);
      final repo = Provider.of<MovieRepository>(context);
      final theatreRepo = Provider.of<TheatreRepository>(context);
      final emptyMovieList = <Movie>[].build();

      nowPlayingBloc = () {
        final loaderFunction = () {
          final location = cityRepo.selectedCity$.value.location;
          print('[DEBUG] fetch 1 location=$location');
          return repo.getNowPlayingMovies(
            location: location,
            page: 1,
            perPage: 32,
          );
        };

        return LoaderBloc(
          loaderFunction: loaderFunction,
          refresherFunction: loaderFunction,
          initialContent: emptyMovieList,
          logger: print,
        );
      }();

      recommendedBloc = () {
        final loaderFunction = () {
          final location = cityRepo.selectedCity$.value.location;
          print('[DEBUG] fetch 2 location=$location');
          return repo.getRecommendedMovies(location);
        };

        return LoaderBloc(
          loaderFunction: loaderFunction,
          refresherFunction: loaderFunction,
          initialContent: emptyMovieList,
          logger: print,
        );
      }();

      comingSoonBloc = () {
        final loaderFunction =
            () => repo.getComingSoonMovies(page: 1, perPage: 32);

        return LoaderBloc(
          loaderFunction: loaderFunction,
          refresherFunction: loaderFunction,
          initialContent: emptyMovieList,
          logger: print,
        );
      }();

      mostFavoriteBloc = () {
        final loaderFunction = () => repo.getMostFavorite(page: 1, perPage: 32);

        return LoaderBloc(
          loaderFunction: loaderFunction,
          refresherFunction: loaderFunction,
          initialContent: emptyMovieList,
          logger: print,
        );
      }();

      mostRateBloc = () {
        final loaderFunction = () => repo.getMostRate(page: 1, perPage: 32);

        return LoaderBloc(
          loaderFunction: loaderFunction,
          refresherFunction: loaderFunction,
          initialContent: emptyMovieList,
          logger: print,
        );
      }();

      theatresBloc = () {
        final loaderFunction = () => theatreRepo
            .getNearbyTheatres(cityRepo.selectedCity$.value.location);

        return LoaderBloc<BuiltList<Theatre>>(
          loaderFunction: loaderFunction,
          refresherFunction: loaderFunction,
          initialContent: const <Theatre>[].build(),
          logger: print,
        );
      }();

      final fetchDoneFirstTime = (LoaderMessage<Object> event) => event.fold(
            onFetchFailure: (e, s) => true,
            onFetchSuccess: (d) => true,
            onRefreshFailure: (e, s) => false,
            onRefreshSuccess: (d) => false,
          );

      Rx.forkJoin([
        nowPlayingBloc.message$.where(fetchDoneFirstTime).take(1),
        recommendedBloc.message$.where(fetchDoneFirstTime).take(1),
        theatresBloc.message$.where(fetchDoneFirstTime).take(1)
      ], (l) => l)
          .doOnData((l) {
            print('###### ${l.map((v) => v.runtimeType)}');
            comingSoonBloc.fetch();
            mostFavoriteBloc.fetch();
            mostRateBloc.fetch();
          })
          .listen(null)
          .disposedBy(bag);

      cityRepo.selectedCity$
          .distinct()
          .debug(identifier: '[HOME] SELECT CITY', log: streamDebugPrint)
          .doOnData((_) {
            nowPlayingBloc.fetch();
            recommendedBloc.fetch();
            theatresBloc.fetch();
          })
          .listen(null)
          .disposedBy(bag);

      return const Object();
    }();
  }

  @override
  Widget build(BuildContext context) {
    final movieRepo = Provider.of<MovieRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Enjoy movies'),
        actions: [
          const ChangeLanguageButton(iconColor: null),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final searchDelegate = MovieSearchDelegate(movieRepo);
              final bag = searchDelegate.bag;
              final result = await showSearch(
                context: context,
                delegate: searchDelegate,
              );

              print('>>>>>>>>>>>>>>> [$result]');
              if (result == null) {
                await bag.dispose();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            nowPlayingBloc.refresh(),
            mostFavoriteBloc.refresh(),
          ]);
          await Future.wait([
            comingSoonBloc.refresh(),
            mostRateBloc.refresh(),
          ]);
          await Future.wait([
            recommendedBloc.refresh(),
            theatresBloc.refresh(),
          ]);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          slivers: [
            const HomeLocationHeader(),
            HomeHorizontalMoviesList(
              key: ValueKey(MovieType.nowPlaying),
              bloc: nowPlayingBloc,
              type: MovieType.nowPlaying,
            ),
            //
            const ComingSoonHeader(),
            HomeHorizontalMoviesList(
              key: ValueKey(MovieType.comingSoon),
              bloc: comingSoonBloc,
              type: MovieType.comingSoon,
            ),
            //
            const RecommendedHeader(),
            HomeHorizontalMoviesList(
              key: ValueKey(MovieType.recommended),
              bloc: recommendedBloc,
              type: MovieType.recommended,
            ),
            //
            const MostFavoriteHeader(),
            HomeHorizontalMoviesList(
              key: ValueKey(MovieType.mostFavorite),
              bloc: mostFavoriteBloc,
              type: MovieType.mostFavorite,
            ),
            //
            const MostRateHeader(),
            HomeHorizontalMoviesList(
              key: ValueKey(MovieType.mostRate),
              bloc: mostRateBloc,
              type: MovieType.mostRate,
            ),
            //
            const NearbyTheatreHeader(),
            NearbyTheatresList(bloc: theatresBloc),
          ],
        ),
      ),
    );
  }
}

class HomeLocationHeader extends StatelessWidget {
  const HomeLocationHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cityRepo = Provider.of<CityRepository>(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            InkWell(
              onTap: () => changeCity(cityRepo, context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: MovieType.nowPlaying.toString(),
                      child: Text(
                        S.of(context).movies_on_theatre,
                        maxLines: 1,
                        style: textTheme.headline6!.copyWith(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Transform.rotate(
                          angle: 45,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Color(0xffACB5C3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.navigation_sharp,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        RxStreamBuilder<City>(
                          stream: cityRepo.selectedCity$,
                          builder: (context, data) {
                            return Text(
                              data.localizedName(context),
                              maxLines: 1,
                              style:
                                  textTheme.headline6!.copyWith(fontSize: 13),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            ViewAllButton(movieType: MovieType.nowPlaying),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  void changeCity(CityRepository cityRepo, BuildContext context) async {
    final newCity = await showDialog<City>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).select_city),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final city in cityRepo.allCities)
                  ListTile(
                    title: Text(city.localizedName(context)),
                    onTap: () => Navigator.of(dialogContext).pop(city),
                    selected: city == cityRepo.selectedCity$.value,
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(S.of(context).cancel),
            ),
          ],
        );
      },
    );

    if (newCity == null) {
      return;
    }
    if (newCity == cityRepo.selectedCity$.value) {
      return;
    }

    await cityRepo.change(newCity);
  }
}

class HomeHorizontalMoviesList extends StatelessWidget {
  final DateFormat dateFormat = DateFormat.yMd();
  final LoaderBloc<BuiltList<Movie>> bloc;
  final MovieType type;

  HomeHorizontalMoviesList({Key? key, required this.bloc, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalHeight = () {
      switch (type) {
        case MovieType.nowPlaying:
        case MovieType.mostFavorite:
        case MovieType.mostRate:
        case MovieType.recommended:
          return 350.0;
        case MovieType.comingSoon:
          return 330.0;
      }
    }();

    const imageHeight = 248.0;
    const imageWidth = imageHeight / 1.3;

    final titleTextStyle =
        Theme.of(context).textTheme.headline6!.copyWith(fontSize: 14);

    final reviewstextStyle = Theme.of(context).textTheme.subtitle2!.copyWith(
          fontSize: 11,
          color: Color(0xff5B64CF),
        );

    final minStyle = Theme.of(context).textTheme.overline!.copyWith(
          fontSize: 12,
        );

    return SliverToBoxAdapter(
      child: Container(
        color: Color(0xFFFCFCFC),
        constraints: BoxConstraints.expand(height: totalHeight),
        child: RxStreamBuilder<LoaderState<BuiltList<Movie>>>(
          stream: bloc.state$,
          builder: (context, state) {
            if (state.error != null) {
              return MyErrorWidget(
                errorText: S
                    .of(context)
                    .error_with_message(context.getErrorMessage(state.error!)),
                onPressed: bloc.fetch,
              );
            }

            if (state.isLoading) {
              return Center(
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballClipRotatePulse,
                  ),
                ),
              );
            }

            final movies = state.content!;

            if (movies.isEmpty) {
              return Center(
                child: EmptyWidget(message: S.of(context).empty_movie),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final item = movies[index];

                return buildItem(
                  imageWidth,
                  imageHeight,
                  item,
                  context,
                  titleTextStyle,
                  reviewstextStyle,
                  minStyle,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildItem(
    double imageWidth,
    double imageHeight,
    Movie item,
    BuildContext context,
    TextStyle titleTextStyle,
    TextStyle reviewstextStyle,
    TextStyle minStyle,
  ) {
    return InkWell(
      onTap: () {
        AppScaffold.navigatorOfCurrentIndex(context).pushNamedX(
          MovieDetailPage.routeName,
          arguments: item,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 16),
            child: Container(
              width: imageWidth,
              height: imageHeight,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 10,
                clipBehavior: Clip.antiAlias,
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
          ),
          buildBottom(
            imageWidth,
            item,
            titleTextStyle,
            reviewstextStyle,
            minStyle,
            context,
          ),
        ],
      ),
    );
  }

  Container buildBottom(
    double imageWidth,
    Movie item,
    TextStyle titleTextStyle,
    TextStyle reviewstextStyle,
    TextStyle minStyle,
    BuildContext context,
  ) {
    switch (type) {
      case MovieType.nowPlaying:
      case MovieType.mostFavorite:
      case MovieType.mostRate:
      case MovieType.recommended:
        return Container(
          width: imageWidth - 12,
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
                    getDescription(item, context),
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
        );
      case MovieType.comingSoon:
        return Container(
          width: imageWidth - 12,
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
              Text(
                dateFormat.format(item.releasedDate),
                style: reviewstextStyle.copyWith(fontSize: 13),
              ),
            ],
          ),
        );
    }
  }

  String getDescription(Movie item, BuildContext context) {
    switch (type) {
      case MovieType.comingSoon:
        throw StateError('Wrong type $type');
      case MovieType.nowPlaying:
      case MovieType.recommended:
        return S.of(context).total_rate_review(item.totalRate);
      case MovieType.mostFavorite:
        return S.of(context).total_favorite(item.totalFavorite);
      case MovieType.mostRate:
        return '${item.rateStar.toStringAsFixed(2)} / 5';
    }
  }
}

class ComingSoonHeader extends StatelessWidget {
  const ComingSoonHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: Color(0xff8690A0),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Hero(
                tag: MovieType.comingSoon.toString(),
                child: Text(
                  S.of(context).coming_soon,
                  maxLines: 1,
                  style: textTheme.headline6!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(),
            ViewAllButton(movieType: MovieType.comingSoon),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class RecommendedHeader extends StatelessWidget {
  const RecommendedHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: LinearGradient(
                  colors: const [
                    Color(0xff545AE9),
                    Color(0xffB881F9),
                  ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
              ),
              child: Text(
                S.of(context).recommended_for_you,
                maxLines: 1,
                style: textTheme.headline6!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MostFavoriteHeader extends StatelessWidget {
  const MostFavoriteHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: LinearGradient(
                  colors: const [
                    Color(0xffF67062),
                    Color(0xffFC5296),
                  ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
              ),
              child: Hero(
                tag: MovieType.mostFavorite.toString(),
                child: Text(
                  S.of(context).most_favorite,
                  maxLines: 1,
                  style: textTheme.headline6!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(),
            ViewAllButton(movieType: MovieType.mostFavorite),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class MostRateHeader extends StatelessWidget {
  const MostRateHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: LinearGradient(
                  colors: const [
                    Color(0xffFC575E),
                    Color(0xffF7B42C),
                  ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
              ),
              child: Hero(
                tag: MovieType.mostRate.toString(),
                child: Text(
                  context.s.most_rate,
                  maxLines: 1,
                  style: textTheme.headline6!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(),
            ViewAllButton(movieType: MovieType.mostRate),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class NearbyTheatreHeader extends StatelessWidget {
  const NearbyTheatreHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: LinearGradient(
                  colors: const [
                    Color(0xff5F0A87),
                    Color(0xffA4508B),
                  ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
              ),
              child: Text(
                context.s.nearby_theatre,
                maxLines: 1,
                style: textTheme.headline6!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewAllButton extends StatelessWidget {
  final MovieType movieType;

  const ViewAllButton({Key? key, required this.movieType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(12),
      ),
      onPressed: () => AppScaffold.navigatorOfCurrentIndex(context).pushNamedX(
        ViewAllPage.routeName,
        arguments: movieType,
      ),
      child: Text(
        context.s.view_all,
        style: textTheme.button!.copyWith(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class NearbyTheatresList extends StatelessWidget {
  final LoaderBloc<BuiltList<Theatre>> bloc;

  const NearbyTheatresList({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RxStreamBuilder<LoaderState<BuiltList<Theatre>>>(
      stream: bloc.state$,
      builder: (context, state) {
        final height = 200.0;
        const padding = EdgeInsets.symmetric(vertical: 10);

        if (state.error != null) {
          return SliverToBoxAdapter(
            child: Container(
              height: height,
              padding: padding,
              child: MyErrorWidget(
                errorText: context.s
                    .error_with_message(context.getErrorMessage(state.error!)),
                onPressed: bloc.fetch,
              ),
            ),
          );
        }

        if (state.isLoading) {
          return SliverToBoxAdapter(
            child: Container(
              height: height,
              padding: padding,
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

        final theatres = state.content!;

        if (theatres.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              padding: padding,
              height: height,
              child: Center(
                child: EmptyWidget(message: context.s.empty_theatre),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: padding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = theatres[index];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: Card(
                    color: Colors.white,
                    shadowColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: InkWell(
                      onTap: () {
                        AppScaffold.navigatorOfCurrentIndex(context).pushNamedX(
                          ShowTimesByTheatrePage.routeName,
                          arguments: item,
                        );
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipOval(
                              child: OctoImage(
                                image: NetworkImage(item.thumbnail),
                                width: 54,
                                height: 54,
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
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    item.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                            fontSize: 14,
                                            color: const Color(0xff5B64CF)),
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.address,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(fontSize: 11),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (item.distance != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '${(item.distance! / 1000.0).toStringAsFixed(1)} km',
                                style: const TextStyle(
                                  color: Color(0xffA4508B),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: theatres.length,
            ),
          ),
        );
      },
    );
  }
}
