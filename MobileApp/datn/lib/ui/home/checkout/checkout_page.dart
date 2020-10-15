import 'package:built_collection/built_collection.dart';
import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../../domain/model/card.dart' as domain;
import '../../../domain/model/movie.dart';
import '../../../domain/model/product.dart';
import '../../../domain/model/promotion.dart';
import '../../../domain/model/show_time.dart';
import '../../../domain/model/theatre.dart';
import '../../../domain/model/ticket.dart';
import '../../../domain/repository/reservation_repository.dart';
import '../../../utils/type_defs.dart';
import '../../../utils/utils.dart';
import 'widgets/bottom.dart';
import 'widgets/card.dart';
import 'widgets/discount.dart';
import 'widgets/header.dart';
import 'widgets/phone_email_form.dart';

final phoneNumberRegex = RegExp(
  r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$',
  caseSensitive: false,
);

abstract class Message {}

class CheckoutSuccess implements Message {
  CheckoutSuccess();
}

class CheckoutFailure implements Message {
  final Object error;

  CheckoutFailure(this.error);
}

class CheckoutBloc implements BaseBloc {
  final _emailS = PublishSubject<String>(sync: true);
  final _phoneS = PublishSubject<String>(sync: true);
  final _cardS = BehaviorSubject<domain.Card>.seeded(null, sync: true);
  final _promotionS = BehaviorSubject<Promotion>.seeded(null, sync: true);

  final _submitS = PublishSubject<void>();
  final _isLoadingS = BehaviorSubject.seeded(false);

  final _bag = DisposeBag();

  ///
  DistinctValueConnectableStream<String> _emailError$;
  DistinctValueConnectableStream<String> _phoneError$;
  ConnectableStream<Message> _message$;

  /// Inputs
  Function1<String, void> get emailChanged => _emailS.add;

  Function1<String, void> get phoneChanged => _phoneS.add;

  Function1<domain.Card, void> get selectedCard => _cardS.add;

  void selectPromotion(Promotion promotion) => _promotionS.add(promotion);

  Function0<void> get submit => () => _submitS.add(null);

  /// Outputs
  ValueStream<String> get emailError$ => _emailError$;

  ValueStream<String> get phoneError$ => _phoneError$;

  ValueStream<domain.Card> get selectedCard$ => _cardS;

  ValueStream<Promotion> get selectedPromotion$ => _promotionS;

  ValueStream<bool> get isLoading$ => _isLoadingS;

  Stream<Message> get message$ => _message$;

  CheckoutBloc({
    @required final ShowTime showTime,
    @required final BuiltList<Ticket> tickets,
    @required final BuiltList<Tuple2<Product, int>> products,
    @required ReservationRepository reservationRepository,
  }) {
    final email$ = _emailS
        .distinct()
        .map((e) => Tuple2(
            Validator.isValidEmail(e) ? null : 'Invalid email address', e))
        .share();

    final phone$ = _phoneS
        .distinct()
        .map((p) => Tuple2(
            phoneNumberRegex.hasMatch(p) ? null : 'Invalid phone number', p))
        .share();

    _emailError$ = email$
        .map((tuple) => tuple.item1)
        .publishValueSeededDistinct(seedValue: null);
    _phoneError$ = phone$
        .map((tuple) => tuple.item1)
        .publishValueSeededDistinct(seedValue: null);

    _message$ = _submitS
        .doOnData((event) => print('[DEBUG] submit...'))
        .withLatestFrom3(
          email$,
          phone$,
          _cardS,
          (
            _,
            Tuple2<String, String> email,
            Tuple2<String, String> phone,
            domain.Card card,
          ) =>
              email.item1 == null && phone.item1 == null && card != null
                  ? Tuple3(email.item2, phone.item2, card)
                  : null,
        )
        .debug('FORM')
        .where((v) => v != null)
        .exhaustMap(
          (emailPhoneCard) => reservationRepository
              .createReservation(
                showTimeId: showTime.id,
                phoneNumber: emailPhoneCard.item2,
                email: emailPhoneCard.item1,
                products: products,
                originalPrice: tickets.fold(0, (acc, e) => acc + e.price) +
                    products.fold(0, (acc, e) => acc + e.item1.price * e.item2),
                payCardId: emailPhoneCard.item3.id,
                ticketIds: [for (final t in tickets) t.id].build(),
              )
              .doOnListen(() => _isLoadingS.add(true))
              .doOnCancel(() => _isLoadingS.add(false))
              .map<Message>((_) => CheckoutSuccess())
              .onErrorReturnWith((error) => CheckoutFailure(error)),
        )
        .publish();

    [
      _emailError$.connect(),
      _phoneError$.connect(),
      _message$.connect(),
    ].disposedBy(_bag);

    <Sink>[
      _emailS,
      _phoneS,
      _cardS,
      _submitS,
      _isLoadingS,
      _promotionS,
    ].disposedBy(_bag);
  }

  @override
  void dispose() => _bag.dispose();
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

class _CheckoutPageState extends State<CheckoutPage> with DisposeBagMixin {
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');
  final startTimeFormat = DateFormat('dd/MM/yy, EE, hh:mm a');

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Object token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    token ??= BlocProvider.of<CheckoutBloc>(context)
        .message$
        .listen(handleMessage)
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final buttonHeight = 54.0;

    return Scaffold(
      key: scaffoldKey,
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
                SliverToBoxAdapter(
                  child: SelectDiscount(
                    showTime: widget.showTime,
                  ),
                ),
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

  void handleMessage(Message message) async {
    if (message is CheckoutSuccess) {
      scaffoldKey.showSnackBar('Checkout successfully');
    }
    if (message is CheckoutFailure) {
      scaffoldKey
          .showSnackBar('Checkout failed: ${getErrorMessage(message.error)}');
    }
  }
}
