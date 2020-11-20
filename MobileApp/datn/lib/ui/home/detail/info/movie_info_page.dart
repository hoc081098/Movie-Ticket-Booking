import 'package:built_collection/src/list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_loader/stream_loader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/model/movie.dart';
import '../../../../domain/model/person.dart';
import '../../../../domain/repository/favorites_repository.dart';
import '../../../../domain/repository/movie_repository.dart';
import '../../../../utils/error.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/age_type.dart';
import '../../../widgets/error_widget.dart';

class MovieInfoPage extends StatefulWidget {
  final String movieId;

  const MovieInfoPage({Key key, this.movieId}) : super(key: key);

  @override
  _MovieInfoPageState createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage>
    with AutomaticKeepAliveClientMixin, DisposeBagMixin {
  LoaderBloc<Movie> bloc;
  LoaderBloc<bool> favBloc;

  final releaseDateFormat = DateFormat('dd/MM/yy');
  final toggleS = PublishSubject<void>(sync: true);
  Object token;
  var firstMsg = true;

  @override
  void initState() {
    super.initState();
    toggleS.disposedBy(bag);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    favBloc ??= () {
      final repo = Provider.of<FavoritesRepository>(context);
      final loaderFunction = () => repo.checkFavorite(widget.movieId);

      final loaderBloc = LoaderBloc(
        loaderFunction: loaderFunction,
        enableLogger: true,
      )..fetch();
      loaderBloc.message$.listen(handleFavMessage).disposedBy(bag);

      return loaderBloc;
    }();

    bloc ??= () {
      final repository = Provider.of<MovieRepository>(context);
      final loaderFunction = () => repository.getMovieDetail(widget.movieId);

      return LoaderBloc(
        loaderFunction: loaderFunction,
        refresherFunction: loaderFunction,
        initialContent: null,
        enableLogger: true,
      )..fetch();
    }();

    token ??= () {
      final repo = Provider.of<FavoritesRepository>(context);

      toggleS
          .exhaustMap((_) => repo.toggleFavorite(widget.movieId))
          .listen(null)
          .disposedBy(bag);

      return const Object();
    }();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final themeData = Theme.of(context);

    return Scaffold(
      body: RxStreamBuilder<LoaderState<Movie>>(
        stream: bloc.state$,
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state.error != null) {
            return Center(
              child: MyErrorWidget(
                errorText: 'Error: ${getErrorMessage(state.error)}',
                onPressed: bloc.fetch,
              ),
            );
          }

          if (state.isLoading) {
            return Center(
              child: SizedBox(
                width: 56,
                height: 56,
                child: LoadingIndicator(
                  color: themeData.accentColor,
                  indicatorType: Indicator.ballScaleMultiple,
                ),
              ),
            );
          }

          final movie = state.content;
          assert(movie != null);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              DetailAppBar(
                movie: movie,
                favBloc: favBloc,
                onFavPressed: () => toggleS.add(null),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        movie.title,
                        style: themeData.textTheme.headline4.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff687189),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.5),
                                border: Border.all(
                                  color: const Color(0xff687189),
                                  width: 1,
                                )),
                          ),
                          const SizedBox(width: 8),
                          Text('${movie.duration} minutes'),
                          const SizedBox(width: 8),
                          AgeTypeWidget(ageType: movie.ageType),
                          const SizedBox(width: 8),
                          Text(releaseDateFormat.format(movie.releasedDate)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        children: [
                          for (var c in movie.categories) ...[
                            ActionChip(
                              label: Text(
                                '#${c.name}',
                                style: themeData.textTheme.subtitle1
                                    .copyWith(fontSize: 12),
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 4),
                          ]
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(
                        height: 1,
                        color: Color(0xffD1DBE2),
                      ),
                      const SizedBox(height: 16),
                      ExpandablePanel(
                        header: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Color(0xff8690A0),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                'STORYLINE',
                                maxLines: 1,
                                style: themeData.textTheme.headline6.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        collapsed: Text(
                          movie.overview,
                          softWrap: true,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        expanded: Text(
                          movie.overview,
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'CAST OVERVIEW',
                        maxLines: 1,
                        style: themeData.textTheme.headline6.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff687189),
                        ),
                      ),
                      const SizedBox(height: 12),
                      PeopleList(people: movie.actors),
                      Text(
                        'DIRECTORS',
                        maxLines: 1,
                        style: themeData.textTheme.headline6.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff687189),
                        ),
                      ),
                      const SizedBox(height: 12),
                      PeopleList(people: movie.directors),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void handleFavMessage(LoaderMessage<bool> msg) {
    msg.fold(
      onFetchFailure: (e, s) =>
          context.showSnackBar('Failed: ${getErrorMessage(e)}'),
      onFetchSuccess: (data) {
        if (firstMsg) {
          firstMsg = false;
        } else {
          context.showSnackBar('Toggled successfully');
        }
      },
      onRefreshFailure: (e, s) {},
      onRefreshSuccess: (data) {},
    );
  }
}

class DetailAppBar extends StatelessWidget {
  const DetailAppBar({
    Key key,
    @required this.movie,
    @required this.onFavPressed,
    @required this.favBloc,
  }) : super(key: key);

  final Movie movie;
  final Function0<void> onFavPressed;
  final LoaderBloc<bool> favBloc;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: false,
      floating: false,
      stretch: true,
      backgroundColor: const Color(0xfffafafa),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
        background: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: movie.posterUrl ?? '',
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
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    // backgroundBlendMode: BlendMode.screen,
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                        // const Color(0xff545AE9).withOpacity(0.6),
                        // const Color(0xffB881F9),
                      ],
                      // stops: [0, 0.5, 1],
                      begin: AlignmentDirectional.topEnd,
                      end: AlignmentDirectional.bottomStart,
                    ),
                  ),
                ),
              ),
              // Positioned.fill(
              //   child: Container(
              //     constraints: BoxConstraints.expand(),
              //     decoration: BoxDecoration(
              //       backgroundBlendMode: BlendMode.multiply,
              //       gradient: LinearGradient(
              //         colors: <Color>[
              //           const Color(0xff545AE9).withOpacity(0.8),
              //           const Color(0xffB881F9).withOpacity(0.8),
              //         ],
              //         begin: AlignmentDirectional.topEnd,
              //         end: AlignmentDirectional.bottomStart,
              //       ),
              //     ),
              //   ),
              // ),
              Positioned(
                top: 16,
                right: 16,
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      RxStreamBuilder<LoaderState<bool>>(
                        stream: favBloc.state$,
                        builder: (context, snapshot) {
                          final state = snapshot.data;

                          if (state.isLoading) {
                            return SizedBox(
                              width: 32,
                              height: 32,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }

                          if (state.error != null) {
                            return IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.exclamation,
                                color: Colors.white,
                              ),
                              onPressed: favBloc.fetch,
                            );
                          }

                          return IconButton(
                            icon: Icon(
                              state.content
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white,
                            ),
                            onPressed: onFavPressed,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: InkWell(
                  onTap: () async {
                    if (await canLaunch(movie.trailerVideoUrl)) {
                      await launch(movie.trailerVideoUrl);
                    } else {
                      context.showSnackBar('Cannot open trailer video');
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }
}

class PeopleList extends StatelessWidget {
  const PeopleList({
    Key key,
    @required this.people,
  }) : super(key: key);

  final BuiltList<Person> people;

  @override
  Widget build(BuildContext context) {
    const width = 96.0;
    const height = width * 1.5;

    final textStyle = Theme.of(context).textTheme.subtitle2.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xff687189),
        );

    return Container(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: people.length,
        itemBuilder: (context, index) {
          final actor = people[index];

          return Container(
            width: width,
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: width,
                  child: ClipRRect(
                    child: FadeInImage.assetNetwork(
                      image: actor.avatar ?? '',
                      placeholder: '',
                      height: height,
                      width: width,
                      imageErrorBuilder: (context, e, st) {
                        return Center(
                          child: Image.asset(
                            'assets/images/icons8_person_96.png',
                            width: width / 2,
                            height: height,
                            fit: BoxFit.fitWidth,
                          ),
                        );
                      },
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffD8D8D8),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  actor.full_name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}
