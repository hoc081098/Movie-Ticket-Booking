import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../../domain/model/seat.dart';
import '../../../domain/model/show_time.dart';
import '../../../domain/model/ticket.dart';
import '../../../domain/repository/ticket_repository.dart';
import '../../../utils/error.dart';
import '../../../utils/type_defs.dart';
import '../../widgets/error_widget.dart';

class TicketsPage extends StatefulWidget {
  static const routeName = 'home/detail/tickets';

  final ShowTime showTime;

  const TicketsPage({Key key, @required this.showTime}) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> with DisposeBagMixin {
  LoaderBloc<BuiltList<Ticket>> bloc;
  final selectedTicketIdsS = BehaviorSubject.seeded(BuiltSet.of(<String>[]));

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
  }

  @override
  Widget build(BuildContext context) {
    return RxStreamBuilder<LoaderState<BuiltList<Ticket>>>(
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

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).padding.top + 8,
                  width: double.infinity,
                  color: const Color(0xffE9CBD1).withOpacity(0.2),
                ),
              ),
              ScreenWidget(),
              SliverToBoxAdapter(
                child: const SizedBox(
                  height: 16,
                ),
              ),
              SeatsGridWidget(
                tickets: state.content,
                selectedTicketIds$: selectedTicketIdsS,
                tapTicket: (ticket) {
                  if (ticket.reservation != null) {
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
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class ScreenWidget extends StatelessWidget {
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
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class SeatsGridWidget extends StatefulWidget {
  final BuiltList<Ticket> tickets;
  final Function1<Ticket, void> tapTicket;
  final ValueStream<BuiltSet<String>> selectedTicketIds$;

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
        MediaQuery.of(context).size.width * widthExtra / (maxX + 2);
    final totalWidth = MediaQuery.of(context).size.width * widthExtra;

    return RxStreamBuilder<BuiltSet<String>>(
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
    BuiltSet<String> ids,
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
    final width = widthPerSeat * seat.count;

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
