import 'dart:async';
import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import '../../../utils/utils.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_scaffold.dart';
import '../seat.dart';
import 'legends_widget.dart';
import 'screen_widget.dart';

const MAX_X = 14 - 0 + 1; // 0 -> 14
final MAX_Y = 'H'.codeUnitAt(0) - 'A'.codeUnitAt(0); // 'A' -> 'H'

BuiltList<Seat> fullSeats() {
  final seats = <Seat>[];
  for (var r = 0; r <= MAX_Y; r++) {
    for (var c = 0; c <= MAX_X; c++) {
      seats.add(
        Seat(
          String.fromCharCode('A'.codeUnitAt(0) + r),
          1,
          Coordinates(c, r),
        ),
      );
    }
  }
  return seats.build();
}

class SeatsPage extends StatefulWidget {
  final BuiltList<Seat> seats;

  static const routeName = '/home/theatres/add/seats';

  const SeatsPage({Key key, this.seats}) : super(key: key);

  @override
  _SeatsPageState createState() => _SeatsPageState();
}

class _SeatsPageState extends State<SeatsPage> with DisposeBagMixin {
  final changeSeatS = StreamController<Seat>();
  DistinctValueStream<BuiltList<Seat>> seats$;

  @override
  void initState() {
    super.initState();

    final seedValue = widget.seats ?? fullSeats();
    seats$ = changeSeatS.stream
        .debug('??')
        .scan<BuiltList<Seat>>(
          (acc, value, _) => acc.contains(value)
              ? acc.rebuild((b) => b.remove(value))
              : acc.rebuild((b) => b.add(value)),
          seedValue,
        )
        .shareValueDistinct(seedValue, sync: true)
          ..listen(null).disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final exit = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Exit'),
              content: Text('Changes will not be saved'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                ),
                FlatButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ],
            );
          },
        );

        return identical(exit, true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Seats'),
          actions: [
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () => AppScaffold.of(context).pop(seats$),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 16,
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
            RxStreamBuilder(
              stream: seats$,
              builder: (context, snapshot) => SeatsGridWidget(
                seats: snapshot.data,
                changeSeat: changeSeatS.add,
              ),
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
          ],
        ),
      ),
    );
  }
}

class SeatsGridWidget extends StatefulWidget {
  final BuiltList<Seat> seats;
  final Function1<Seat, void> changeSeat;

  const SeatsGridWidget({
    Key key,
    @required this.seats,
    this.changeSeat,
  }) : super(key: key);

  @override
  _SeatsGridWidgetState createState() => _SeatsGridWidgetState();
}

class _SeatsGridWidgetState extends State<SeatsGridWidget> {
  int maxX;
  int maxY;
  Map<Coordinates, Seat> seatByCoordinates;

  @override
  void initState() {
    super.initState();

    init();
  }

  void init() {
    final seats = widget.seats;

    maxX = seats.map((s) => s.coordinates.x + s.count - 1).reduce(math.max);
    maxY = seats.map((s) => s.coordinates.y).reduce(math.max);

    maxX = math.max(maxX, MAX_X);
    maxY = math.max(maxY, MAX_Y);

    seatByCoordinates =
        Map.fromEntries(widget.seats.map((t) => MapEntry(t.coordinates, t)));
  }

  @override
  void didUpdateWidget(SeatsGridWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.seats != widget.seats) {
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
    final coordinates = Coordinates(x, y);
    final seat = seatByCoordinates[coordinates];
    if (seat == null) {
      final prevCount = seatByCoordinates[Coordinates(x - 1, y)]?.count;
      return prevCount != null && prevCount > 1
          ? const SizedBox(width: 0, height: 0)
          : InkWell(
              onTap: () => widget.changeSeat(Seat(row, 1, coordinates)),
              child: Container(
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
            );
    } else {
      return SeatWidget(
        seat: seat,
        widthPerSeat: widthPerSeat,
        isSelected: true,
        onTap: () => widget.changeSeat(seat),
      );
    }
  }
}

class SeatWidget extends StatelessWidget {
  final Seat seat;
  final double widthPerSeat;
  final bool isSelected;
  final VoidCallback onTap;

  const SeatWidget({
    Key key,
    this.widthPerSeat,
    this.seat,
    this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = widthPerSeat * seat.count + (seat.count - 1) * 1;

    final accentColor = Theme.of(context).accentColor;
    return InkWell(
      onTap: onTap,
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
            '${seat.row}${''}',
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
