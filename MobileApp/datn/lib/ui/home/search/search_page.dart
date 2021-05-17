import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../../domain/model/category.dart';
import '../../../domain/model/movie.dart';
import '../../../domain/repository/city_repository.dart';
import '../../../domain/repository/movie_repository.dart';
import '../../../generated/l10n.dart';
import '../../../utils/error.dart';
import '../../../utils/utils.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/error_widget.dart';
import '../view_all/list_item.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/home/search';

  final String query;

  const SearchPage({Key? key, required this.query}) : super(key: key);

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

  late DistinctValueStream<DateTime> showtimeStartTime$;
  late DistinctValueStream<DateTime> showtimeEndTime$;
  late DistinctValueStream<DateTime> minReleasedDate$;
  late DistinctValueStream<DateTime> maxReleasedDate$;
  late DistinctValueStream<int> minDuration$;
  late DistinctValueStream<int> maxDuration$;
  late DistinctValueStream<AgeType> ageType$;

  LoaderBloc<BuiltList<Movie>>? bloc;
  BuiltList<Category>? cats;
  BuiltSet<String>? selectedCatIds;

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
          ..collect().disposedBy(bag);
    showtimeEndTime$ = showtimeEndTimeS.stream
        .shareValueDistinct(end, sync: true)
          ..collect().disposedBy(bag);

    minReleasedDate$ = minReleasedDateS.stream
        .shareValueDistinct(start, sync: true)
          ..collect().disposedBy(bag);
    maxReleasedDate$ = maxReleasedDateS.stream
        .shareValueDistinct(end, sync: true)
          ..collect().disposedBy(bag);

    minDuration$ = minDurationS.stream.shareValueDistinct(30, sync: true)
      ..collect().disposedBy(bag);
    maxDuration$ = maxDurationS.stream.shareValueDistinct(60 * 3, sync: true)
      ..collect().disposedBy(bag);

    ageType$ = ageTypeS.stream.shareValueDistinct(AgeType.P, sync: true)
      ..collect().disposedBy(bag);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bloc ??= () {
      final movieRepo = Provider.of<MovieRepository>(context);
      final cityRepo = Provider.of<CityRepository>(context);

      final loaderFunction = () => Rx.defer(
            () {
              final selectedCatIds = this.selectedCatIds!;

              print('>>>> FETCH ${ageType$.value}');
              print('>>>> FETCH ${minDuration$.value}');
              print('>>>> FETCH ${maxDuration$.value}');
              print('>>>> FETCH ${showtimeStartTime$.value}');
              print('>>>> FETCH ${showtimeEndTime$.value}');
              print('>>>> FETCH ${minReleasedDate$.value}');
              print('>>>> FETCH ${maxReleasedDate$.value}');
              print('>>>> FETCH ${selectedCatIds.length}');

              return movieRepo.search(
                query: widget.query,
                showtimeStartTime: showtimeStartTime$.value,
                showtimeEndTime: showtimeEndTime$.value,
                minReleasedDate: minReleasedDate$.value,
                maxReleasedDate: maxReleasedDate$.value,
                minDuration: minDuration$.value,
                maxDuration: maxDuration$.value,
                ageType: ageType$.value,
                location: cityRepo.selectedCity$.value.location,
                selectedCategoryIds: selectedCatIds,
              );
            },
          );

      final _bloc = LoaderBloc<BuiltList<Movie>>(
        loaderFunction: loaderFunction,
        refresherFunction: loaderFunction,
        initialContent: const <Movie>[].build(),
        logger: print,
      );

      movieRepo.getCategories().listen((event) {
        cats = event;
        selectedCatIds = event.map((c) => c.id).toBuiltSet();
        _bloc.fetch();
      }).disposedBy(bag);

      return _bloc;
    }();
  }

  @override
  Widget build(BuildContext context) {
    final movieRepo = Provider.of<MovieRepository>(context);
    final bloc = this.bloc!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.query),
        actions: [
          RxStreamBuilder<LoaderState<BuiltList<Movie>>>(
            stream: bloc.state$,
            builder: (context, state) {
              if (state.isLoading) {
                return const SizedBox();
              }

              return IconButton(
                icon: Icon(Icons.filter_alt_outlined),
                onPressed: () => showFilterSheet(movieRepo),
              );
            },
          ),
        ],
      ),
      body: RxStreamBuilder<LoaderState<BuiltList<Movie>>>(
        stream: bloc.state$,
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
                onPressed: bloc.fetch,
              ),
            );
          }

          final items = state.content!;

          if (items.isEmpty) {
            return Center(
              child: EmptyWidget(
                message: S.of(context).emptySearchResult,
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                // margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                    ),
                  ],
                ),
                height: 48,
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Text(
                      S.of(context).count_movie(items.length),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 16,
                            color: const Color(0xff687189),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: state.isLoading
                      ? () => SynchronousFuture(null)
                      : bloc.refresh,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) => ViewAllListItem(
                      item: items[index],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void showFilterSheet(MovieRepository movieRepo) async {
    if (cats == null) {
      await movieRepo.getCategories().forEach((event) => cats = event);
      selectedCatIds = cats!.map((c) => c.id).toBuiltSet();
    }
    if (!mounted) {
      return;
    }

    final apply = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 1,
        initialChildSize: 0.4,
        minChildSize: 0.2,
        builder: (context, scrollController) =>
            _FilterBottomSheet(this, scrollController),
      ),
    );

    if (identical(apply, true)) {
      print('>>>> ${ageType$.value}');
      print('>>>> ${minDuration$.value}');
      print('>>>> ${maxDuration$.value}');
      print('>>>> ${showtimeStartTime$.value}');
      print('>>>> ${showtimeEndTime$.value}');
      print('>>>> ${minReleasedDate$.value}');
      print('>>>> ${maxReleasedDate$.value}');
      print('>>>> ${selectedCatIds!.length}');

      bloc!.fetch();
    }
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final _SearchPageState searchPageState;
  final ScrollController scrollController;

  _FilterBottomSheet(this.searchPageState, this.scrollController);

  @override
  __FilterBottomSheetState createState() => __FilterBottomSheetState();
}

class __FilterBottomSheetState extends State<_FilterBottomSheet> {
  late AgeType ageType;
  late int minDuration;
  late int maxDuration;
  late DateTime showtimeStartTime;
  late DateTime showtimeEndTime;
  late DateTime minReleasedDate;
  late DateTime maxReleasedDate;

  late final List<DropdownMenuItem<int>> durations = [
    for (var d = 30; d <= 12 * 60; d += 10)
      DropdownMenuItem(
        value: d,
        child: Text(d.toString()),
      ),
  ];
  late List<DropdownMenuItem<AgeType>> ageTypes = [
    for (final t in AgeType.values)
      DropdownMenuItem(
        value: t,
        child: Text(describeEnum(t)),
      ),
  ];

  final dateFormat = DateFormat('dd/MM/yy, hh:mm a');

  late Set<String> selectedCatIds;
  late BuiltList<Category> cats;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    final state = widget.searchPageState;

    ageType = state.ageType$.value;
    minDuration = state.minDuration$.value;
    maxDuration = state.maxDuration$.value;
    showtimeStartTime = state.showtimeStartTime$.value;
    showtimeEndTime = state.showtimeEndTime$.value;
    minReleasedDate = state.minReleasedDate$.value;
    maxReleasedDate = state.maxReleasedDate$.value;
    selectedCatIds = state.selectedCatIds!.toSet();
    cats = state.cats!;
  }

  @override
  void didUpdateWidget(_FilterBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    init();
  }

  @override
  Widget build(BuildContext context) {
    const visualDensity = VisualDensity(horizontal: -3, vertical: -3);
    const divider = Divider(height: 0);
    const divider2 = Divider(height: 8);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        controller: widget.scrollController,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                S.of(context).searchFilter,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 18,
                      color: const Color(0xff687189),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          Center(
            child: Row(
              children: [
                const Spacer(),
                Text(S.of(context).ageType),
                const SizedBox(width: 16),
                DropdownButton<AgeType>(
                  value: ageType,
                  items: ageTypes,
                  onChanged: (val) {
                    if (val == null) {
                      return;
                    }
                    setState(() => ageType = val);
                  },
                  underline: divider,
                ),
                const Spacer(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(S.of(context).durationMinsFrom),
              DropdownButton<int>(
                value: minDuration,
                items: durations,
                onChanged: (val) {
                  if (val == null) {
                    return;
                  }
                  if (val > maxDuration) {
                    return context.showSnackBar(
                        S.of(context).mustBeLessThanOrEqualToMaxDuration);
                  }
                  setState(() => minDuration = val);
                },
                underline: divider,
              ),
              Text(S.of(context).to),
              DropdownButton<int>(
                value: maxDuration,
                items: durations,
                onChanged: (val) {
                  if (val == null) {
                    return;
                  }
                  if (val < minDuration) {
                    return context.showSnackBar(
                        S.of(context).mustBeGreaterThanOrEqualToMinDuration);
                  }
                  setState(() => maxDuration = val);
                },
                underline: divider,
              ),
            ],
          ),
          divider2,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(S.of(context).showtimeStartFrom),
              TextButton(
                onPressed: () async {
                  final newStart = await pickDateTime(showtimeStartTime);
                  if (newStart == null) {
                    return;
                  }
                  if (!newStart.isBefore(showtimeEndTime)) {
                    return context.showSnackBar(
                        S.of(context).showtimeStartTimeMustBeBeforeEndTime);
                  }
                  setState(() => showtimeStartTime = newStart);
                },
                style: TextButton.styleFrom(
                  visualDensity: visualDensity,
                ),
                child: Text(dateFormat.format(showtimeStartTime)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(S.of(context).to),
              TextButton(
                onPressed: () async {
                  final newEnd = await pickDateTime(showtimeEndTime);
                  if (newEnd == null) {
                    return;
                  }
                  if (!newEnd.isAfter(showtimeStartTime)) {
                    return context.showSnackBar(
                        S.of(context).showtimeEndTimeMustBeAfterStartTime);
                  }
                  setState(() => showtimeEndTime = newEnd);
                },
                style: TextButton.styleFrom(
                  visualDensity: visualDensity,
                ),
                child: Text(dateFormat.format(showtimeEndTime)),
              ),
            ],
          ),
          ////////////////////////
          divider2,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(S.of(context).releasedDateFrom),
              TextButton(
                onPressed: () async {
                  final newStart = await pickDateTime(minReleasedDate);
                  if (newStart == null) {
                    return;
                  }
                  if (!newStart.isBefore(maxReleasedDate)) {
                    return context.showSnackBar(
                        S.of(context).mustBeBeforeMaxReleasedDate);
                  }
                  setState(() => minReleasedDate = newStart);
                },
                style: TextButton.styleFrom(
                  visualDensity: visualDensity,
                ),
                child: Text(dateFormat.format(minReleasedDate)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(S.of(context).to),
              TextButton(
                onPressed: () async {
                  final newEnd = await pickDateTime(maxReleasedDate);
                  if (newEnd == null) {
                    return;
                  }
                  if (!newEnd.isAfter(minReleasedDate)) {
                    return context
                        .showSnackBar(S.of(context).mustBeAfterMinReleasedDate);
                  }
                  setState(() => maxReleasedDate = newEnd);
                },
                style: TextButton.styleFrom(
                  visualDensity: visualDensity,
                ),
                child: Text(dateFormat.format(maxReleasedDate)),
              ),
            ],
          ),
          divider2,
          Wrap(
            spacing: 8,
            children: [
              for (final cat in cats)
                FilterChip(
                  selectedColor: Theme.of(context).accentColor.withOpacity(0.3),
                  label: Text(cat.name),
                  labelStyle: ChipTheme.of(context).labelStyle.copyWith(
                        fontSize: 11,
                      ),
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        selectedCatIds.add(cat.id);
                      } else {
                        selectedCatIds.remove(cat.id);
                      }
                    });
                  },
                  selected: selectedCatIds.contains(cat.id),
                ),
            ],
          ),
          Container(
            color: Colors.white,
            child: ButtonTheme(
              height: 38,
              child: Row(
                children: [
                  const SizedBox(width: 32),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).disabledColor,
                        primary: Theme.of(context).colorScheme.onError,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38 / 2),
                        ),
                      ),
                      child: Text(S.of(context).cancel),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        apply();
                        Navigator.of(context).pop(true);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        primary: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38 / 2),
                        ),
                      ),
                      child: Text(S.of(context).apply),
                    ),
                  ),
                  const SizedBox(width: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void apply() {
    final state = widget.searchPageState;

    state.ageTypeS.add(ageType);

    state.minDurationS.add(minDuration);
    state.maxDurationS.add(maxDuration);

    state.showtimeStartTimeS.add(showtimeStartTime);
    state.showtimeEndTimeS.add(showtimeEndTime);

    state.minReleasedDateS.add(minReleasedDate);
    state.maxReleasedDateS.add(maxReleasedDate);

    state.selectedCatIds = selectedCatIds.build();
  }

  Future<DateTime?> pickDateTime(DateTime initialDate) async {
    const sixMonths = Duration(days: 30 * 6);
    final now = DateTime.now();

    final date = await showDatePicker(
      initialDate: initialDate,
      context: context,
      firstDate: now.subtract(sixMonths),
      lastDate: now.add(sixMonths),
    );

    if (date == null) {
      return null;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(date),
    );

    if (time == null) {
      return null;
    }

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}
