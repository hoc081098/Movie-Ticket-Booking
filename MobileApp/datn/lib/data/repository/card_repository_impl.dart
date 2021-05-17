import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../../domain/model/card.dart';
import '../../domain/repository/card_repository.dart';
import '../../utils/utils.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/card_response.dart';

class CardRepositoryImpl implements CardRepository {
  final AuthHttpClient _authClient;
  final Function1<CardResponse, Card> _cardResponseToCard;

  CardRepositoryImpl(this._authClient, this._cardResponseToCard);

  @override
  Stream<BuiltList<Card>> getCards() async* {
    final json = await _authClient.getJson(buildUrl('/cards')) as List;
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
    required String cardHolderName,
    required String number,
    required int cvc,
    required int expYear,
    required int expMonth,
  }) async* {
    final body = {
      'card_holder_name': cardHolderName,
      'number': number,
      'cvc': cvc.toString(),
      'exp_month': expMonth,
      'exp_year': expYear,
    };
    final json = await _authClient.postJson(
      buildUrl('/cards'),
      body: body,
    );
    yield _cardResponseToCard(CardResponse.fromJson(json));
  }
}
