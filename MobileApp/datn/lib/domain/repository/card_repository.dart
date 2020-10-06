import 'package:built_collection/built_collection.dart';

import '../model/card.dart';

abstract class CardRepository {
  Stream<BuiltList<Card>> getCards();

  Stream<Card> removeCard(Card card);
}
