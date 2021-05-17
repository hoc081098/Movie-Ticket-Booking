import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:octo_image/octo_image.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../../domain/model/city.dart';
import '../../../domain/model/movie_and_showtimes.dart';
import '../../../domain/model/theatre.dart';
import '../../../domain/repository/city_repository.dart';
import '../../../domain/repository/movie_repository.dart';
import '../../../generated/l10n.dart';
import '../../../utils/utils.dart';
import '../../../utils/error.dart';
import '../../../utils/intl.dart';
import '../../app_scaffold.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/error_widget.dart';
import '../detail/movie_detail_page.dart';
import '../tickets/ticket_page.dart';

class ShowTimesPage extends StatefulWidget {
  final Theatre theatre;

  const ShowTimesPage({Key? key, required this.theatre}) : super(key: key);

  @override
  _ShowTimesPageState createState() => _ShowTimesPageState();
}

class _ShowTimesPageState extends State<ShowTimesPage>
    with AutomaticKeepAliveClientMixin<ShowTimesPage>, DisposeBagMixin {
  final dateFormat = DateFormat('dd/MM');
  final fullDateFormat = DateFormat.yMMMd();
  final showTimeDateFormat = DateFormat('hh:mm a');

  final startDay = startOfDay(DateTime.now());
  late List<DateTime> days;
  late BehaviorSubject<DateTime> selectedDayS;
  LoaderBloc<BuiltList<MovieAndShowTimes>>? bloc;

  @override
  void initState() {
    super.initState();

    selectedDayS = BehaviorSubject.seeded(startDay);
    selectedDayS.disposedBy(bag);
    days = [for (var i = 0; i <= 4; i++) startDay.add(Duration(days: i))];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bloc ??= () {
      final movieRepo = Provider.of<MovieRepository>(context);
      final emptyList = <MovieAndShowTimes>[].build();

      return LoaderBloc<BuiltList<MovieAndShowTimes>>(
        loaderFunction: () {
          final showTimesByDay$ =
              movieRepo.getShowTimesByTheatreId(widget.theatre.id);

          return Rx.combineLatest2(
              showTimesByDay$,
              selectedDayS,
              (
                BuiltMap<DateTime, BuiltList<MovieAndShowTimes>> showTimesByDay,
                DateTime day,
              ) =>
                  showTimesByDay[day] ?? emptyList);
        },
        logger: print,
        initialContent: emptyList,
      )..fetch();
    }();
  }

  @override
  void dispose() {
    bloc!.dispose();
    bloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final textTheme = Theme.of(context).textTheme;
    final weekDayStyle = textTheme.button!;
    final ddMMStyle = textTheme.subtitle1!.copyWith(fontSize: 15);
    final weekDaySelectedStyle = weekDayStyle.copyWith(color: Colors.white);
    final ddMMSelectedStyle = ddMMStyle.copyWith(color: Colors.white);
    final accentColor = Theme.of(context).accentColor;

    return SafeArea(
      child: Column(
        children: [
          Card(
            elevation: 5,
            shadowColor: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 8),
                RxStreamBuilder<DateTime>(
                  stream: selectedDayS,
                  builder: (context, selectedDay) {
                    return Row(
                      children: [
                        const SizedBox(width: 4),
                        for (final day in days)
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () => selectedDayS.add(day),
                              child: AnimatedContainer(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: day == selectedDay
                                      ? accentColor
                                      : Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      day == startDay
                                          ? S.of(context).today
                                          : weekdayOf(day),
                                      style: day == selectedDay
                                          ? weekDaySelectedStyle
                                          : weekDayStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      dateFormat.format(day),
                                      style: day == selectedDay
                                          ? ddMMSelectedStyle
                                          : ddMMStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 4),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                      '${S.of(context).today}, ${fullDateFormat.format(startDay)}'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              child: RxStreamBuilder<LoaderState<BuiltList<MovieAndShowTimes>>>(
                stream: bloc!.state$,
                builder: (context, data) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildBottom(data),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom(LoaderState<BuiltList<MovieAndShowTimes>> state) {
    if (state.error != null) {
      return MyErrorWidget(
        errorText:
            S.of(context).error_with_message(getErrorMessage(state.error!)),
        onPressed: bloc!.fetch,
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

    final list = state.content!;

    if (list.isEmpty) {
      return Center(
        child: EmptyWidget(
          message: S.of(context).emptyShowTimes,
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) => ShowTimeItem(
        key: ValueKey(list[index].movie.id),
        item: list[index],
        showTimeDateFormat: showTimeDateFormat,
        theatre: widget.theatre,
      ),
      separatorBuilder: (_, __) => const Divider(height: 0),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SelectCityWidget extends StatelessWidget {
  const SelectCityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cityRepo = Provider.of<CityRepository>(context);

    return Row(
      children: [
        const SizedBox(width: 16),
        Text(
          S.of(context).selectTheArea,
          style: textTheme.headline6!.copyWith(fontSize: 16),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: RxStreamBuilder<City>(
            stream: cityRepo.selectedCity$,
            builder: (context, selected) {
              return PopupMenuButton<City>(
                initialValue: selected,
                onSelected: cityRepo.change,
                offset: Offset(0, 56),
                itemBuilder: (BuildContext context) {
                  return [
                    for (final city in cityRepo.allCities)
                      PopupMenuItem<City>(
                        value: city,
                        child: Text(city.localizedName(context)),
                      )
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        selected.localizedName(context),
                        style: textTheme.subtitle1,
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ShowTimeItem extends StatelessWidget {
  final DateFormat showTimeDateFormat;
  final MovieAndShowTimes item;
  final Theatre theatre;

  ShowTimeItem(
      {Key? key,
      required this.item,
      required this.showTimeDateFormat,
      required this.theatre})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movie = item.movie;
    final showTimes = item.showTimes;
    final textTheme = Theme.of(context).textTheme;

    final gridView = GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      padding: const EdgeInsets.all(12),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.8,
      children: [
        for (final show in showTimes)
          InkWell(
            onTap: () =>
                AppScaffold.navigatorOfCurrentIndex(context).pushNamedX(
              TicketsPage.routeName,
              arguments: <String, dynamic>{
                'theatre': theatre,
                'showTime': show,
                'movie': movie,
                'fromMovieDetail': false,
              },
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color(0xffD1DBE2),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  showTimeDateFormat.format(show.start_time),
                  textAlign: TextAlign.center,
                  style: textTheme.subtitle1!.copyWith(
                    fontSize: 18,
                    color: const Color(0xff687189),
                  ),
                ),
              ),
            ),
          )
      ],
    );

    return InkWell(
      onTap: () {
        AppScaffold.navigatorOfCurrentIndex(context).pushNamedX(
          MovieDetailPage.routeName,
          arguments: movie,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          top: 12,
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: OctoImage(
                    image: NetworkImage(movie.posterUrl ?? ''),
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, event) {
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorBuilder: (context, e, s) {
                      return Center(
                        child: Icon(
                          Icons.error,
                          color: Theme.of(context).accentColor,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(movie.title),
                      const SizedBox(height: 4),
                      Text(
                        S.of(context).duration_minutes(movie.duration),
                        style: textTheme.caption!.copyWith(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
            gridView,
          ],
        ),
      ),
    );
  }
}
