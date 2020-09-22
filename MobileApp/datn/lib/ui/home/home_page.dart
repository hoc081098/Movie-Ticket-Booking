import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datn/domain/model/movie.dart';
import 'package:datn/ui/widgets/error_widget.dart';
import 'package:datn/utils/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../domain/repository/movie_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoaderBloc<BuiltList<Movie>> nowPlayingBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nowPlayingBloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    nowPlayingBloc ??= () {
      final repo = Provider.of<MovieRepository>(context);
      return LoaderBloc(
        loaderFunction: () => repo.getNowPlayingMovies(null, 1),
        initialContent: <Movie>[].build(),
        enableLogger: true,
      )..fetch();
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        slivers: [
          const HomeLocationHeader(),
          HomeNowPlayingMoviesList(nowPlayingBloc),
        ],
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

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            InkWell(
              onTap: () {},
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
                        Text(
                          'Đà nẵng',
                          maxLines: 1,
                          style: textTheme.headline6.copyWith(fontSize: 13),
                        ),
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
}

class HomeNowPlayingMoviesList extends StatelessWidget {
  final LoaderBloc<BuiltList<Movie>> bloc;

  HomeNowPlayingMoviesList(this.bloc);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Color(0xFFFCFCFC),
        constraints: BoxConstraints.expand(height: 264),
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

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final item = movies[index];

                return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 16),
                  child: AspectRatio(
                    aspectRatio: 1 / 1.5,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
