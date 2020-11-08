import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repository/movie_repository.dart';
import '../../utils/streams.dart';
import '../app_scaffold.dart';
import 'search/search_page.dart';

class MovieSearchDelegate extends SearchDelegate<String> {
  final MovieRepository movieRepo;

  final bag = DisposeBag();
  final queryS = PublishSubject<String>();
  DistinctValueStream<BuiltList<String>> suggestions$;

  MovieSearchDelegate(this.movieRepo) {
    suggestions$ = Rx.fromCallable(movieRepo.getQueries).exhaustMap((queries) {
      final filter = (String queryLowered) => queries
          .where((value) => value.toLowerCase().contains(queryLowered))
          .toBuiltList();

      return queryS
          .map((query) => query.toLowerCase())
          .distinct()
          .map(filter)
          .startWith(queries);
    }).shareValueDistinct(null, sync: true)
      ..listenNull().disposedBy(bag);

    queryS.disposedBy(bag);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => disposeAndClose(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print('buildResults');

    final nav = AppScaffold.of(context);
    final query = this.query;

    if (query.isNotEmpty) {
      scheduleMicrotask(() {
        disposeAndClose(context);
        toSearchPage(context, query, nav);
      });
    }

    return const SizedBox();
  }

  void toSearchPage(BuildContext context, String query, NavigatorState nav) {
    nav.pushNamed(
      SearchPage.routeName,
      arguments: query,
    );

    movieRepo
        .saveSearchQuery(query)
        .then((_) => print('[DEBUG] Save $query done'))
        .catchError((e, s) => print('[DEBUG] Save $query $e $s'));
  }

  void disposeAndClose(BuildContext context) {
    bag.dispose();
    close(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print('buildSuggestions');

    final nav = AppScaffold.of(context);
    queryS.add(query);

    return RxStreamBuilder<BuiltList<String>>(
      stream: suggestions$,
      builder: (context, snapshot) {
        final data = snapshot.data;

        if (data == null) {
          return const SizedBox();
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(data[index]),
              onTap: () {
                disposeAndClose(context);
                toSearchPage(context, data[index], nav);
              },
            );
          },
        );
      },
    );
  }
}
