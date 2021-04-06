import 'package:built_collection/src/list.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/model/promotion.dart';
import '../../domain/repository/promotion_repository.dart';
import '../../utils/utils.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/promotion_response.dart';
import '../serializers.dart';

class PromotionRepositoryImpl implements PromotionRepository {
  final AuthHttpClient _authClient;
  final Function1<PromotionResponse, Promotion> _promotionResponseToPromotion;

  PromotionRepositoryImpl(this._authClient, this._promotionResponseToPromotion);

  @override
  Stream<BuiltList<Promotion>> getPromotions(String showTimeId) {
    final jsonToResponses = (dynamic json) => serializers.deserialize(
          json,
          specifiedType: builtListPromotionResponses,
        ) as BuiltList<PromotionResponse>;

    final toDomain = (BuiltList<PromotionResponse> responses) => [
          for (final response in responses)
            _promotionResponseToPromotion(response)
        ].build();

    return Rx.fromCallable(
      () => _authClient
          .getJson(buildUrl('/promotions/show-times/$showTimeId'))
          .then(jsonToResponses.pipe(toDomain)),
    );
  }
}
