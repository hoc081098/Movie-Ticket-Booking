import 'package:built_collection/built_collection.dart';

import '../model/promotion.dart';

abstract class PromotionRepository {
  Stream<BuiltList<Promotion>> getPromotions(String showTimeId);
}
