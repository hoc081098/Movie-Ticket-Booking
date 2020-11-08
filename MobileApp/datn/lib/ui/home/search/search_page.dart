import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../../domain/model/movie.dart';
import '../../../domain/repository/city_repository.dart';
import '../../../domain/repository/movie_repository.dart';
import '../../../utils/error.dart';
import '../../../utils/streams.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/error_widget.dart';
import '../view_all/list_item.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/home/search';

  final String query;

  const SearchPage({Key key, @required this.query}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with DisposeBagMixin {
  final showtimeStartTimeS = StreamController<DateTime>();
  final showtimeEndTimeS = StreamController<DateTime>();
  final minReleasedDateS = StreamController<DateTime>();
  final maxReleasedDateS = StreamController<DateTime>();
  final minDurationS = StreamController<int>();
  final maxDurationS = StreamController<int>();
  final ageTypeS = StreamController<AgeType>();

  DistinctValueStream<DateTime> showtimeStartTime$;
  DistinctValueStream<DateTime> showtimeEndTime$;
  DistinctValueStream<DateTime> minReleasedDate$;
  DistinctValueStream<DateTime> maxReleasedDate$;
  DistinctValueStream<int> minDuration$;
  DistinctValueStream<int> maxDuration$;
  DistinctValueStream<AgeType> ageType$;

  LoaderBloc<BuiltList<Movie>> bloc;

  @override
  void initState() {
    super.initState();

    [
      showtimeStartTimeS,
      showtimeEndTimeS,
      minReleasedDateS,
      maxReleasedDateS,
      minDurationS,
      maxDurationS,
      ageTypeS
    ].disposedBy(bag);

    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));
    final end = now.add(const Duration(days: 30));

    showtimeStartTime$ = showtimeStartTimeS.stream
        .shareValueDistinct(start, sync: true)
          ..listenNull().disposedBy(bag);
    showtimeEndTime$ = showtimeEndTimeS.stream
        .shareValueDistinct(end, sync: true)
          ..listenNull().disposedBy(bag);

    minReleasedDate$ = minReleasedDateS.stream
        .shareValueDistinct(start, sync: true)
          ..listenNull().disposedBy(bag);
    maxReleasedDate$ = maxReleasedDateS.stream
        .shareValueDistinct(end, sync: true)
          ..listenNull().disposedBy(bag);

    minDuration$ = minDurationS.stream.shareValueDistinct(30, sync: true)
      ..listenNull().disposedBy(bag);
    maxDuration$ = maxDurationS.stream.shareValueDistinct(60 * 3, sync: true)
      ..listenNull().disposedBy(bag);

    ageType$ = ageTypeS.stream.shareValueDistinct(AgeType.P, sync: true)
      ..listenNull().disposedBy(bag);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bloc ??= () {
      final movieRepo = Provider.of<MovieRepository>(context);
      final cityRepo = Provider.of<CityRepository>(context);

      final loaderFunction = () => Rx.defer(
            () => movieRepo.search(
              query: widget.query,
              showtimeStartTime: showtimeStartTime$.value,
              showtimeEndTime: showtimeEndTime$.value,
              minReleasedDate: minReleasedDate$.value,
              maxReleasedDate: maxReleasedDate$.value,
              minDuration: minDuration$.value,
              maxDuration: maxDuration$.value,
              ageType: AgeType.P,
              location: cityRepo.selectedCity$.value.location,
            ),
          );

      return LoaderBloc<BuiltList<Movie>>(
        loaderFunction: loaderFunction,
        initialContent: const <Movie>[].build(),
        enableLogger: true,
      )..fetch();
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.query),
      ),
      body: RxStreamBuilder<LoaderState<BuiltList<Movie>>>(
        stream: bloc.state$,
        builder: (context, snapshot) {
          final state = snapshot.data;

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
                onPressed: bloc.fetch,
              ),
            );
          }

          final items = state.content;

          if (items.isEmpty) {
            return Center(
              child: EmptyWidget(
                message: 'Empty search result',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: bloc.refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) => ViewAllListItem(
                item: items[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
