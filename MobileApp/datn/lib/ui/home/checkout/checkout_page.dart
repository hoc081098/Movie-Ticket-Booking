import 'package:built_collection/built_collection.dart';
import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../../domain/model/movie.dart';
import '../../../domain/model/product.dart';
import '../../../domain/model/card.dart' as domain;
import '../../../domain/model/show_time.dart';
import '../../../domain/model/theatre.dart';
import '../../../domain/model/ticket.dart';
import '../../../utils/type_defs.dart';
import '../../../utils/utils.dart';
import 'widgets/bottom.dart';
import 'widgets/card.dart';
import 'widgets/header.dart';
import 'widgets/phone_email_form.dart';

final phoneNumberRegex = RegExp(
  r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$',
  caseSensitive: false,
);

class CheckoutBloc implements BaseBloc {
  final _emailS = PublishSubject<String>();
  final _phoneS = PublishSubject<String>();
  final _cardS = BehaviorSubject<domain.Card>.seeded(null);
  final _bag = DisposeBag();

  ///
  DistinctValueConnectableStream<String> _emailError$;
  DistinctValueConnectableStream<String> _phoneError$;

  /// Inputs
  Function1<String, void> get emailChanged => _emailS.add;

  Function1<String, void> get phoneChanged => _phoneS.add;

  Function1<domain.Card, void> get selectedCard => _cardS.add;

  /// Outputs
  ValueStream<String> get emailError$ => _emailError$;

  ValueStream<String> get phoneError$ => _phoneError$;

  ValueStream<domain.Card> get selectedCard$ => _cardS;

  CheckoutBloc() {
    _emailError$ = _emailS
        .map((e) => Validator.isValidEmail(e) ? null : 'Invalid email address')
        .publishValueSeededDistinct(seedValue: null);

    _phoneError$ = _phoneS
        .map(
            (p) => phoneNumberRegex.hasMatch(p) ? null : 'Invalid phone number')
        .publishValueSeededDistinct(seedValue: null);

    _emailError$.connect().disposedBy(_bag);
    _phoneError$.connect().disposedBy(_bag);

    _emailS.disposedBy(_bag);
    _phoneS.disposedBy(_bag);
  }

  @override
  void dispose() => _bag.dispose();

  void submit() {}
}

class CheckoutPage extends StatefulWidget {
  static const routeName = 'home/detail/tickets/combo/checkout';

  final ShowTime showTime;
  final Theatre theatre;
  final Movie movie;
  final BuiltList<Ticket> tickets;
  final BuiltList<Tuple2<Product, int>> products;

  const CheckoutPage({
    Key key,
    @required this.tickets,
    @required this.showTime,
    @required this.theatre,
    @required this.movie,
    @required this.products,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');
  final startTimeFormat = DateFormat('dd/MM/yy, EE, hh:mm a');

  @override
  Widget build(BuildContext context) {
    final buttonHeight = 54.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            top: 0,
            right: 0,
            left: 0,
            bottom: buttonHeight + 8,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: HeaderWidget(
                    movie: widget.movie,
                    showTime: widget.showTime,
                    theatre: widget.theatre,
                    tickets: widget.tickets,
                  ),
                ),
                SliverToBoxAdapter(child: const PhoneEmailForm()),
                SliverToBoxAdapter(child: const SelectedCard()),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: Offset(0, -4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              height: buttonHeight,
              child: BottomRow(
                tickets: widget.tickets,
                comboItems: widget.products,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
