import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:tuple/tuple.dart';

import '../../../../../domain/model/card.dart';
import '../../../../../domain/repository/card_repository.dart';
import '../../../../../utils/utils.dart';

abstract class Message {}

class AddCardSuccess implements Message {
  final Card card;

  AddCardSuccess(this.card);
}

class AddCardFailure implements Message {
  final Object error;

  AddCardFailure(this.error);
}

class _Form {
  final String cardHolderName;
  final String number;
  final int cvc;
  final int expYear;
  final int expMonth;

  _Form({
    required this.cardHolderName,
    required this.number,
    required this.cvc,
    required this.expYear,
    required this.expMonth,
  });
}

final _numberRegex = RegExp(r'''^[0-9]{16}$''');
final _cvcRegex = RegExp(r'''^[0-9]{3}$''');
final _expRegex = RegExp(r'''^([1-9]|0[1-9]|1[0-2])/(\d{2})$''');

class AddCardBloc extends DisposeCallbackBaseBloc {
  final Function1<String, void> cardHolderNameChanged;
  final Function1<String, void> numberChanged;
  final Function1<String, void> expChanged;
  final Function1<String, void> cvcChanged;
  final Function0<void> submit;

  final ValueStream<String?> cardHolderNameError$;
  final ValueStream<String?> numberError$;
  final ValueStream<String?> expError$;
  final ValueStream<String?> cvcError$;
  final ValueStream<bool> isLoading$;
  final Stream<Message> message$;

  AddCardBloc._({
    required this.cardHolderNameChanged,
    required this.numberChanged,
    required this.expChanged,
    required this.cvcChanged,
    required this.submit,
    required this.cardHolderNameError$,
    required this.numberError$,
    required this.expError$,
    required this.cvcError$,
    required this.isLoading$,
    required this.message$,
    required void Function() dispose,
  }) : super(dispose);

  factory AddCardBloc(CardRepository cardRepository) {
    // Controllers
    final cardHolderNameS = PublishSubject<String>(sync: true);
    final numberS = PublishSubject<String>(sync: true);
    final cvcS = PublishSubject<String>(sync: true);
    final expS = PublishSubject<String>(sync: true);
    final submitS = PublishSubject<void>();
    final isLoadingS = BehaviorSubject.seeded(false);

    // Form
    final cardHolderName$ = cardHolderNameS
        .map(
            (s) => s.length < 3 ? Tuple2('Too short name', s) : Tuple2(null, s))
        .share();
    final number$ = numberS
        .map((s) => _numberRegex.hasMatch(s)
            ? Tuple2(null, s)
            : Tuple2('Invalid number', s))
        .share();
    final cvc$ = cvcS.distinct().map(_parseCvc).share();
    final exp$ = expS.distinct().map(_parseExp).share();

    // Errors
    final cardHolderNameError$ =
        cardHolderName$.map((tuple) => tuple.item1).publishValueDistinct(null);
    final numberError$ =
        number$.map((tuple) => tuple.item1).publishValueDistinct(null);
    final cvcError$ =
        cvc$.map((tuple) => tuple.item1).publishValueDistinct(null);
    final expError$ =
        exp$.map((tuple) => tuple.item1).publishValueDistinct(null);

    final message$ = submitS
        .withLatestFrom4(
          cardHolderName$,
          number$,
          cvc$,
          exp$,
          (
            void _,
            Tuple2<String?, String> holderName,
            Tuple2<String?, String> number,
            Tuple2<String?, int?> cvc,
            Tuple3<String?, int?, int?> exp,
          ) =>
              holderName.item1 == null &&
                      number.item1 == null &&
                      cvc.item1 == null &&
                      exp.item1 == null
                  ? _Form(
                      cardHolderName: holderName.item2,
                      number: number.item2,
                      cvc: cvc.item2!,
                      expMonth: exp.item2!,
                      expYear: exp.item3!,
                    )
                  : null,
        )
        .whereNotNull()
        .exhaustMap(
          (form) => cardRepository
              .addCard(
                cardHolderName: form.cardHolderName,
                number: form.number,
                cvc: form.cvc,
                expYear: form.expYear,
                expMonth: form.expMonth,
              )
              .doOnListen(() => isLoadingS.add(true))
              .doOnCancel(() => isLoadingS.add(false))
              .map<Message>((card) => AddCardSuccess(card))
              .onErrorReturnWith((error, s) => AddCardFailure(error)),
        )
        .publish();

    // Dispose
    final bag = DisposeBag();
    <Sink>[
      cardHolderNameS,
      numberS,
      cvcS,
      expS,
      submitS,
      isLoadingS,
    ].disposedBy(bag);
    [
      ...<String, Stream>{
        'cardHolderNameError': cardHolderNameError$,
        'numberError': numberError$,
        'cvcError': cvcError$,
        'expError': expError$,
        'message': message$,
        'isLoading': isLoadingS,
      }.debug(),
      cardHolderNameError$.connect(),
      numberError$.connect(),
      cvcError$.connect(),
      expError$.connect(),
      message$.connect(),
    ].disposedBy(bag);

    return AddCardBloc._(
      cardHolderNameChanged: cardHolderNameS.add,
      numberChanged: numberS.add,
      expChanged: expS.add,
      cvcChanged: cvcS.add,
      submit: () => submitS.add(null),
      cardHolderNameError$: cardHolderNameError$,
      numberError$: numberError$,
      expError$: expError$,
      cvcError$: cvcError$,
      isLoading$: isLoadingS,
      message$: message$,
      dispose: bag.dispose,
    );
  }

  static Tuple2<String?, int?> _parseCvc(String s) {
    if (!_cvcRegex.hasMatch(s)) {
      return const Tuple2('Invalid cvc', null);
    }
    final cvc = int.tryParse(s);
    return cvc == null ? const Tuple2('Invalid cvc', null) : Tuple2(null, cvc);
  }

  static Tuple3<String?, int?, int?> _parseExp(String s) {
    final match = _expRegex.firstMatch(s);
    if (match == null || match.groupCount != 2) {
      return const Tuple3('Invalid expired date', null, null);
    }

    final month = int.tryParse(match.group(1)!);
    final year = int.tryParse(match.group(2)!);
    if (month == null || year == null) {
      return const Tuple3('Invalid expired date', null, null);
    }

    final current = DateTime.now();
    final currentYear = current.year % 100;
    if (year < currentYear) {
      return const Tuple3('Invalid expired date', null, null);
    }
    if (year == currentYear && month < current.month) {
      return const Tuple3('Invalid expired date', null, null);
    }

    return Tuple3(null, month, year);
  }
}
