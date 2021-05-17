import 'package:built_collection/built_collection.dart';
import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:tuple/tuple.dart';

import '../../../domain/model/card.dart' as domain;
import '../../../domain/model/movie.dart';
import '../../../domain/model/product.dart';
import '../../../domain/model/promotion.dart';
import '../../../domain/model/reservation.dart';
import '../../../domain/model/show_time.dart';
import '../../../domain/model/theatre.dart';
import '../../../domain/model/ticket.dart';
import '../../../domain/model/user.dart';
import '../../../domain/repository/reservation_repository.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../generated/l10n.dart';
import '../../../utils/utils.dart';
import '../../app_scaffold.dart';
import '../../profile/reservation_detail/reservation_detail_page.dart';
import '../detail/movie_detail_page.dart';
import '../showtimes_by_theatre/show_time_by_theatre_page.dart';
import '../tickets/ticket_page.dart';
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
  final Reservation reservation;

  const CheckoutSuccess(this.reservation);
}

class CheckoutFailure implements Message {
  final Object error;

  const CheckoutFailure(this.error);
}

class MissingRequiredInfo implements Message {
  const MissingRequiredInfo();
}

class CheckoutBloc implements BaseBloc {
  final _emailS = PublishSubject<String>(sync: true);
  final _phoneS = PublishSubject<String?>(sync: true);
  final _cardS = BehaviorSubject<domain.Card?>.seeded(null, sync: true);
  final _promotionS = BehaviorSubject<Promotion?>.seeded(null, sync: true);

  final _submitS = PublishSubject<void>();
  final _isLoadingS = BehaviorSubject.seeded(false);

  final _bag = DisposeBag();

  ///
  late DistinctValueConnectableStream<String?> _emailError$;
  late DistinctValueConnectableStream<String?> _phoneError$;
  late ConnectableStream<Message> _message$;

  /// Inputs
  Function1<String, void> get emailChanged => _emailS.add;

  Function1<String, void> get phoneChanged => _phoneS.add;

  void selectedCard(domain.Card? card) => _cardS.add(card);

  void selectPromotion(Promotion promotion) => _promotionS.add(promotion);

  void submit() => _submitS.add(null);

  void initializeWith(User user) {
    _emailS.add(user.email);
    _phoneS.add(user.phoneNumber);
  }

  /// Outputs
  ValueStream<String?> get emailError$ => _emailError$;

  ValueStream<String?> get phoneError$ => _phoneError$;

  ValueStream<domain.Card?> get selectedCard$ => _cardS;

  ValueStream<Promotion?> get selectedPromotion$ => _promotionS;

  ValueStream<bool> get isLoading$ => _isLoadingS;

  Stream<Message> get message$ => _message$;

  CheckoutBloc({
    required final ShowTime showTime,
    required final BuiltList<Ticket> tickets,
    required final BuiltList<Tuple2<Product, int>> products,
    required ReservationRepository reservationRepository,
  }) {
    final email$ = _emailS
        .distinct()
        .map((e) => Tuple2(
            Validator.isValidEmail(e) ? null : S.current.invalidEmailAddress,
            e))
        .debug(identifier: 'EMAIL', log: streamDebugPrint)
        .share();

    final phone$ = _phoneS
        .distinct()
        .map((p) => Tuple2(
            p != null && phoneNumberRegex.hasMatch(p)
                ? null
                : S.current.invalidPhoneNumber,
            p))
        .debug(identifier: 'PHONE', log: streamDebugPrint)
        .share();

    _emailError$ =
        email$.map((tuple) => tuple.item1).publishValueDistinct(null);
    _phoneError$ =
        phone$.map((tuple) => tuple.item1).publishValueDistinct(null);

    final form$ = _submitS
        .debug(identifier: 'SUBMIT', log: streamDebugPrint)
        .withLatestFrom4(
          email$.cast<Tuple2<String?, String>?>().startWith(null),
          phone$.cast<Tuple2<String?, String>?>().startWith(null),
          _cardS,
          _promotionS,
          (
            _,
            Tuple2<String?, String>? email,
            Tuple2<String?, String>? phone,
            domain.Card? card,
            Promotion? promotion,
          ) =>
              email != null &&
                      email.item1 == null &&
                      phone != null &&
                      phone.item1 == null &&
                      card != null
                  ? Tuple4(email.item2, phone.item2, card, promotion)
                  : null,
        )
        .debug(identifier: 'FORM', log: streamDebugPrint)
        .share();
    _message$ = Rx.merge([
      form$.whereNotNull().exhaustMap(
            (emailPhoneCardPromotion) => reservationRepository
                .createReservation(
                  showTimeId: showTime.id,
                  phoneNumber: emailPhoneCardPromotion.item2,
                  email: emailPhoneCardPromotion.item1,
                  products: products,
                  payCardId: emailPhoneCardPromotion.item3.id,
                  ticketIds: [for (final t in tickets) t.id].build(),
                  promotion: emailPhoneCardPromotion.item4,
                )
                .debug(identifier: 'POST REQUEST', log: streamDebugPrint)
                .doOnListen(() => _isLoadingS.add(true))
                .doOnCancel(() => _isLoadingS.add(false))
                .map<Message>((r) => CheckoutSuccess(r))
                .onErrorReturnWith((error, s) => CheckoutFailure(error)),
          ),
      form$.where((v) => v == null).mapTo(const MissingRequiredInfo())
    ]).publish();

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
    Key? key,
    required this.tickets,
    required this.showTime,
    required this.theatre,
    required this.movie,
    required this.products,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with DisposeBagMixin {
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');
  final startTimeFormat = DateFormat('dd/MM/yy, EEE, hh:mm a');

  Object? token;

  @override
  void initState() {
    super.initState();

    final user = context
        .get<UserRepository>()
        .user$
        .value
        ?.fold(() => null, (user) => user);
    if (user != null) {
      context.get<CheckoutBloc>().initializeWith(user);
    }
  }

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
    final user = context
        .get<UserRepository>()
        .user$
        .value
        ?.fold(() => null, (user) => user);

    if (user == null) {
      return Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
      );
    }

    final buttonHeight = 54.0;
    final countDownStyle = Theme.of(context)
        .textTheme
        .subtitle2!
        .copyWith(color: Colors.white, fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).checkout),
        actions: [
          Center(
            child: RxStreamBuilder<String?>(
              stream:
                  TicketsCountDownTimerBlocProvider.shared().bloc.countDown$,
              builder: (context, data) {
                return data != null
                    ? Text(data, style: countDownStyle)
                    : const SizedBox();
              },
            ),
          ),
          const SizedBox(width: 12),
        ],
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
                    child: null,
                  ),
                ),
                SliverToBoxAdapter(
                  child: PhoneEmailForm(
                    user: user,
                  ),
                ),
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
                onSubmit: onSubmit,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleMessage(Message message) async {
    if (message is CheckoutSuccess) {
      context.showSnackBar(
          S.of(context).checkoutSuccessfullyPleaseCheckEmailToGetTicket);
      await delay(600);

      if (TicketsCountDownTimerBlocProvider.shared().fromDetailPage) {
        AppScaffold.navigatorByIndex(context, AppScaffoldIndex.home)
            .popUntilX(ModalRoute.withName(MovieDetailPage.routeName));
      } else {
        AppScaffold.navigatorByIndex(context, AppScaffoldIndex.home)
            .popUntilX(ModalRoute.withName(ShowTimesByTheatrePage.routeName));
      }

      unawaited(
        AppScaffold.navigatorOfCurrentIndex(context,
                switchToNewIndex: AppScaffoldIndex.profile)
            .pushNamedX(
          ReservationDetailPage.routeName,
          arguments: message.reservation,
        ),
      );
    }
    if (message is CheckoutFailure) {
      context.showSnackBar(S
          .of(context)
          .checkoutFailedGeterrormessagemessageerror(
              getErrorMessage(message.error)));
    }
    if (message is MissingRequiredInfo) {
      context.showSnackBar(S.of(context).missingRequiredFields);
    }
  }

  void onSubmit() async {
    FocusScope.of(context).unfocus();
    final bloc = context.get<CheckoutBloc>();

    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Pay for your tickets?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (identical(ok, true) && mounted) {
      print('submit');
      bloc.submit();
    }
  }
}
