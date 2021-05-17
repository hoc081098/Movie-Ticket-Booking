import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rx_redux/rx_redux.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/repository/city_repository.dart';
import '../../../domain/repository/movie_repository.dart';
import '../../../generated/l10n.dart';
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

  const ViewAllPage({Key? key, required this.movieType}) : super(key: key);

  @override
  _ViewAllPageState createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> with DisposeBagMixin {
  RxReduxStore<ViewAllAction, ViewAllState>? store;
  final scrollController = ScrollController();

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

      scrollController
          .nearBottomEdge$()
          .mapTo<ViewAllAction>(const LoadNextPageAction())
          .dispatchTo(s);

      return s;
    }();
  }

  @override
  void dispose() {
    super.dispose();
    store!.dispose();
    store = null;
    scrollController.dispose();
  }

  void subscribe(RxReduxStore<ViewAllAction, ViewAllState> store) {
    store.stateStream
        .listen((state) => print('Page: ${state.page}'))
        .disposedBy(bag);

    store.actionStream.listen((action) {
      if (action is FailureAction) {
        context.showSnackBar(
          S.of(context).error_with_message(getErrorMessage(action.error)),
        );
      }
      if (action is SuccessAction) {
        if (action.items.isEmpty) {
          context.showSnackBar(S.of(context).loadedAllMovies);
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
            _getTitle(
              widget.movieType,
              context,
            ),
          ),
        ),
      ),
      body: RxStreamBuilder<ViewAllState>(
        stream: store!.stateStream,
        builder: (context, state) {
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
                errorText: S
                    .of(context)
                    .error_with_message(getErrorMessage(state.error!)),
                onPressed: () => store!.dispatch(const RetryAction()),
              ),
            );
          }

          if (state.items.isEmpty) {
            return Center(
              child: EmptyWidget(
                message: S.of(context).empty_movie,
              ),
            );
          }

          final items = state.items;

          return RefreshIndicator(
            onRefresh: () {
              final action = RefreshAction();
              store!.dispatch(action);
              return action.completed;
            },
            child: ListView.builder(
              controller: scrollController,
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
                      errorText: S
                          .of(context)
                          .error_with_message(getErrorMessage(state.error!)),
                      onPressed: () => store!.dispatch(const RetryAction()),
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
                return const SizedBox(width: 0, height: 56);
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
        return ({required int page, required int perPage}) {
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
  }
}

String _getTitle(MovieType movieType, BuildContext context) {
  switch (movieType) {
    case MovieType.nowPlaying:
      return S.of(context).movies_on_theatre;
    case MovieType.comingSoon:
      return S.of(context).coming_soon.capitalize();
    case MovieType.recommended:
      throw StateError('Unsupported type $movieType');
    case MovieType.mostFavorite:
      return S.of(context).most_favorite.capitalize();
    case MovieType.mostRate:
      return S.of(context).most_rate.capitalize();
  }
}

extension StringExt on String {
  String capitalize() => isNotEmpty
      ? substring(0, 1).toUpperCase() + substring(1).toLowerCase()
      : this;
}
