import 'package:built_collection/built_collection.dart';
import 'package:tuple/tuple.dart';

import '../../domain/model/product.dart';
import '../../domain/repository/reservation_repository.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/reservation_response.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final AuthClient _authClient;

  ReservationRepositoryImpl(this._authClient);

  @override
  Stream<void> createReservation({
    String showTimeId,
    String phoneNumber,
    String email,
    BuiltList<Tuple2<Product, int>> products,
    int originalPrice,
    String payCardId,
    BuiltList<String> ticketIds,
  }) async* {
    final body = <String, dynamic>{
      'show_time_id': showTimeId,
      'phone_number': phoneNumber,
      'email': email,
      'products': products
          .map(
            (p) => {
              'product_id': p.item1.id,
              'quantity': p.item2,
            },
          )
          .toList(growable: false),
      'original_price': originalPrice,
      'pay_card_id': payCardId,
      'ticket_ids': ticketIds.toList(growable: false),
    };

    print('createReservation: $body');

    final json =
        await _authClient.postBody(buildUrl('/reservations'), body: body);
    print('createReservation: ${ReservationResponse.fromJson(json)}');

    yield null;
  }
}
