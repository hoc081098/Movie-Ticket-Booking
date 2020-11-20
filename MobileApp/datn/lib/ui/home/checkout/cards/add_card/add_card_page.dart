import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../../utils/utils.dart';
import '../../../tickets/ticket_page.dart';
import 'add_card_bloc.dart';

class AddCardPage extends StatefulWidget {
  static const routeName = 'home/detail/tickets/combo/checkout/cards/add_card';

  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> with DisposeBagMixin {
  final numberNode = FocusNode();
  final expNode = FocusNode();
  final cvcNode = FocusNode();
  final doneNode = FocusNode();

  dynamic token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token ??= BlocProvider.of<AddCardBloc>(context)
        .message$
        .listen(handleMessage)
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AddCardBloc>(context);
    final countDownStyle = Theme.of(context)
        .textTheme
        .subtitle2
        .copyWith(color: Colors.white, fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add card'),
        actions: [
          Center(
            child: RxStreamBuilder<String>(
              stream:
                  TicketsCountDownTimerBlocProvider.shared().bloc.countDown$,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Text(
                        snapshot.data,
                        style: countDownStyle,
                      )
                    : const SizedBox();
              },
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RxStreamBuilder<String>(
                  stream: bloc.cardHolderNameError$,
                  builder: (context, snapshot) {
                    return TextField(
                      autocorrect: true,
                      keyboardType: TextInputType.name,
                      maxLines: 1,
                      onChanged: bloc.cardHolderNameChanged,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(numberNode),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsetsDirectional.only(end: 8.0),
                          child: Icon(Icons.person_rounded),
                        ),
                        labelText: 'Card holder name',
                        errorText: snapshot.data,
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                RxStreamBuilder<String>(
                  stream: bloc.numberError$,
                  builder: (context, snapshot) {
                    return TextField(
                      autocorrect: true,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      onChanged: bloc.numberChanged,
                      textInputAction: TextInputAction.next,
                      focusNode: numberNode,
                      maxLength: 16,
                      maxLengthEnforced: true,
                      onSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(expNode),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsetsDirectional.only(end: 8.0),
                          child: Icon(Icons.credit_card_rounded),
                        ),
                        labelText: 'Card number',
                        errorText: snapshot.data,
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                RxStreamBuilder<String>(
                  stream: bloc.expError$,
                  builder: (context, snapshot) {
                    return TextField(
                      autocorrect: true,
                      keyboardType: TextInputType.datetime,
                      maxLines: 1,
                      onChanged: bloc.expChanged,
                      textInputAction: TextInputAction.next,
                      focusNode: expNode,
                      maxLength: 5,
                      maxLengthEnforced: true,
                      onSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(cvcNode),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsetsDirectional.only(end: 8.0),
                          child: Icon(Icons.date_range_rounded),
                        ),
                        labelText: 'Expire date (MM/yy)',
                        errorText: snapshot.data,
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                RxStreamBuilder<String>(
                  stream: bloc.cvcError$,
                  builder: (context, snapshot) {
                    return TextField(
                      autocorrect: true,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      onChanged: bloc.cvcChanged,
                      textInputAction: TextInputAction.next,
                      focusNode: cvcNode,
                      maxLength: 3,
                      maxLengthEnforced: true,
                      onSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(doneNode),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsetsDirectional.only(end: 8.0),
                          child: Icon(Icons.security_rounded),
                        ),
                        labelText: 'CVC',
                        errorText: snapshot.data,
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                RxStreamBuilder<bool>(
                  stream: bloc.isLoading$,
                  builder: (context, snapshot) {
                    if (snapshot.data) {
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
                    } else {
                      return Container(
                        width: 200,
                        height: 54,
                        child: Material(
                          elevation: 5.0,
                          clipBehavior: Clip.antiAlias,
                          shadowColor: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(27),
                          child: MaterialButton(
                            height: 54,
                            onPressed: () {
                              FocusScope.of(context).requestFocus(doneNode);
                              bloc.submit();
                            },
                            color: Theme.of(context).backgroundColor,
                            child: Text(
                              'ADD CARD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            splashColor: Theme.of(context).accentColor,
                            elevation: 12,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleMessage(Message msg) async {
    if (msg is AddCardSuccess) {
      context.showSnackBar('Added card successfully');
      await delay(500);
      Navigator.pop(context, msg.card);
      return;
    }
    if (msg is AddCardFailure) {
      return context
          .showSnackBar('Add card failed: ${getErrorMessage(msg.error)}');
    }
  }
}
