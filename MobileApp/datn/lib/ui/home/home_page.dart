import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../domain/model/city.dart';
import '../../domain/model/movie.dart';
import '../../domain/repository/city_repository.dart';
import '../../domain/repository/movie_repository.dart';
import '../../utils/error.dart';
import '../../utils/streams.dart';
import '../app_scaffold.dart';
import '../widgets/age_type.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import 'detail/movie_detail_page.dart';

enum MovieType {
  nowPlaying,
  comingSoon,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with DisposeBagMixin {
  LoaderBloc<BuiltList<Movie>> nowPlayingBloc;
  LoaderBloc<BuiltList<Movie>> comingSoonBloc;
  Object token;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nowPlayingBloc.dispose();
    comingSoonBloc.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    token ??= () {
      final cityRepo = Provider.of<CityRepository>(context);
      final repo = Provider.of<MovieRepository>(context);

      nowPlayingBloc = () {
        final loaderFunction = () {
          final location = cityRepo.selectedCity$.value.location;
          print('[DEBUG] fetch location=$location');
          return repo.getNowPlayingMovies(
            location: location,
            page: 1,
            perPage: 32,
          );
        };

        return LoaderBloc(
          loaderFunction: loaderFunction,
          refresherFunction: loaderFunction,
          initialContent: <Movie>[].build(),
          enableLogger: true,
        );
      }();

      cityRepo.selectedCity$.distinct().listen((city) {
        print('[DEBUG] city=$city');
        nowPlayingBloc.fetch();

        repo
            .getRecommendedMovies(city.location)
            .debug('RECOMMENDED <3')
            .listen((event) {});
      }).disposedBy(bag);

      comingSoonBloc = () {
        final loaderFunction = () => repo.getComingSoonMovies(
              page: 1,
              perPage: 32,
            );

        return LoaderBloc(
          loaderFunction: loaderFunction,
          refresherFunction: loaderFunction,
          initialContent: <Movie>[].build(),
          enableLogger: true,
        )..fetch();
      }();

      return const Object();
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          nowPlayingBloc.refresh(),
          comingSoonBloc.refresh(),
        ]),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          slivers: [
            const HomeLocationHeader(),
            HomeHorizontalMoviesList(
              key: ValueKey('movies/now-playing'),
              bloc: nowPlayingBloc,
              type: MovieType.nowPlaying,
            ),
            const ComingSoonHeader(),
            HomeHorizontalMoviesList(
              key: ValueKey('movies/coming-soon'),
              bloc: comingSoonBloc,
              type: MovieType.comingSoon,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeLocationHeader extends StatelessWidget {
  const HomeLocationHeader({
    Key key,
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
                    Text(
                      'Movies on Theatre',
                      maxLines: 1,
                      style: textTheme.headline6.copyWith(fontSize: 18),
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
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data.name,
                                maxLines: 1,
                                style:
                                    textTheme.headline6.copyWith(fontSize: 13),
                              );
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            FlatButton(
              padding: const EdgeInsets.all(12),
              onPressed: () {},
              child: Text(
                'VIEW ALL',
                style: textTheme.button.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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
          title: Text('Select city'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final city in cityRepo.allCities)
                  ListTile(
                    title: Text(city.name),
                    onTap: () => Navigator.of(dialogContext).pop(city),
                    selected: city == cityRepo.selectedCity$.value,
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
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

  HomeHorizontalMoviesList({Key key, @required this.bloc, @required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const totalHeight = 350.0;
    const imageHeight = 248.0;
    const imageWidth = imageHeight / 1.3;

    final titleTextStyle =
        Theme.of(context).textTheme.headline6.copyWith(fontSize: 14);

    final reviewstextStyle = Theme.of(context).textTheme.subtitle2.copyWith(
          fontSize: 11,
          color: Color(0xff5B64CF),
        );

    final minStyle = Theme.of(context).textTheme.overline.copyWith(
          fontSize: 12,
        );

    return SliverToBoxAdapter(
      child: Container(
        color: Color(0xFFFCFCFC),
        constraints: BoxConstraints.expand(height: totalHeight),
        child: RxStreamBuilder<LoaderState<BuiltList<Movie>>>(
          stream: bloc.state$,
          builder: (context, snapshot) {
            final state = snapshot.data;

            if (state.error != null) {
              return MyErrorWidget(
                errorText: 'Error: ${getErrorMessage(state.error)}',
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

            final movies = state.content;

            if (movies.isEmpty) {
              return Center(
                child: EmptyWidget(message: 'Empty movies'),
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
        AppScaffold.of(context).pushNamed(
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
          ),
          buildBottom(
              imageWidth, item, titleTextStyle, reviewstextStyle, minStyle),
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
  ) {
    switch (type) {
      case MovieType.nowPlaying:
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
                        child: RatingBar(
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
                    '${item.totalRate} review${item.totalRate > 1 ? 's' : ''}',
                    style: reviewstextStyle,
                  )
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '#${item.duration} minutes',
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
    throw StateError('Unknown $type');
  }
}

class ComingSoonHeader extends StatelessWidget {
  const ComingSoonHeader({Key key}) : super(key: key);

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
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xff8690A0),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                'COMING SOON',
                maxLines: 1,
                style: textTheme.headline6.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            FlatButton(
              padding: const EdgeInsets.all(12),
              onPressed: () {},
              child: Text(
                'VIEW ALL',
                style: textTheme.button.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
