import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../utils/utils.dart';
import '../../../tickets/ticket_page.dart';
import '../cards_page.dart' show CardPageMode;
import 'add_card_bloc.dart';

class AddCardPage extends StatefulWidget {
  static const routeName = 'home/detail/tickets/combo/checkout/cards/add_card';

  final CardPageMode mode;

  const AddCardPage({Key? key, required this.mode}) : super(key: key);

  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> with DisposeBagMixin {
  final numberNode = FocusNode();
  final expNode = FocusNode();
  final cvcNode = FocusNode();

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
        .subtitle2!
        .copyWith(color: Colors.white, fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).addCard),
        actions: widget.mode == CardPageMode.select
            ? [
                Center(
                  child: RxStreamBuilder<String?>(
                    stream: TicketsCountDownTimerBlocProvider.shared()
                        .bloc
                        .countDown$,
                    builder: (context, data) {
                      return data != null
                          ? Text(data, style: countDownStyle)
                          : const SizedBox();
                    },
                  ),
                ),
                const SizedBox(width: 12),
              ]
            : null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RxStreamBuilder<String?>(
                  stream: bloc.cardHolderNameError$,
                  builder: (context, data) {
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
                        labelText: S.of(context).cardHolderName,
                        errorText: data,
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                RxStreamBuilder<String?>(
                  stream: bloc.numberError$,
                  builder: (context, data) {
                    return TextField(
                      autocorrect: true,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      onChanged: bloc.numberChanged,
                      textInputAction: TextInputAction.next,
                      focusNode: numberNode,
                      maxLength: 16,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      onSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(expNode),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsetsDirectional.only(end: 8.0),
                          child: Icon(Icons.credit_card_rounded),
                        ),
                        labelText: S.of(context).cardNumber,
                        errorText: data,
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                RxStreamBuilder<String?>(
                  stream: bloc.expError$,
                  builder: (context, data) {
                    return TextField(
                      autocorrect: true,
                      keyboardType: TextInputType.datetime,
                      maxLines: 1,
                      onChanged: bloc.expChanged,
                      textInputAction: TextInputAction.next,
                      focusNode: expNode,
                      maxLength: 5,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      onSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(cvcNode),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsetsDirectional.only(end: 8.0),
                          child: Icon(Icons.date_range_rounded),
                        ),
                        labelText: S.of(context).expireDateMmyy,
                        errorText: data,
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                RxStreamBuilder<String?>(
                  stream: bloc.cvcError$,
                  builder: (context, data) {
                    return TextField(
                      autocorrect: true,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      onChanged: bloc.cvcChanged,
                      textInputAction: TextInputAction.done,
                      focusNode: cvcNode,
                      maxLength: 3,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsetsDirectional.only(end: 8.0),
                          child: Icon(Icons.security_rounded),
                        ),
                        labelText: 'CVC',
                        errorText: data,
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                RxStreamBuilder<bool>(
                  stream: bloc.isLoading$,
                  builder: (context, data) {
                    if (data) {
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
                        width: 172,
                        height: 48,
                        child: Material(
                          elevation: 5.0,
                          clipBehavior: Clip.antiAlias,
                          shadowColor: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(27),
                          child: MaterialButton(
                            height: 48,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              bloc.submit();
                            },
                            color: Theme.of(context).accentColor,
                            elevation: 12,
                            child: Text(
                              S.of(context).ADDCARD,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
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
      context.showSnackBar(S.of(context).addedCardSuccessfully);
      await delay(500);
      Navigator.pop(context, msg.card);
      return;
    }
    if (msg is AddCardFailure) {
      return context.showSnackBar(
          S.of(context).addCardFailed(getErrorMessage(msg.error)));
    }
  }
}
