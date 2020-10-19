import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/model/card.dart';
import '../../domain/repository/card_repository.dart';
import '../../utils/type_defs.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/card_response.dart';

class CardRepositoryImpl implements CardRepository {
  final AuthClient _authClient;
  final Function1<CardResponse, Card> _cardResponseToCard;

  CardRepositoryImpl(this._authClient, this._cardResponseToCard);

  @override
  Stream<BuiltList<Card>> getCards() async* {
    final json = await _authClient.getBody(buildUrl('/cards')) as List;
    yield json
        .map((e) => CardResponse.fromJson(e))
        .map(_cardResponseToCard)
        .toBuiltList();
  }

  @override
  Stream<Card> removeCard(Card card) =>
      Rx.fromCallable(() => _authClient.delete(buildUrl('/cards/${card.id}')))
          .mapTo(card);

  @override
  Stream<Card> addCard({
    String cardHolderName,
    String number,
    int cvc,
    int expYear,
    int expMonth,
  }) async* {
    final body = {
      'card_holder_name': cardHolderName,
      'number': number,
      'cvc': cvc.toString(),
      'exp_month': expMonth,
      'exp_year': expYear,
    };
    final json = await _authClient.postBody(
      buildUrl('/cards'),
      body: body,
    );
    yield _cardResponseToCard(CardResponse.fromJson(json));
  }
}
