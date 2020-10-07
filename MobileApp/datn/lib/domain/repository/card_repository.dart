import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

import '../model/card.dart';

abstract class CardRepository {
  Stream<BuiltList<Card>> getCards();

  Stream<Card> removeCard(Card card);

  Stream<Card> addCard({
    @required String cardHolderName,
    @required String number,
    @required int cvc,
    @required int expYear,
    @required int expMonth,
  });
}
