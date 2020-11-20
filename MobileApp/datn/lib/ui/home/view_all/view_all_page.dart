import 'package:flutter/material.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rx_redux/rx_redux.dart';

import '../../../domain/repository/city_repository.dart';
import '../../../domain/repository/movie_repository.dart';
import '../../../utils/utils.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/error_widget.dart';
import '../movie_type.dart';
import 'list_item.dart';
import 'store.dart';
import 'view_all_state.dart';

class ViewAllPage extends StatefulWidget {
  static const routeName = '/home/view_all';

  final MovieType movieType;

  const ViewAllPage({Key key, @required this.movieType}) : super(key: key);

  @override
  _ViewAllPageState createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> with DisposeBagMixin {
  RxReduxStore<ViewAllAction, ViewAllState> store;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    store ??= () {
      final movieRepo = Provider.of<MovieRepository>(context);
      final cityRepo = Provider.of<CityRepository>(context);
      final s = createStore(
        getMoviesFrom(
          widget.movieType,
          movieRepo,
          cityRepo,
        ),
      );

      subscribe(s);
      s.dispatch(const LoadFirstPageAction());

      return s;
    }();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  void subscribe(RxReduxStore<ViewAllAction, ViewAllState> store) {
    store.stateStream
        .listen((state) => print('Page: ${state.page}'))
        .disposedBy(bag);

    store.actionStream.listen((action) {
      if (action is FailureAction) {
        context.showSnackBar(
          'Error occurred: ${getErrorMessage(action.error)}',
        );
      }
      if (action is SuccessAction) {
        if (action.items.isEmpty) {
          context.showSnackBar('Loaded all movies');
        }
      }
    }).disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: widget.movieType.toString(),
          child: Text(
            _getTitle(widget.movieType),
          ),
        ),
      ),
      body: StreamBuilder<ViewAllState>(
        stream: store.stateStream,
        initialData: store.state,
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state.isLoading && state.isFirstPage) {
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

          if (state.error != null && state.isFirstPage) {
            return Center(
              child: MyErrorWidget(
                errorText: 'Error: ${getErrorMessage(state.error)}',
                onPressed: () => store.dispatch(const RetryAction()),
              ),
            );
          }

          if (state.items.isEmpty) {
            return Center(
              child: EmptyWidget(
                message: 'Empty movie',
              ),
            );
          }

          final items = state.items;

          return RefreshIndicator(
            onRefresh: () {
              final action = RefreshAction();
              store.dispatch(action);
              return action.completed;
            },
            child: ListView.builder(
              itemCount: items.length + (state.isFirstPage ? 0 : 1),
              itemBuilder: (context, index) {
                if (index < items.length) {
                  return ViewAllListItem(
                    item: items[index],
                  );
                }

                if (state.error != null) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: MyErrorWidget(
                      errorText:
                          'Load page ${state.page}, error: ${getErrorMessage(state.error)}',
                      onPressed: () => store.dispatch(const RetryAction()),
                    ),
                  );
                }

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

                if (state.loadedAll) {
                  return const SizedBox(width: 0, height: 0);
                }

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                    top: 12,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 128,
                      height: 48,
                      child: RaisedButton(
                        onPressed: () =>
                            store.dispatch(const LoadNextPageAction()),
                        child: Text('Next page'),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  GetMovies getMoviesFrom(
    MovieType movieType,
    MovieRepository movieRepo,
    CityRepository cityRepo,
  ) {
    switch (movieType) {
      case MovieType.nowPlaying:
        final location = cityRepo.selectedCity$.value.location;
        return ({@required int page, @required int perPage}) {
          return movieRepo.getNowPlayingMovies(
            page: page,
            perPage: perPage,
            location: location,
          );
        };
      case MovieType.comingSoon:
        return movieRepo.getComingSoonMovies;
      case MovieType.recommended:
        throw StateError('Unsupported type $movieType');
      case MovieType.mostFavorite:
        return movieRepo.getMostFavorite;
      case MovieType.mostRate:
        return movieRepo.getMostRate;
    }
    throw StateError('Missing $movieType');
  }
}

String _getTitle(MovieType movieType) {
  switch (movieType) {
    case MovieType.nowPlaying:
      return 'Movies on Theatre';
    case MovieType.comingSoon:
      return 'Coming soon';
    case MovieType.recommended:
      throw StateError('Unsupported type $movieType');
    case MovieType.mostFavorite:
      return 'Most favorite';
    case MovieType.mostRate:
      return 'Most rate';
  }
  throw StateError('Missing $movieType');
}
