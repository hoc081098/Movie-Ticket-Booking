import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tuple/tuple.dart';

import '../../domain/model/product.dart';
import '../../domain/repository/reservation_repository.dart';
import '../../env_manager.dart';
import '../local/user_local_source.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/reservation_response.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final AuthClient _authClient;
  final UserLocalSource _userLocalSource;

  ReservationRepositoryImpl(this._authClient, this._userLocalSource);

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

  @override
  Stream<BuiltMap<String, String>> watchReservedTicket(String showTimeId) =>
      _userLocalSource.token$
          .take(1)
          .exhaustMap((token) => _connectSocket(token, showTimeId));

  Stream<BuiltMap<String, String>> _connectSocket(
      String token, String showTimeId) {
    final roomId = 'reservation:${showTimeId}';

    io.Socket socket;
    StreamController<BuiltMap<String, String>> controller;

    controller = StreamController(
      sync: true,
      onListen: () {
        socket = io.io(
          EnvManager.shared.get(EnvKey.WS_URL),
          {
            'transports': ['websocket'],
            'path': EnvManager.shared.get(EnvKey.WS_PATH),
            'query': {
              'token': 'Bearer $token',
            }
          },
        );

        print('[ReservationRepositoryImpl] start connect $socket');

        socket.on('connect', (_) {
          print('[ReservationRepositoryImpl] connected');

          socket.emit('join', roomId);

          socket.on('reserved', (data) {
            print('[ReservationRepositoryImpl] reserved $data');

            final map = BuiltMap.from(data as Map<String, dynamic>);
            assert(controller != null);
            controller.add(map);
          });
        });

        socket.on('connecting',
            (data) => print('[ReservationRepositoryImpl] connecting'));
        socket.on('reconnect',
            (data) => print('[ReservationRepositoryImpl] reconnect'));
        socket.on('reconnect_attempt',
            (data) => print('[ReservationRepositoryImpl] reconnect_attempt'));
        socket.on('reconnect_failed',
            (data) => print('[ReservationRepositoryImpl] reconnect_failed'));
        socket.on('reconnect_error',
            (data) => print('[ReservationRepositoryImpl] reconnect_error'));
        socket.on('reconnecting',
            (data) => print('[ReservationRepositoryImpl] reconnecting'));

        socket.on('disconnect', (_) {
          controller?.close();
          print('[ReservationRepositoryImpl] disconnected $controller');
        });
      },
      onPause: () {},
      onResume: () {},
      onCancel: () {
        controller = null;
        socket.emit('leave', roomId);
        socket.dispose();
        print('[ReservationRepositoryImpl] disposed');
      },
    );

    assert(controller != null);
    return controller.stream;
  }
}
