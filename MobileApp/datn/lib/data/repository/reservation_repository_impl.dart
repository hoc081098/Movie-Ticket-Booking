import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tuple/tuple.dart';

import '../../domain/model/product.dart';
import '../../domain/model/promotion.dart';
import '../../domain/model/reservation.dart';
import '../../domain/repository/reservation_repository.dart';
import '../../env_manager.dart';
import '../../utils/type_defs.dart';
import '../local/user_local_source.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/full_reservation_response.dart';
import '../remote/response/reservation_response.dart';
import '../serializers.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final AuthClient _authClient;
  final UserLocalSource _userLocalSource;

  final Function1<ReservationResponse, Reservation>
      _reservationResponseToReservation;
  final Function1<FullReservationResponse, Reservation>
      _fullReservationResponseToReservation;

  ReservationRepositoryImpl(
    this._authClient,
    this._userLocalSource,
    this._reservationResponseToReservation,
    this._fullReservationResponseToReservation,
  );

  @override
  Stream<Reservation> createReservation({
    String showTimeId,
    String phoneNumber,
    String email,
    BuiltList<Tuple2<Product, int>> products,
    String payCardId,
    BuiltList<String> ticketIds,
    Promotion promotion,
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
      'pay_card_id': payCardId,
      'ticket_ids': ticketIds.toList(growable: false),
      'promotion_id': promotion?.id,
    };

    print('createReservation: $body');

    final json =
        await _authClient.postBody(buildUrl('/reservations'), body: body);
    final response = ReservationResponse.fromJson(json);
    print('createReservation: ${response}');

    yield* getReservationById(response.id);
  }

  @override
  Stream<BuiltMap<String, Reservation>> watchReservedTicket(
          String showTimeId) =>
      _userLocalSource.token$
          .take(1)
          .exhaustMap((token) => _connectSocket(token, showTimeId));

  Stream<BuiltMap<String, Reservation>> _connectSocket(
      String token, String showTimeId) {
    final roomId = 'reservation:${showTimeId}';

    io.Socket socket;
    StreamController<BuiltMap<String, Reservation>> controller;

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
            final response = serializers.deserialize(
              data,
              specifiedType: builtMapStringReservationResponse,
            ) as BuiltMap<String, ReservationResponse>;
            final map = response.map(
                (k, v) => MapEntry(k, _reservationResponseToReservation(v)));

            assert(controller != null);
            print('[ReservationRepositoryImpl] reserved $map');
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

  @override
  Stream<BuiltList<Reservation>> getReservation({int page, int perPage}) {
    final mapResult = (dynamic json) {
      final responses = serializers.deserialize(
        json,
        specifiedType: builtListFullReservationResponse,
      ) as BuiltList<FullReservationResponse>;

      return [
        for (final r in responses) _fullReservationResponseToReservation(r)
      ].build();
    };

    return Rx.fromCallable(
      () => _authClient.getBody(
        buildUrl(
          '/reservations',
          {
            'page': page.toString(),
            'per_page': perPage.toString(),
          },
        ),
      ),
    ).map(mapResult);
  }

  @override
  Stream<Reservation> getReservationById(String id) {
    return Rx.fromCallable(
      () => _authClient.getBody(
        buildUrl('/reservations/${ArgumentError.checkNotNull(id, 'id')}'),
      ),
    ).map((json) => _fullReservationResponseToReservation(
        FullReservationResponse.fromJson(json)));
  }

  @override
  Stream<Uint8List> getQrCode(String id) => Rx.fromCallable(
        () => _authClient
            .get(buildUrl('/reservations/qrcode/$id'))
            .then((value) => value.body.split('base64,')[1])
            .then((value) => base64Decode(value)),
      );
}
