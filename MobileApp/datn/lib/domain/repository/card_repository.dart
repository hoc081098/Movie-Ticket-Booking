import 'package:built_collection/built_collection.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../model/card.dart';

abstract class CardRepository {
  Single<BuiltList<Card>> getCards();

  Single<Card> removeCard(Card card);

  Single<Card> addCard({
    required String cardHolderName,
    required String number,
    required int cvc,
    required int expYear,
    required int expMonth,
  });
}
