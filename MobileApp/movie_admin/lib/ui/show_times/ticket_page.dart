import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../domain/model/movie.dart';
import '../../domain/model/reservation.dart';
import '../../domain/model/seat.dart';
import '../../domain/model/show_time.dart';
import '../../domain/model/theatre.dart';
import '../../domain/model/ticket.dart';
import '../../domain/repository/ticket_repo.dart';
import '../../utils/error.dart';
import '../../utils/type_defs.dart';
import '../../utils/utils.dart';
import '../app_scaffold.dart';
import '../widgets/age_type.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import 'reservation_list_item.dart';

class TicketsPage extends StatefulWidget {
  static const routeName = 'home/detail/tickets';

  final ShowTime showTime;
  final Theatre theatre;

  const TicketsPage({
    Key key,
    @required this.showTime,
    @required this.theatre,
  }) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> with DisposeBagMixin {
  LoaderBloc<BuiltList<Ticket>> bloc;
  LoaderBloc<BuiltList<Reservation>> resBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ticketRepository = Provider.of<TicketRepository>(context);

    bloc ??= () {
      return LoaderBloc(
        loaderFunction: () =>
            ticketRepository.getTicketsByShowTimeId(widget.showTime.id),
        logger: print,
      )..fetch();
    }();

    resBloc ??= LoaderBloc(
      loaderFunction: () =>
          ticketRepository.getReservationsByShowTimeId(widget.showTime.id),
      logger: print,
    )..fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RxStreamBuilder<LoaderState<BuiltList<Ticket>>>(
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
                    SliverToBoxAdapter(
                      child: const SizedBox(
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
                    LegendsWidget(tickets: state.content),
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
                      movie: widget.showTime.movie,
                      theatre: widget.theatre,
                      showTime: widget.showTime,
                      tickets: builtMap,
                    ),
                    ResList(bloc: resBloc),
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
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
    resBloc.dispose();
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
  Map<SeatCoordinates, Ticket> ticketByCoordinates;

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
        prevCount = ticketByCoordinates[prevCoords]?.seat?.count;
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
        ticket: ticket,
        tapTicket: widget.tapTicket,
        widthPerSeat: widthPerSeat,
      );
    }
  }
}

class SeatWidget extends StatelessWidget {
  final Ticket ticket;
  final Function1<Ticket, void> tapTicket;
  final double widthPerSeat;

  const SeatWidget({
    Key key,
    this.ticket,
    this.tapTicket,
    this.widthPerSeat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seat = ticket.seat;
    final width = widthPerSeat * seat.count + (seat.count - 1) * 1;

    if (ticket.reservationId != null) {
      final accentColor = Theme.of(context).accentColor;

      return Container(
        margin: const EdgeInsets.all(0.5),
        width: width,
        height: widthPerSeat,
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: accentColor,
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

    return InkWell(
      onTap: () => tapTicket(ticket),
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
  final BuiltList<Ticket> tickets;

  const LegendsWidget({Key key, this.tickets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avai = tickets.count((e) => e.reservationId == null);
    final taken = tickets.length - avai;

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
                  '${avai} Available',
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
                    color: accentColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${taken} Taken',
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
  final BuiltMap<String, Ticket> tickets;

  BottomWidget({
    Key key,
    @required this.showTime,
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
                  text: startTimeFormat.format(showTime.startTime),
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

extension _CountExt<T> on Iterable<T> {
  int count(bool Function(T) test) {
    var c = 0;
    for (final e in this) {
      if (test(e)) c++;
    }
    return c;
  }
}

class ResList extends StatelessWidget {
  static final currencyFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: '');
  final LoaderBloc<BuiltList<Reservation>> bloc;

  ResList({Key key, @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RxStreamBuilder<LoaderState<BuiltList<Reservation>>>(
      stream: bloc.state$,
      builder: (context, state) {
        if (state.error != null) {
          return SliverToBoxAdapter(
            child: Container(
              color: Color(0xFFFCFCFC),
              constraints: BoxConstraints.expand(height: 250),
              child: MyErrorWidget(
                errorText: 'Error: ${getErrorMessage(state.error)}',
                onPressed: bloc.fetch,
              ),
            ),
          );
        }

        if (state.isLoading) {
          return SliverToBoxAdapter(
            child: Container(
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
            ),
          );
        }

        final movies = state.content;

        if (movies.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              color: Color(0xFFFCFCFC),
              constraints: BoxConstraints.expand(height: 250),
              child: Center(
                child: EmptyWidget(message: 'Empty reservation'),
              ),
            ),
          );
        }

        final total = movies.fold(0, (acc, e) => acc + e.totalPrice);
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'TOTAL: ${currencyFormat.format(total)} VND',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff687189),
                        ),
                  ),
                );
              }

              index--;
              final item = movies[index];
              return ReservationListItem(
                item: item,
                currencyFormat: currencyFormat,
              );
            },
            childCount: movies.length + 1,
          ),
        );
      },
    );
  }
}
