import 'package:built_collection/built_collection.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:stream_loader/stream_loader.dart';
import 'package:tuple/tuple.dart';

import '../../domain/model/theatre.dart';
import '../../domain/repository/show_times_repository.dart';
import '../../utils/error.dart';
import '../widgets/error_widget.dart';

class ReportPage extends StatefulWidget {
  static const routeName = 'home/report';

  final Theatre theatre;

  const ReportPage({Key key, @required this.theatre}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with DisposeBagMixin {
  final dayS = BehaviorSubject.seeded(DateTime.now(), sync: true);
  final formatter = DateFormat('MM/yyyy');

  LoaderBloc<BuiltMap<String, int>> bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc ??= () {
      final repo = Provider.of<ShowTimesRepository>(context);

      final s = LoaderBloc(
        loaderFunction: () => Rx.fromCallable(
          () => repo.report(
            widget.theatre.id,
            formatter.format(dayS.value),
          ),
        ),
        logger: print,
      );

      dayS
          .debug(identifier: 'DAYS')
          .map((date) => date == null ? null : formatter.format(date))
          .distinct()
          .where((event) => event != null)
          .debug(identifier: 'FETCH')
          .listen((event) => s.fetch())
          .disposedBy(bag);

      return s;
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
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DateTimeField(
              initialValue: dayS.value,
              format: formatter,
              readOnly: true,
              onShowPicker: (context, currentValue) async {
                final now = DateTime.now();

                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? now,
                  lastDate: DateTime(2100),
                  selectableDayPredicate: (d) => true,
                );

                if (date == null) return null;

                return DateTime(
                  date.year,
                  date.month,
                  date.day,
                );
              },
              validator: (date) => null,
              onChanged: dayS.add,
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
                  labelText: 'Select a month',
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 13),
                  fillColor: Colors.deepPurpleAccent,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.deepPurpleAccent)),
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 13)),
            ),
            Expanded(
              child: StreamBuilder<LoaderState<BuiltMap<String, int>>>(
                stream: bloc.state$,
                initialData: bloc.state$.value,
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

                  return buildCharts(state.content, context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCharts(BuiltMap<String, int> map, BuildContext context) {
    final amount_sold = map['amount_sold'];
    final amount = map['amount'];

    final seriesList = [
      charts.Series<Tuple2<String, int>, String>(
        id: 'Amount',
        domainFn: (t, i) => t.item1,
        measureFn: (t, i) => t.item2,
        data: [
          Tuple2('Sold', amount_sold),
          Tuple2('Not sold yet', amount - amount_sold),
        ],
        colorFn: (t, i) {
          if (i == 0) {
            return charts.MaterialPalette.purple.shadeDefault;
          }
          return charts.ColorUtil.fromDartColor(Color(0xffCE93D8));
        },
      ),
    ];

    final tickets_sold = map['tickets_sold'];
    final tickets = map['tickets'];

    final seriesList2 = [
      charts.Series<Tuple2<String, int>, String>(
        id: 'Tickets',
        domainFn: (t, i) => t.item1,
        measureFn: (t, i) => t.item2,
        data: [
          Tuple2('Sold', tickets_sold),
          Tuple2('Not sold yet', tickets - tickets_sold),
        ],
        colorFn: (t, i) {
          if (i == 0) {
            return charts.MaterialPalette.red.shadeDefault;
          }
          return charts.ColorUtil.fromDartColor(Color(0xffEF9A9A));
        },
      ),
    ];

    return ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 1.1,
          child: charts.PieChart(
            seriesList,
            animate: true,
            behaviors: [
              charts.DatumLegend(
                position: charts.BehaviorPosition.bottom,
                horizontalFirst: false,
                cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                showMeasures: true,
                legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                measureFormatter: (value) =>
                    '${defaultLegendMeasureFormatter(value)} VND ~ ${amount == 0 ? 0 : (value / amount * 100).toStringAsFixed(2)}%',
              ),
            ],
          ),
        ),
        const Divider(),
        Container(
          height: MediaQuery.of(context).size.width * 1.1,
          child: charts.PieChart(
            seriesList2,
            animate: true,
            behaviors: [
              charts.DatumLegend(
                position: charts.BehaviorPosition.bottom,
                horizontalFirst: false,
                cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                showMeasures: true,
                legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                measureFormatter: (value) =>
                    '${defaultLegendMeasureFormatter(value)} tickets ~ ${tickets == 0 ? 0 : (value / tickets * 100).toStringAsFixed(2)}%',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final _decimalPattern = NumberFormat.decimalPattern();

String defaultLegendMeasureFormatter(num value) =>
    value == null ? '' : _decimalPattern.format(value);
