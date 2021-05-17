import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../../domain/model/movie.dart';
import '../../../domain/model/seat.dart';
import '../../../domain/model/show_time.dart';
import '../../../domain/model/theatre.dart';
import '../../../domain/model/ticket.dart';
import '../../../domain/model/user.dart';
import '../../../domain/repository/reservation_repository.dart';
import '../../../domain/repository/ticket_repository.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../generated/l10n.dart';
import '../../../utils/error.dart';
import '../../../utils/utils.dart';
import '../../app_scaffold.dart';
import '../../widgets/age_type.dart';
import '../../widgets/error_widget.dart';
import '../detail/movie_detail_page.dart';
import '../showtimes_by_theatre/show_time_by_theatre_page.dart';
import 'combo_page.dart';

class TicketsCountDownTimerBlocProvider {
  static TicketsCountDownTimerBlocProvider? _instance;

  TicketsCountDownTimerBloc? _bloc;
  bool? _fromDetailPage;
  var _destroyed = false;
  var _initialized = false;

  TicketsCountDownTimerBlocProvider._();

  factory TicketsCountDownTimerBlocProvider.shared() =>
      _instance ??= TicketsCountDownTimerBlocProvider._();

  void _init(TicketsCountDownTimerBloc bloc, bool fromDetailPage) {
    _bloc = bloc;
    _fromDetailPage = fromDetailPage;
    _initialized = true;
  }

  TicketsCountDownTimerBloc get bloc {
    if (!_initialized) throw StateError('Not init');
    if (_destroyed || _bloc == null) throw StateError('Destroyed');
    return _bloc!;
  }

  bool get fromDetailPage {
    if (!_initialized) throw StateError('Not init');
    if (_destroyed || _fromDetailPage == null) throw StateError('Destroyed');
    return _fromDetailPage!;
  }

  void _destroy() {
    _bloc = null;
    _fromDetailPage = null;
    _destroyed = true;
    _instance = null;
  }
}

class TicketsCountDownTimerBloc extends BaseBloc {
  static const maxDuration = Duration(minutes: 5);

  ///
  final bag = DisposeBag();
  final _startS = PublishSubject<void>(sync: true);
  final _timeoutS = PublishSubject<void>(sync: true);
  late DistinctValueConnectableStream<String?> _countdown$;

  ///
  ValueStream<String?> get countDown$ => _countdown$;

  Stream<void> get timeout$ => _timeoutS;

  void start() => _startS.add(null);

  TicketsCountDownTimerBloc() {
    _countdown$ = _startS
        .map((_) => DateTime.now().add(maxDuration))
        .take(1)
        .switchMap<String?>(
          (endTime) => Stream<void>.periodic(const Duration(seconds: 1))
              .startWith(null)
              .map((_) => DateTime.now())
              .takeWhileInclusive((d) => d.isBefore(endTime))
              .map(((time) => endTime.difference(time)).pipe(_formatDuration))
              .concatWith(
            [
              Stream.value('00:00').doOnListen(() => _timeoutS.add(null)),
            ],
          ),
        )
        .publishValueDistinct(null);

    _countdown$.connect().disposedBy(bag);
  }

  @override
  void dispose() => bag.dispose();

  static String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).twoDigits();
    final s = d.inSeconds.remainder(60).twoDigits();
    return '$m:$s';
  }
}

extension on num {
  String twoDigits() => toString().padLeft(2, '0');
}

class TicketsPage extends StatefulWidget {
  static const routeName = 'home/detail/tickets';

  final ShowTime showTime;
  final Theatre theatre;
  final Movie movie;
  final bool fromMovieDetail;

  const TicketsPage({
    Key? key,
    required this.showTime,
    required this.movie,
    required this.theatre,
    required this.fromMovieDetail,
  }) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> with DisposeBagMixin {
  LoaderBloc<BuiltList<Ticket>>? bloc;
  final countDownTimerBloc = TicketsCountDownTimerBloc();
  final selectedTicketIdsS = BehaviorSubject.seeded(BuiltList.of(<String>[]));
  Object? listenToken;

  @override
  void initState() {
    super.initState();

    selectedTicketIdsS
        .listen((value) => print('SELECTED COUNT: ${value.length}'))
        .disposedBy(bag);
    selectedTicketIdsS.disposedBy(bag);

    TicketsCountDownTimerBlocProvider.shared()._init(
      countDownTimerBloc,
      widget.fromMovieDetail,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    listenToken ??=
        countDownTimerBloc.timeout$.listen(_showTimeoutDialog).disposedBy(bag);

    bloc ??= () {
      final ticketRepository = Provider.of<TicketRepository>(context);
      final reservationRepository = Provider.of<ReservationRepository>(context);

      final loaderFunction = () => ticketRepository
          .getTicketsByShowTimeId(widget.showTime.id)
          .exhaustMap(
            (tickets) => reservationRepository
                .watchReservedTicket(widget.showTime.id)
                .scan<BuiltList<Ticket>>(
                  (acc, value, _) => acc.rebuild(
                    (lb) => lb.map(
                      (ticket) {
                        final reservation = value[ticket.id];
                        return reservation == null
                            ? ticket
                            : ticket.rebuild(
                                (b) => b
                                  ..reservation.replace(reservation)
                                  ..reservationId = reservation.id,
                              );
                      },
                    ),
                  ),
                  tickets,
                )
                .startWith(tickets),
          );
      final loaderBloc = LoaderBloc(
        loaderFunction: loaderFunction,
        logger: print,
      );

      final userRepo = Provider.of<UserRepository>(context);

      loaderBloc.state$
          .map((event) => event.content)
          .distinct()
          .map((state) => conflict(
                state,
                selectedTicketIdsS.value,
                userRepo.user$.value,
              ))
          .where((tickets) => tickets.isNotEmpty)
          .doOnData(handleConflictSelection)
          .exhaustMap(showConflictDialog)
          .listen(null)
          .disposedBy(bag);

      loaderBloc.state$
          .where((state) =>
              state.content != null && !state.isLoading && state.error == null)
          .take(1)
          .listen((_) => countDownTimerBloc.start())
          .disposedBy(bag);

      return loaderBloc..fetch();
    }();
  }

  void _showTimeoutDialog(void _) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).timeout),
          content:
              Text(S.of(context).timeOutToHoldTheSeatPleaseMakeYourReservation),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                if (widget.fromMovieDetail) {
                  AppScaffold.navigatorByIndex(context, AppScaffoldIndex.home)
                      .popUntil(ModalRoute.withName(MovieDetailPage.routeName));
                } else {
                  AppScaffold.navigatorByIndex(context, AppScaffoldIndex.home)
                      .popUntil(ModalRoute.withName(
                          ShowTimesByTheatrePage.routeName));
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final countDownStyle = Theme.of(context)
        .textTheme
        .subtitle2!
        .copyWith(color: Colors.white, fontSize: 16);

    return Scaffold(
      body: RxStreamBuilder<LoaderState<BuiltList<Ticket>>>(
        stream: bloc!.state$,
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
                onPressed: bloc!.fetch,
              ),
            );
          }

          final stateContent = state.content!;
          final builtMap = BuiltMap.of(
            Map.fromEntries(
              stateContent.map((t) => MapEntry(t.id, t)),
            ),
          );

          final buttonHeight = 54.0;
          final marginTop = MediaQuery.of(context).padding.top + 8;

          return Stack(
            children: [
              Positioned.fill(
                bottom: buttonHeight,
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
                    SliverToBoxAdapter(
                      child: const SizedBox(
                        height: 16,
                      ),
                    ),
                    SeatsGridWidget(
                      tickets: stateContent,
                      selectedTicketIds$: selectedTicketIdsS,
                      tapTicket: (ticket) {
                        if (ticket.reservationId != null) {
                          throw Exception('Something was wrong');
                        }

                        final ids = selectedTicketIdsS.value;
                        final newIds = ids.rebuild((b) {
                          if (ids.contains(ticket.id)) {
                            b.remove(ticket.id);
                          } else {
                            b.add(ticket.id);
                          }
                        });

                        if (ids == newIds) return;
                        selectedTicketIdsS.add(newIds);
                      },
                    ),
                    const LegendsWidget(),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Divider(
                          height: 1,
                          color: Color(0xffD1DBE2),
                        ),
                      ),
                    ),
                    BottomWidget(
                      movie: widget.movie,
                      theatre: widget.theatre,
                      showTime: widget.showTime,
                      ids$: selectedTicketIdsS,
                      tickets: builtMap,
                    ),
                    SelectedSeatsGridWidget(
                      ids$: selectedTicketIdsS,
                      tickets: builtMap,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: buttonHeight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      primary: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(),
                    ),
                    onPressed: () => tapContinue(builtMap),
                    child: Text(
                      S.of(context).CONTINUE,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
                  ),
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
                      onTap: () => AppScaffold.navigatorOfCurrentIndex(context)
                          .maybePop(),
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
                top: marginTop,
                right: 8,
                child: Container(
                  height: 24 + 32.0,
                  width: 24 + 32.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.32),
                  ),
                  child: Center(
                    child: RxStreamBuilder<String?>(
                      stream: countDownTimerBloc.countDown$,
                      builder: (context, data) {
                        return data != null
                            ? Text(data, style: countDownStyle)
                            : const SizedBox();
                      },
                    ),
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
  void dispose() {
    TicketsCountDownTimerBlocProvider.shared()._destroy();
    countDownTimerBloc.dispose();
    bloc!.dispose();
    bloc = null;
    super.dispose();
  }

  void tapContinue(BuiltMap<String, Ticket> ticketsMap) {
    final ids = selectedTicketIdsS.value;
    if (ids.isEmpty) {
      return context.showSnackBar(S.of(context).mustSelectAtLeastOneSeat);
    }

    final tickets = ids.map((id) => ticketsMap[id]).toBuiltList();
    AppScaffold.navigatorOfCurrentIndex(context).pushNamedX(
      ComboPage.routeName,
      arguments: {
        'showTime': widget.showTime,
        'theatre': widget.theatre,
        'movie': widget.movie,
        'tickets': tickets,
      },
    );
  }

  void handleConflictSelection(BuiltSet<Ticket> conflictTickets) {
    final value = selectedTicketIdsS.value;
    final conflictIds = conflictTickets.map((e) => e.id).toSet();
    final newSelected = Set.of(value).difference(conflictIds).toBuiltList();

    print(
        'CURRENT SELECTED COUNT: ${value.length} -> NEW SELECTED COUNT: ${newSelected.length}');
    selectedTicketIdsS.add(newSelected);
  }

  static BuiltSet<Ticket> conflict(
    BuiltList<Ticket>? state,
    BuiltList<String> selectedIds,
    Optional<User>? userOptional,
  ) {
    if (state == null) {
      return const <Ticket>{}.build();
    }

    final uid = userOptional?.fold(() => null, (u) => u.uid);
    if (uid == null) {
      return const <Ticket>{}.build();
    }
    final ticketById = Map.fromEntries(state.map((t) => MapEntry(t.id, t)));

    return selectedIds
        .map((id) => ticketById[id]!)
        .where((ticket) => ticket.reservation == null
            ? ticket.reservationId != null
            : ticket.reservation!.user!.uid != uid)
        .toBuiltSet();
  }

  Stream<void> showConflictDialog(BuiltSet<Ticket> _) => Rx.fromCallable(
        () => showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(S.of(context).warning),
              content: Text(S
                  .of(context)
                  .someSeatsYouChooseHaveBeenReservedPleaseSelectOther),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();

                    AppScaffold.navigatorByIndex(context, AppScaffoldIndex.home)
                        .popUntil(ModalRoute.withName(TicketsPage.routeName));
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        ),
      );
}

class ScreenWidget extends StatelessWidget {
  const ScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 80,
        color: const Color(0xffE9CBD1).withOpacity(0.2),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: ScreenWidgetPainter(
                  const Color(0xff8690A0),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Text(
                S.of(context).SCREEN,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenWidgetPainter extends CustomPainter {
  final Color color;

  ScreenWidgetPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height - 10;

    final path = Path()
      ..moveTo(10, y)
      ..quadraticBezierTo(
        size.width / 2,
        -size.height + 30,
        size.width - 10,
        y,
      );

    final paint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
    canvas.drawShadow(
      path,
      color.withOpacity(0.25),
      12,
      true,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SeatsGridWidget extends StatefulWidget {
  final BuiltList<Ticket> tickets;
  final Function1<Ticket, void> tapTicket;
  final ValueStream<BuiltList<String>> selectedTicketIds$;

  const SeatsGridWidget({
    Key? key,
    required this.tickets,
    required this.tapTicket,
    required this.selectedTicketIds$,
  }) : super(key: key);

  @override
  _SeatsGridWidgetState createState() => _SeatsGridWidgetState();
}

class _SeatsGridWidgetState extends State<SeatsGridWidget> {
  late int maxX;
  late int maxY;
  late Map<SeatCoordinates, Ticket> ticketByCoordinates;

  @override
  void initState() {
    super.initState();

    init();
  }

  void init() {
    final seats = widget.tickets.map((t) => t.seat);
    maxX = seats.map((s) => s.coordinates.x + s.count - 1).reduce(math.max);
    maxY = seats.map((s) => s.coordinates.y).reduce(math.max);

    ticketByCoordinates = Map.fromEntries(
        widget.tickets.map((t) => MapEntry(t.seat.coordinates, t)));
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

    return RxStreamBuilder<BuiltList<String>>(
      stream: widget.selectedTicketIds$,
      builder: (context, snapshotData) {
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
                                snapshotData,
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
      },
    );
  }

  Widget buildItem(
    BuildContext context,
    int y,
    int x,
    BuiltList<String> ids,
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
            style: Theme.of(context).textTheme.caption!.copyWith(
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
      int? prevCount;
      SeatCoordinates? prevCoords;
      var prevX = x - 1;
      while (prevX >= 0) {
        prevCoords = SeatCoordinates.from(x: prevX, y: y);
        prevCount = ticketByCoordinates[prevCoords]?.seat.count;
        if (prevCount != null) {
          break;
        }
        prevX--;
      }

      return prevCount != null &&
              prevCount > 1 &&
              (coordinates.x - prevCoords!.x + 1) <= prevCount
          ? const SizedBox(width: 0, height: 0)
          : Container(
              margin: const EdgeInsets.all(0.5),
              width: widthPerSeat,
              height: widthPerSeat,
            );
    } else {
      return SeatWidget(
        ticket: ticket,
        tapTicket: widget.tapTicket,
        isSelected: ids.contains(ticket.id),
        widthPerSeat: widthPerSeat,
      );
    }
  }
}

class SeatWidget extends StatelessWidget {
  final Ticket ticket;
  final Function1<Ticket, void> tapTicket;
  final bool isSelected;
  final double widthPerSeat;

  const SeatWidget({
    Key? key,
    required this.ticket,
    required this.tapTicket,
    required this.isSelected,
    required this.widthPerSeat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seat = ticket.seat;
    final width = widthPerSeat * seat.count + (seat.count - 1) * 1;

    if (ticket.reservationId != null) {
      return Container(
        margin: const EdgeInsets.all(0.5),
        width: width,
        height: widthPerSeat,
        decoration: BoxDecoration(
          color: const Color(0xffCBD7E9),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xffCBD7E9),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '${seat.row}${seat.column}',
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontSize: 10,
                  color: const Color(0xff98A8BA),
                ),
          ),
        ),
      );
    }

    final accentColor = Theme.of(context).accentColor;
    return InkWell(
      onTap: () => tapTicket(ticket),
      child: Container(
        margin: const EdgeInsets.all(0.5),
        width: width,
        height: widthPerSeat,
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? accentColor : const Color(0xffCBD7E9),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '${seat.row}${seat.column}',
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xff687189),
                ),
          ),
        ),
      ),
    );
  }
}

class LegendsWidget extends StatelessWidget {
  const LegendsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthPerSeat = MediaQuery.of(context).size.width / 12;
    final accentColor = Theme.of(context).accentColor;
    final textStyle = Theme.of(context).textTheme.subtitle2!.copyWith(
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
                    color: accentColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  S.of(context).selected,
                  style: textStyle,
                ),
              ],
            ),
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
                  S.of(context).available,
                  style: textStyle,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(0.5),
                  width: widthPerSeat,
                  height: widthPerSeat,
                  decoration: BoxDecoration(
                    color: const Color(0xffCBD7E9),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  S.of(context).taken,
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
                  S.of(context).doubledSeat,
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
  final startTimeFormat = DateFormat('dd/MM/yy, EEE, hh:mm a');
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');

  final ShowTime showTime;
  final Theatre theatre;
  final Movie movie;
  final ValueStream<BuiltList<String>> ids$;
  final BuiltMap<String, Ticket> tickets;

  BottomWidget({
    Key? key,
    required this.showTime,
    required this.theatre,
    required this.movie,
    required this.ids$,
    required this.tickets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final textStyle = textTheme.subtitle1!.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: const Color(0xff98A8BA),
    );

    final textStyle2 = textTheme.subtitle1!.copyWith(
      fontSize: 16,
      color: const Color(0xff687189),
      fontWeight: FontWeight.w600,
    );

    final selectTextStyle = textTheme.headline6!.copyWith(
      fontSize: 18,
      color: const Color(0xff687189),
      fontWeight: FontWeight.normal,
    );

    final seatsCountStyle = textStyle2.copyWith(fontSize: 20);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              movie.title,
              style: textTheme.headline4!.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: const Color(0xff687189),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                AgeTypeWidget(ageType: movie.ageType),
                const SizedBox(width: 8),
                Text(S.of(context).duration_minutes(movie.duration)),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                  text: S.of(context).startAt,
                  style: textStyle,
                  children: [
                    TextSpan(
                      text: startTimeFormat.format(showTime.start_time),
                      style: textStyle2,
                    ),
                  ]),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                  text: S.of(context).theatre,
                  style: textStyle,
                  children: [
                    TextSpan(
                      text: theatre.name,
                      style: textStyle2,
                    ),
                    TextSpan(
                      text: S.of(context).room,
                      style: textStyle,
                    ),
                    TextSpan(
                      text: showTime.room,
                      style: textStyle2,
                    ),
                  ]),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                  text: S.of(context).address + ': ',
                  style: textStyle,
                  children: [
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
            RxStreamBuilder<BuiltList<String>>(
              stream: ids$,
              builder: (context, data) {
                return Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: S.of(context).select,
                        style: selectTextStyle,
                        children: [
                          TextSpan(
                            text: ' ${data.length} ',
                            style: seatsCountStyle,
                          ),
                          TextSpan(
                            text: S.of(context).seat_s(data.length),
                            style: selectTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    RichText(
                      text: TextSpan(
                        text: currencyFormat.format(data.fold<int>(
                            0, (acc, e) => acc + tickets[e]!.price)),
                        style: seatsCountStyle,
                        children: [
                          TextSpan(
                            text: ' VND',
                            style: selectTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedSeatsGridWidget extends StatelessWidget {
  final ValueStream<BuiltList<String>> ids$;
  final BuiltMap<String, Ticket> tickets;

  const SelectedSeatsGridWidget(
      {Key? key, required this.ids$, required this.tickets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;

    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: RxStreamBuilder<BuiltList<String>>(
        stream: ids$,
        builder: (context, ids) {
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final seat = tickets[ids[index]]!.seat;

                return Container(
                  margin: const EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      '${seat.row}${seat.column}',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                  ),
                );
              },
              childCount: ids.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 1,
            ),
          );
        },
      ),
    );
  }
}
