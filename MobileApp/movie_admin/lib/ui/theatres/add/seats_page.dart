import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../../utils/utils.dart';
import '../../app_scaffold.dart';
import '../seat.dart';
import 'legends_widget.dart';
import 'screen_widget.dart';

const MAX_X = 14 - 0 + 1; // 0 -> 14
final MAX_Y = 'K'.codeUnitAt(0) - 'A'.codeUnitAt(0) + 1; // 'A' -> 'H'

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
  BehaviorSubject<BuiltList<Seat>> changeSeatS;
  final longSelectedS = BehaviorSubject.seeded(<Seat>{}.build());

  DistinctValueStream<Tuple2<BuiltList<Seat>, BuiltSet<Seat>>> seats$;

  @override
  void initState() {
    super.initState();

    final seedValue = widget.seats ?? fullSeats();
    changeSeatS = BehaviorSubject.seeded(seedValue);

    seats$ = Rx.combineLatest2(
      changeSeatS,
      longSelectedS,
      (a, b) => Tuple2<BuiltList<Seat>, BuiltSet<Seat>>(a, b),
    ).shareValueDistinct(
      Tuple2(seedValue, longSelectedS.value),
      sync: true,
    )..listen(null).disposedBy(bag);
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
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                ),
                TextButton(
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
            RxStreamBuilder<BuiltSet<Seat>>(
              stream: longSelectedS,
              builder: (context, data) {
                if (data.isNotEmpty) {
                  return TextButton(
                    child: Text(
                      'Merge',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => onMerge(context),
                  );
                }
                return const SizedBox();
              },
            ),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () => AppScaffold.of(context).pop(seats$.value.item1),
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
                tuple: snapshot.data,
                changeSeat: (value) {
                  final acc = changeSeatS.value;
                  final newSeats = acc.firstWhere(
                              (e) => e.coordinates == value.coordinates,
                              orElse: () => null) !=
                          null
                      ? () {
                          final longSelected = longSelectedS.value;
                          if (longSelected.firstWhere(
                                  (e) => e.coordinates == value.coordinates,
                                  orElse: () => null) !=
                              null) {
                            longSelectedS.add(
                                longSelected.rebuild((b) => b.remove(value)));
                          }
                          return acc.rebuild((b) => b.remove(value));
                        }()
                      : acc.rebuild((b) => b.add(value));
                  changeSeatS.add(newSeats);
                },
                onLongPressed: (seat) {
                  final longSelected = longSelectedS.value;
                  final newLongSelected = longSelected.firstWhere(
                              (e) => e.coordinates == seat.coordinates,
                              orElse: () => null) !=
                          null
                      ? longSelected.rebuild((b) => b.remove(seat))
                      : longSelected.rebuild((b) => b.add(seat));
                  longSelectedS.add(newLongSelected);
                },
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

  void onMerge(BuildContext context) {
    final longSelected = longSelectedS.value;
    if (longSelected.length <= 1) {
      return context.showSnackBar('Please select more than 1 seat');
    }

    if (longSelected.map((e) => e.coordinates.y).toSet().length != 1) {
      return context.showSnackBar('All seats must be same row');
    }

    final sorted = longSelected.sortedBy<num>((e) => e.coordinates.x);
    print(sorted);
    for (var i = 0; i < sorted.length - 1; i++) {
      final cur = sorted[i];
      final after = sorted[i + 1];
      if (after.coordinates.x - cur.coordinates.x != cur.count) {
        return context.showSnackBar('Seats must be consecutive');
      }
    }

    final seats = changeSeatS.value.rebuild((b) {
      sorted.forEach(b.remove);

      final first = sorted.first;
      final merged = Seat(
        first.row,
        sorted.map((e) => e.count).reduce((acc, e) => acc + e),
        first.coordinates,
      );
      print(merged);
      b.add(merged);
    });

    longSelectedS.add(<Seat>{}.build());
    changeSeatS.add(seats);
  }
}

class SeatsGridWidget extends StatefulWidget {
  final Tuple2<BuiltList<Seat>, BuiltSet<Seat>> tuple;
  final Function1<Seat, void> changeSeat;
  final Function1<Seat, void> onLongPressed;

  const SeatsGridWidget({
    Key key,
    @required this.changeSeat,
    @required this.tuple,
    @required this.onLongPressed,
  }) : super(key: key);

  @override
  _SeatsGridWidgetState createState() => _SeatsGridWidgetState();
}

class _SeatsGridWidgetState extends State<SeatsGridWidget> {
  int maxX;
  int maxY;
  Map<Coordinates, Seat> seatByCoordinates;
  Map<Coordinates, int> columnByCoordinates;

  @override
  void initState() {
    super.initState();

    init();
  }

  void init() {
    final seats = widget.tuple.item1;

    maxX =
        seats.map((s) => s.coordinates.x + s.count - 1).fold(MAX_X, math.max);
    maxY = seats.map((s) => s.coordinates.y).fold(MAX_Y, math.max);

    seatByCoordinates = seats.map((t) => MapEntry(t.coordinates, t)).toMap();
    columnByCoordinates = seats
        .groupBy(
          (s) => s.coordinates.y,
          (s) => s,
        )
        .entries
        .expand(
          (e) => e.value
              .sortedBy<num>((e) => e.coordinates.x)
              .mapIndexed((i, c) => MapEntry(c.coordinates, i + 1)),
        )
        .toMap();
  }

  @override
  void didUpdateWidget(SeatsGridWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tuple.item1 != widget.tuple.item1) {
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
      int prevCount;
      Coordinates cc;
      var jj = x - 1;
      while (jj >= 0) {
        cc = Coordinates(jj, y);
        prevCount = seatByCoordinates[cc]?.count;
        if (prevCount != null) {
          break;
        }
        jj--;
      }

      return prevCount != null &&
              prevCount > 1 &&
              (coordinates.x - cc.x + 1) <= prevCount
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
        isSelected: !widget.tuple.item2.contains(seat),
        onTap: () => widget.changeSeat(seat),
        column: columnByCoordinates[coordinates],
        onLongPress: () => widget.onLongPressed(seat),
      );
    }
  }
}

class SeatWidget extends StatelessWidget {
  final Seat seat;
  final double widthPerSeat;
  final bool isSelected;
  final VoidCallback onTap;
  final int column;
  final GestureLongPressCallback onLongPress;

  const SeatWidget({
    Key key,
    this.widthPerSeat,
    this.seat,
    this.isSelected,
    this.onTap,
    this.column,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = widthPerSeat * seat.count + (seat.count - 1) * 1;

    final accentColor = Theme.of(context).accentColor;
    final primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.all(0.5),
        width: width,
        height: widthPerSeat,
        decoration: BoxDecoration(
          color: isSelected ? accentColor : primaryColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? accentColor : primaryColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '${seat.row}${column}',
            style: Theme.of(context).textTheme.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
