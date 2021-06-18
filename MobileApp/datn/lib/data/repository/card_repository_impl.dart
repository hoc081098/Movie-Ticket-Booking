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
  Single<BuiltList<Card>> getCards() =>
      Single.fromCallable(() => _authClient.getJson(buildUrl('/cards')))
          .cast<List>()
          .map((json) => json
              .map((e) => CardResponse.fromJson(e))
              .map(_cardResponseToCard)
              .toBuiltList());

  @override
  Single<Card> removeCard(Card card) => Single.fromCallable(
          () => _authClient.delete(buildUrl('/cards/${card.id}')))
      .mapTo(card)
      .singleOrError();

  @override
  Single<Card> addCard({
    required String cardHolderName,
    required String number,
    required int cvc,
    required int expYear,
    required int expMonth,
  }) =>
      Single.fromCallable(() {
        final body = {
          'card_holder_name': cardHolderName,
          'number': number,
          'cvc': cvc.toString(),
          'exp_month': expMonth,
          'exp_year': expYear,
        };
        return _authClient.postJson(
          buildUrl('/cards'),
          body: body,
        );
      }).map((json) => CardResponse.fromJson(json)).map(_cardResponseToCard);
}
