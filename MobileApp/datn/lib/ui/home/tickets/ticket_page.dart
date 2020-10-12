import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../../domain/model/movie.dart';
import '../../../domain/model/seat.dart';
import '../../../domain/model/show_time.dart';
import '../../../domain/model/theatre.dart';
import '../../../domain/model/ticket.dart';
import '../../../domain/repository/reservation_repository.dart';
import '../../../domain/repository/ticket_repository.dart';
import '../../../utils/error.dart';
import '../../../utils/type_defs.dart';
import '../../../utils/utils.dart';
import '../../app_scaffold.dart';
import '../../widgets/age_type.dart';
import '../../widgets/error_widget.dart';
import 'combo_page.dart';

class TicketsPage extends StatefulWidget {
  static const routeName = 'home/detail/tickets';

  final ShowTime showTime;
  final Theatre theatre;
  final Movie movie;

  const TicketsPage({
    Key key,
    @required this.showTime,
    @required this.movie,
    @required this.theatre,
  }) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> with DisposeBagMixin {
  LoaderBloc<BuiltList<Ticket>> bloc;
  final selectedTicketIdsS = BehaviorSubject.seeded(BuiltList.of(<String>[]));
  dynamic token;

  @override
  void initState() {
    super.initState();
    selectedTicketIdsS.disposedBy(bag);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bloc ??= () {
      final ticketRepository = Provider.of<TicketRepository>(context);
      final loaderFunction =
          () => ticketRepository.getTicketsByShowTimeId(widget.showTime.id);
      return LoaderBloc(
        loaderFunction: loaderFunction,
        refresherFunction: loaderFunction,
        enableLogger: true,
      )..fetch();
    }();

    final reservationRepository = Provider.of<ReservationRepository>(context);
    token ??= reservationRepository
        .watchReservedTicket(widget.showTime.id)
        .listen((event) {
      print('@@@@@@@ >>>>>> $event');
    }).disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RxStreamBuilder<LoaderState<BuiltList<Ticket>>>(
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

          final builtMap = BuiltMap.of(
            Map.fromEntries(
              state.content.map((t) => MapEntry(t.id, t)),
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
                        height: marginTop,
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
                      tickets: state.content,
                      selectedTicketIds$: selectedTicketIdsS,
                      tapTicket: (ticket) {
                        if (ticket == null || ticket.reservation != null) {
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
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () => tapContinue(builtMap),
                    child: Text(
                      'CONTINUE',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
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
                    color: Colors.black.withOpacity(0.16),
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
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  void tapContinue(BuiltMap<String, Ticket> ticketsMap) {
    final ids = selectedTicketIdsS.value;
    if (ids.isEmpty) {
      return context.showSnackBar('Must select at least one seat');
    }

    final tickets = ids.map((id) => ticketsMap[id]).toBuiltList();
    AppScaffold.of(context).pushNamed(
      ComboPage.routeName,
      arguments: {
        'showTime': widget.showTime,
        'theatre': widget.theatre,
        'movie': widget.movie,
        'tickets': tickets,
      },
    );
  }
}

class ScreenWidget extends StatelessWidget {
  const ScreenWidget({Key key}) : super(key: key);

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
                'SCREEN',
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
    Key key,
    @required this.tickets,
    @required this.tapTicket,
    @required this.selectedTicketIds$,
  }) : super(key: key);

  @override
  _SeatsGridWidgetState createState() => _SeatsGridWidgetState();
}

class _SeatsGridWidgetState extends State<SeatsGridWidget> {
  int maxX;
  int maxY;
  Map<SeatCoordinates, Ticket> ticketByCoordinates;

  @override
  void initState() {
    super.initState();

    final seats = widget.tickets.map((t) => t.seat);
    maxX = seats.map((s) => s.coordinates.x + s.count - 1).reduce(math.max);
    maxY = seats.map((s) => s.coordinates.y).reduce(math.max);

    ticketByCoordinates = Map.fromEntries(
        widget.tickets.map((t) => MapEntry(t.seat.coordinates, t)));
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
      builder: (context, snapshot) {
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
                                snapshot.data,
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
    final ticket = ticketByCoordinates[SeatCoordinates.from(x: x, y: y)];
    if (ticket == null) {
      final prevCount =
          ticketByCoordinates[SeatCoordinates.from(x: x - 1, y: y)]
              ?.seat
              ?.count;
      return prevCount != null && prevCount > 1
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
        isSelected: ids.contains(ticket?.id),
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
    Key key,
    this.ticket,
    this.tapTicket,
    this.isSelected,
    this.widthPerSeat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seat = ticket.seat;
    final width = widthPerSeat * seat.count + (seat.count - 1) * 1;

    if (ticket.reservation != null) {
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
            style: Theme.of(context).textTheme.caption.copyWith(
                  fontSize: 10,
                  color: const Color(0x98A8BA),
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
            style: Theme.of(context).textTheme.caption.copyWith(
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
  const LegendsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthPerSeat = MediaQuery.of(context).size.width / 12;
    final accentColor = Theme.of(context).accentColor;
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
                    color: accentColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Select',
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
                  'Available',
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
                  'Taken',
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

  final ShowTime showTime;
  final Theatre theatre;
  final Movie movie;
  final ValueStream<BuiltList<String>> ids$;
  final BuiltMap<String, Ticket> tickets;

  BottomWidget({
    Key key,
    @required this.showTime,
    @required this.theatre,
    @required this.movie,
    @required this.ids$,
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

    final selectTextStyle = textTheme.headline6.copyWith(
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
              style: textTheme.headline4.copyWith(
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
                Text('${movie.duration} minutes'),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(text: 'Start at: ', style: textStyle, children: [
                TextSpan(
                  text: startTimeFormat.format(showTime.start_time),
                  style: textStyle2,
                ),
              ]),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(text: 'Theatre: ', style: textStyle, children: [
                TextSpan(
                  text: theatre.name,
                  style: textStyle2,
                ),
                TextSpan(
                  text: ' Room: ',
                  style: textStyle,
                ),
                TextSpan(
                  text: showTime.room,
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
              builder: (context, snapshot) {
                return Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Select',
                        style: selectTextStyle,
                        children: [
                          TextSpan(
                            text: ' ${snapshot.data.length} ',
                            style: seatsCountStyle,
                          ),
                          TextSpan(
                            text:
                                'seat' + (snapshot.data.length > 1 ? 's' : ''),
                            style: selectTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    RichText(
                      text: TextSpan(
                        text: currencyFormat.format(snapshot.data
                            .fold(0, (acc, e) => acc + tickets[e].price)),
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

  const SelectedSeatsGridWidget({Key key, this.ids$, this.tickets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;

    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: RxStreamBuilder<BuiltList<String>>(
        stream: ids$,
        builder: (context, snapshot) {
          final ids = snapshot.data;
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final seat = tickets[ids[index]].seat;

                return Container(
                  margin: const EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      '${seat.row}${seat.column}',
                      style: Theme.of(context).textTheme.caption.copyWith(
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
                childAspectRatio: 1),
          );
        },
      ),
    );
  }
}
