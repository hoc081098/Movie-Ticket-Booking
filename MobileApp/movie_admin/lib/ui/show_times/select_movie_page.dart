import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../app_scaffold.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../../domain/model/movie.dart';
import '../../domain/model/theatre.dart';
import '../../domain/repository/movie_repository.dart';
import '../../utils/utils.dart';
import '../movies/movies_page.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import 'add_show_time_page.dart';

class SelectMoviePage extends StatefulWidget {
  static const routeName = '/home/show-times/select-movie';

  final Theatre theatre;

  const SelectMoviePage({Key key, this.theatre}) : super(key: key);

  @override
  _SelectMoviePageState createState() => _SelectMoviePageState();
}

class _SelectMoviePageState extends State<SelectMoviePage>
    with DisposeBagMixin {
  final searchController = TextEditingController();
  final termS = StreamController<String>(sync: true);
  final retryS = StreamController<String>(sync: true);

  DistinctValueStream<SearchState> state$;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    state$ ??= () {
      final repo = Provider.of<MovieRepository>(context);

      return termS.stream
          .where((event) => event.trim().isNotEmpty)
          .debounceTime(const Duration(milliseconds: 400))
          .distinct()
          .mergeWith([retryS.stream])
          .debug(identifier: 'TERM')
          .switchMap(
            (value) => Rx.fromCallable(() => repo.search(value))
                .map((movies) => SearchState(movies, null, false))
                .onErrorReturnWith((error) => SearchState(null, error, false))
                .startWith(SearchState(null, null, true)),
          )
          .shareValueDistinct(SearchState(<Movie>[].build(), null, false))
            ..listen(null).disposedBy(bag);
    }();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick movie'),
      ),
      body: Column(
        children: [
          _buildSearchView(),
          Expanded(child: _buildListView()),
        ],
      ),
    );
  }

  Widget _buildSearchView() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              maxLines: 1,
              maxLength: 100,
              onChanged: termS.add,
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  searchController.text = '';
                });
              }),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return RxStreamBuilder<SearchState>(
      stream: state$,
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
              errorText: 'Error: ${getErrorMessage(state.error)}',
              onPressed: () {
                print('Retry ${searchController.text}');
                retryS.add(searchController.text);
              },
            ),
          );
        }

        final list = state.movies;
        assert(list != null);
        if (list.isEmpty) {
          return Center(
            child: EmptyWidget(
              message: 'Empty movie',
            ),
          );
        }

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) => MovieCell(
            list[index],
            (_) {},
            (movie) {
              AppScaffold.of(context).pushNamed(
                AppShowTimePage.routeName,
                arguments: {
                  'theatre': widget.theatre,
                  'movie': movie,
                },
              );
            },
          ),
        );
      },
    );
  }
}

class SearchState {
  final BuiltList<Movie> movies;
  final Object error;
  final bool isLoading;

  SearchState(this.movies, this.error, this.isLoading);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchState &&
          runtimeType == other.runtimeType &&
          movies == other.movies &&
          error == other.error &&
          isLoading == other.isLoading;

  @override
  int get hashCode => movies.hashCode ^ error.hashCode ^ isLoading.hashCode;
}
