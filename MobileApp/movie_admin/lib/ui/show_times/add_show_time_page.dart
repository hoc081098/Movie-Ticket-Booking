import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../domain/model/movie.dart';
import '../../domain/model/seat.dart';
import '../../domain/model/theatre.dart';
import '../../domain/repository/ticket_repo.dart';
import '../../ui/show_times/ticket_page.dart' show ScreenWidget;
import '../../ui/widgets/age_type.dart';
import '../../ui/widgets/error_widget.dart';
import '../../utils/utils.dart';
import '../app_scaffold.dart';

class AppShowTimePage extends StatefulWidget {
  static const routeName = '/show-times/add';

  final Theatre theatre;
  final Movie movie;

  const AppShowTimePage({Key key, @required this.theatre, @required this.movie})
      : super(key: key);

  @override
  _AppShowTimePageState createState() => _AppShowTimePageState();
}

class _AppShowTimePageState extends State<AppShowTimePage> {
  LoaderBloc<BuiltList<Seat>> bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bloc ??= LoaderBloc(
      loaderFunction: () => Provider.of<TicketRepository>(context)
          .getSeatsByTheatreId(widget.theatre.id),
      enableLogger: true,
    )..fetch();
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
        builder: (context, snapshot) {
          final state = snapshot.data;

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
                      tickets: state.content,
                      tapTicket: (ticket) {
                        if (ticket == null) {
                          throw Exception('Something was wrong');
                        }
                        print('Tapped $ticket');
                      },
                    ),
                    LegendsWidget(),
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
                      tickets: builtMap,
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
            ],
          );
        },
      ),
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
