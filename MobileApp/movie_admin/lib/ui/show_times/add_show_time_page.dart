import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:stream_loader/stream_loader.dart';
import 'package:tuple/tuple.dart';

import '../../domain/model/movie.dart';
import '../../domain/model/seat.dart';
import '../../domain/model/theatre.dart';
import '../../domain/repository/show_times_repository.dart';
import '../../domain/repository/ticket_repo.dart';
import '../../ui/show_times/ticket_page.dart' show ScreenWidget;
import '../../ui/widgets/age_type.dart';
import '../../ui/widgets/error_widget.dart';
import '../../utils/date_time.dart';
import '../../utils/utils.dart';
import '../app_scaffold.dart';
import '../widgets/empty_widget.dart';
import '../widgets/loading_button.dart';
import 'show_times_page.dart';

class AppShowTimePage extends StatefulWidget {
  static const routeName = '/show-times/add';

  final Theatre theatre;
  final Movie movie;

  const AppShowTimePage({Key key, @required this.theatre, @required this.movie})
      : super(key: key);

  @override
  _AppShowTimePageState createState() => _AppShowTimePageState();
}

class _AppShowTimePageState extends State<AppShowTimePage>
    with DisposeBagMixin {
  final startTimeFormat = DateFormat('dd/MM/yyyy, EE, hh:mm a');

  LoaderBloc<BuiltList<Seat>> bloc;
  DateTime startTime;
  final buttonStateS = BehaviorSubject.seeded(ButtonState.idle);
  final prices = ValueSubject<List<Tuple2<Seat, int>>>(null);

  @override
  void initState() {
    super.initState();
    buttonStateS.disposedBy(bag);
    prices.disposedBy(bag);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bloc ??= () {
      final b = LoaderBloc(
        loaderFunction: () => Provider.of<TicketRepository>(context)
            .getSeatsByTheatreId(widget.theatre.id),
        logger: print,
      );

      b.state$.listen((event) {
        final tuples = event.content
            ?.map((s) => Tuple2(s, 50000 * (s.count ?? 1)))
            ?.toList(growable: false);
        prices.add(tuples);
      }).disposedBy(bag);

      return b..fetch();
    }();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RxStreamBuilder<LoaderState<BuiltList<Seat>>>(
        stream: bloc.state$,
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: SizedBox(
                width: 56,
                height: 56,
                child: LoadingIndicator(
                  color: Theme.of(context).accentColor,
                  indicatorType: Indicator.ballClipRotatePulse,
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

          final builtMap = BuiltMap.of(
            Map.fromEntries(
              state.content.map((t) => MapEntry(t.id, t)),
            ),
          );

          final marginTop = MediaQuery.of(context).padding.top + 8;

          return Stack(
            children: [
              Positioned.fill(
                bottom: 0,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        height: marginTop + 32,
                        width: double.infinity,
                        color: const Color(0xffE9CBD1).withOpacity(0.2),
                      ),
                    ),
                    const ScreenWidget(),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 16,
                      ),
                    ),
                    SeatsGridWidget(
                      tickets: state.content,
                      tapTicket: (ticket) {
                        if (ticket == null) {
                          throw Exception('Something was wrong');
                        }
                        print('Tapped $ticket');
                      },
                    ),
                    LegendsWidget(),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(
                          height: 1,
                          color: Color(0xffD1DBE2),
                        ),
                      ),
                    ),
                    BottomWidget(
                      movie: widget.movie,
                      theatre: widget.theatre,
                      tickets: builtMap,
                    ),
                    _buildReleasedDayTextField(),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 16,
                      ),
                    ),
                    _buildAvai(),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 8,
                      ),
                    ),
                    _buildChangeAllPrices(),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 16,
                      ),
                    ),
                    _buildListTickets(),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 72,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: marginTop,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.32),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => AppScaffold.of(context).maybePop(),
                      customBorder: CircleBorder(),
                      splashColor: Colors.white30,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildLoadingButton(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvai() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: RaisedButton(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.deepPurpleAccent)),
          onPressed: () {
            final startTime = this.startTime;
            print(startTime);
            if (startTime == null || !startTime.isAfter(DateTime.now())) {
              context.showSnackBar('Invalid start time');
              return;
            }

            final repo = Provider.of<ShowTimesRepository>(context);
            final id = widget.theatre.id;
            final day = startTime;

            showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text('Available periods'),
                  content: LoaderWidget<List<Tuple2<DateTime, DateTime>>>(
                    builder: (context, state, bloc) {
                      if (state.error != null) {
                        return Container(
                          color: Color(0xFFFCFCFC),
                          constraints: BoxConstraints.expand(height: 250),
                          child: MyErrorWidget(
                            errorText: 'Error: ${getErrorMessage(state.error)}',
                            onPressed: bloc.fetch,
                          ),
                        );
                      }

                      if (state.isLoading) {
                        return Container(
                          color: Color(0xFFFCFCFC),
                          constraints: BoxConstraints.expand(height: 250),
                          child: Center(
                            child: SizedBox(
                              width: 64,
                              height: 64,
                              child: LoadingIndicator(
                                indicatorType: Indicator.ballClipRotatePulse,
                              ),
                            ),
                          ),
                        );
                      }

                      final movies = state.content;

                      if (movies.isEmpty) {
                        return Container(
                          color: Color(0xFFFCFCFC),
                          constraints: BoxConstraints.expand(height: 250),
                          child: Center(
                            child:
                                EmptyWidget(message: 'Empty available period'),
                          ),
                        );
                      }

                      final startTimeFormat = DateFormat('hh:mm a, dd/MM/yyyy');
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final i in movies) ...[
                              Row(
                                children: [
                                  Icon(Icons.access_time),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'From ${startTimeFormat.format(i.item1)}',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'From ${startTimeFormat.format(i.item2)}',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ]
                          ],
                        ),
                      );
                    },
                    blocProvider: () => LoaderBloc(
                      loaderFunction: () =>
                          Rx.fromCallable(() => repo.availablePeriods(id, day)),
                      logger: print,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(dialogContext)
                            .pop(); // Dismiss alert dialog
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Padding(
              padding: EdgeInsets.all(10), child: Text('Available periods')),
        ),
      ),
    );
  }

  Widget _buildChangeAllPrices() {
    return RxStreamBuilder<List<Tuple2<Seat, int>>>(
        stream: prices,
        builder: (context, data) {
          if (data == null) {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }

          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.deepPurpleAccent)),
                onPressed: () async {
                  final price = await pickPrice(data.first.item2);
                  if (price == null) {
                    return;
                  }

                  prices.add([
                    for (final t in prices.value) Tuple2(t.item1, price),
                  ]);
                },
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Change all fares')),
              ),
            ),
          );
        });
  }

  Widget _buildReleasedDayTextField() {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          SizedBox(width: 8),
          Text(
            'Start time: ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: DateTimeField(
              initialValue: startTime,
              format: startTimeFormat,
              readOnly: true,
              onShowPicker: (context, currentValue) async {
                final now = DateTime.now();

                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate:
                      currentValue ?? now.add(const Duration(minutes: 5)),
                  lastDate: DateTime(2100),
                  selectableDayPredicate: (date) => date.isAfter(
                      startOfDay(now).subtract(const Duration(days: 1))),
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
              },
              validator: (date) {
                if (date == null) {
                  return 'Missing start time';
                }
                if (date.isAfter(DateTime.now())) {
                  return null;
                }
                return 'Invalid start time';
              },
              onChanged: (v) => startTime = v,
              resetIcon: Icon(Icons.delete, color: Colors.deepPurpleAccent),
              decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8.0),
                    child: Icon(
                      Icons.date_range,
                      color: Colors.deepPurpleAccent,
                      size: 16,
                    ),
                  ),
                  labelText: 'Start time',
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 13),
                  fillColor: Colors.deepPurpleAccent,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.deepPurpleAccent)),
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 13)),
            ),
          ),
          SizedBox(width: 8)
        ],
      ),
    );
  }

  void submit() async {
    final startTime = this.startTime;
    print(startTime);
    if (startTime == null || !startTime.isAfter(DateTime.now())) {
      context.showSnackBar('Invalid start time');
      return;
    }
    final tickets = prices.value;
    if (!tickets.every((element) => element.item2 > 0)) {
      context.showSnackBar('Invalid price');
      return;
    }

    final repo = Provider.of<ShowTimesRepository>(context);
    buttonStateS.add(ButtonState.loading);

    try {
      await repo.addShowTime(
        movieId: widget.movie.id,
        theatreId: widget.theatre.id,
        startTime: startTime,
        tickets: [for (final t in tickets) Tuple2(t.item1.id, t.item2)],
      );
      if (mounted) {
        buttonStateS.add(ButtonState.success);
      }
      context.showSnackBar('Added successfully!');
      await delay(500);
      await AppScaffold.of(context)
          .popUntil(ModalRoute.withName(ShowTimesPage.routeName));
    } catch (e, s) {
      print(e);
      print(s);

      context.showSnackBar('Error ${getErrorMessage(e)}');

      if (mounted) {
        buttonStateS.add(ButtonState.fail);
        await delay(3000);
        buttonStateS.add(ButtonState.idle);
      }
    }
  }

  Widget _buildLoadingButton() {
    return RxStreamBuilder(
      stream: buttonStateS,
      builder: (ctx, snap) {
        return Container(
          height: 72,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
            ),
          ]),
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                ),
                Expanded(
                  child: ProgressButton.icon(
                    iconedButtons: {
                      ButtonState.idle: IconedButton(
                        text: 'ADD',
                        icon: Icon(
                          Icons.update,
                          color: Colors.white,
                        ),
                        color: Colors.deepPurple.shade500,
                      ),
                      ButtonState.loading: IconedButton(
                        text: 'Loading',
                        color: Colors.deepPurple.shade700,
                      ),
                      ButtonState.fail: IconedButton(
                        text: 'Failed',
                        icon: Icon(Icons.cancel, color: Colors.white),
                        color: Colors.red.shade300,
                      ),
                      ButtonState.success: IconedButton(
                        text: 'Success',
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        color: Colors.green.shade400,
                      )
                    },
                    onPressed: submit,
                    state: snap.data,
                  ),
                ),
                SizedBox(
                  width: 32,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');

  Widget _buildListTickets() {
    return RxStreamBuilder<List<Tuple2<Seat, int>>>(
      stream: prices,
      builder: (context, data) {
        if (data == null) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = data[index];
              return ListTile(
                title: Text.rich(
                  TextSpan(
                    text: 'Seat ',
                    children: [
                      TextSpan(
                          text: item.item1.row,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.primaries[
                                (item.item1.row.codeUnitAt(0) -
                                        'A'.codeUnitAt(0)) %
                                    Colors.primaries.length],
                          )),
                      TextSpan(
                          text: item.item1.column.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.primaries[
                                item.item1.column % Colors.primaries.length],
                          )),
                    ],
                  ),
                ),
                subtitle:
                    Text('Price: ${currencyFormat.format(item.item2)} VND'),
                isThreeLine: false,
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final price = await pickPrice(item.item2);

                    if (price == null) {
                      return;
                    }

                    prices.add([
                      for (final t in prices.value)
                        if (t.item1.id == item.item1.id)
                          t
                        else
                          Tuple2(t.item1, price),
                    ]);
                  },
                ),
              );
            },
            childCount: data.length,
          ),
        );
      },
    );
  }

  Future<int> pickPrice(int initPrice) {
    return showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        int price;

        return AlertDialog(
          title: Text('Edit price'),
          content: TextFormField(
            autovalidateMode: AutovalidateMode.always,
            initialValue: initPrice.toString(),
            autocorrect: true,
            keyboardType: TextInputType.number,
            maxLines: 1,
            onChanged: (v) => price = int.tryParse(v),
            validator: (v) {
              final p = int.tryParse(v);
              if (p == null || p <= 0) {
                return 'Invalid price';
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              prefixIcon: const Padding(
                padding: EdgeInsetsDirectional.only(end: 8.0),
                child: Icon(Icons.money),
              ),
              labelText: 'Ticket price',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (price == null || price <= 0) {
                  Navigator.of(dialogContext).pop();
                  return;
                }

                Navigator.of(dialogContext).pop(price);
              },
            ),
          ],
        );
      },
    );
  }
}

class SeatsGridWidget extends StatefulWidget {
  final BuiltList<Seat> tickets;
  final Function1<Seat, void> tapTicket;

  const SeatsGridWidget({
    Key key,
    @required this.tickets,
    @required this.tapTicket,
  }) : super(key: key);

  @override
  _SeatsGridWidgetState createState() => _SeatsGridWidgetState();
}

class _SeatsGridWidgetState extends State<SeatsGridWidget> {
  int maxX;
  int maxY;
  Map<SeatCoordinates, Seat> ticketByCoordinates;

  @override
  void initState() {
    super.initState();

    init();
  }

  void init() {
    final seats = widget.tickets;
    maxX = seats.map((s) => s.coordinates.x + s.count - 1).reduce(math.max);
    maxY = seats.map((s) => s.coordinates.y).reduce(math.max);

    ticketByCoordinates =
        Map.fromEntries(widget.tickets.map((t) => MapEntry(t.coordinates, t)));
  }

  @override
  void didUpdateWidget(SeatsGridWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tickets != widget.tickets) {
      init();
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthExtra = 1.4;
    final widthPerSeat =
        (MediaQuery.of(context).size.width * widthExtra - (maxX + 2) * 1) /
            (maxX + 2);
    final totalWidth = MediaQuery.of(context).size.width * widthExtra;

    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: widthPerSeat * maxY * 1.2,
              width: totalWidth,
              child: Center(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: maxY,
                  itemBuilder: (context, row) {
                    return Container(
                      height: widthPerSeat,
                      width: totalWidth,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: maxX + 2,
                        itemBuilder: (context, col) {
                          return buildItem(
                            context,
                            row,
                            col,
                            widthPerSeat,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(
    BuildContext context,
    int y,
    int x,
    double widthPerSeat,
  ) {
    final row = String.fromCharCode('A'.codeUnitAt(0) + y);

    if (x == 0) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xffE9E6CB),
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.all(0.5),
        width: widthPerSeat,
        height: widthPerSeat,
        child: Center(
          child: Text(
            row,
            style: Theme.of(context).textTheme.caption.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff687189),
                ),
          ),
        ),
      );
    }

    x--;
    final coordinates = SeatCoordinates.from(x: x, y: y);
    final ticket = ticketByCoordinates[coordinates];
    if (ticket == null) {
      int prevCount;
      SeatCoordinates prevCoords;
      var prevX = x - 1;
      while (prevX >= 0) {
        prevCoords = SeatCoordinates.from(x: prevX, y: y);
        prevCount = ticketByCoordinates[prevCoords]?.count;
        if (prevCount != null) {
          break;
        }
        prevX--;
      }

      return prevCount != null &&
              prevCount > 1 &&
              (coordinates.x - prevCoords.x + 1) <= prevCount
          ? const SizedBox(width: 0, height: 0)
          : Container(
              margin: const EdgeInsets.all(0.5),
              width: widthPerSeat,
              height: widthPerSeat,
            );
    } else {
      return SeatWidget(
        seat: ticket,
        tapTicket: widget.tapTicket,
        widthPerSeat: widthPerSeat,
      );
    }
  }
}

class SeatWidget extends StatelessWidget {
  final Seat seat;
  final Function1<Seat, void> tapTicket;
  final double widthPerSeat;

  const SeatWidget({
    Key key,
    this.seat,
    this.tapTicket,
    this.widthPerSeat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = widthPerSeat * seat.count + (seat.count - 1) * 1;

    return InkWell(
      onTap: () => tapTicket(seat),
      child: Container(
        margin: const EdgeInsets.all(0.5),
        width: width,
        height: widthPerSeat,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xffCBD7E9),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '${seat.row}${seat.column}',
            style: Theme.of(context).textTheme.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff687189),
                ),
          ),
        ),
      ),
    );
  }
}

class LegendsWidget extends StatelessWidget {
  const LegendsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthPerSeat = MediaQuery.of(context).size.width / 12;
    final textStyle = Theme.of(context).textTheme.subtitle2.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(0.5),
                  width: widthPerSeat,
                  height: widthPerSeat,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xffCBD7E9),
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Seat',
                  style: textStyle,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(0.5),
                  width: widthPerSeat * 2,
                  height: widthPerSeat,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xffCBD7E9),
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Doubled seat',
                  style: textStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomWidget extends StatelessWidget {
  final startTimeFormat = DateFormat('dd/MM/yy, EE, hh:mm a');
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');

  final Theatre theatre;
  final Movie movie;
  final BuiltMap<String, Seat> tickets;

  BottomWidget({
    Key key,
    @required this.theatre,
    @required this.movie,
    @required this.tickets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final textStyle = textTheme.subtitle1.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: const Color(0xff98A8BA),
    );

    final textStyle2 = textTheme.subtitle1.copyWith(
      fontSize: 16,
      color: const Color(0xff687189),
      fontWeight: FontWeight.w600,
    );

    const h = 128.0;
    const w = h / 1.3;

    final movieTitleStyle = textTheme.headline4.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: const Color(0xff687189),
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        movie.title,
                        style: movieTitleStyle,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          AgeTypeWidget(ageType: movie.ageType),
                          const SizedBox(width: 8),
                          Text('${movie.duration} minutes'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: w,
                    height: h,
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
                              style: textTheme.subtitle2.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(text: 'Theatre: ', style: textStyle, children: [
                TextSpan(
                  text: theatre.name,
                  style: textStyle2,
                ),
              ]),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(text: 'Address: ', style: textStyle, children: [
                TextSpan(
                  text: theatre.address,
                  style: textStyle2,
                ),
              ]),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Divider(
                height: 1,
                color: Color(0xffD1DBE2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
