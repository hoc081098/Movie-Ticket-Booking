import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tuple/tuple.dart';

import '../../domain/model/product.dart';
import '../../domain/model/promotion.dart';
import '../../domain/model/reservation.dart';
import '../../domain/repository/reservation_repository.dart';
import '../../env_manager.dart';
import '../../utils/utils.dart';
import '../local/user_local_source.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/full_reservation_response.dart';
import '../remote/response/reservation_response.dart';
import '../serializers.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final AuthHttpClient _authClient;
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
    required String showTimeId,
    required String phoneNumber,
    required String email,
    required BuiltList<Tuple2<Product, int>> products,
    required String payCardId,
    required BuiltList<String> ticketIds,
    required Promotion? promotion,
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

    debugPrint('createReservation: $body');

    final json =
        await _authClient.postJson(buildUrl('/reservations'), body: body);
    final response = ReservationResponse.fromJson(json);
    debugPrint('createReservation: $response');

    yield* getReservationById(response.id);
  }

  @override
  Stream<BuiltMap<String, Reservation>> watchReservedTicket(
          String showTimeId) =>
      _userLocalSource.token$
          .take(1)
          .whereNotNull()
          .exhaustMap((token) => _connectSocket(token, showTimeId));

  Stream<BuiltMap<String, Reservation>> _connectSocket(
      String token, String showTimeId) {
    final roomId = 'reservation:$showTimeId';
    final tag = '[ReservationRepositoryImpl]';

    io.Socket? socketRef;
    StreamController<BuiltMap<String, Reservation>>? controller;

    controller = StreamController(
      sync: true,
      onListen: () {
        final socket = socketRef = io.io(
          EnvManager.shared.get(EnvKey.WS_URL),
          io.OptionBuilder()
              .setTransports(['websocket'])
              .setPath(EnvManager.shared.get(EnvKey.WS_PATH))
              .setQuery({'token': 'Bearer $token'})
              .build(),
        );

        socket.onConnect((data) {
          debugPrint('$tag connected $data');

          socket.emit('join', roomId);

          socket.on('reserved', (data) {
            final response = serializers.deserialize(
              data,
              specifiedType: builtMapStringReservationResponse,
            ) as BuiltMap<String, ReservationResponse>;
            final map = response.map(
                (k, v) => MapEntry(k, _reservationResponseToReservation(v)));

            debugPrint(
                '$tag reserved map=$map controller=$controller socketRef=$socketRef');
            controller?.add(map);
          });
        });

        // listens to events.

        socket.onConnecting((data) => debugPrint('$tag connecting... $data'));
        socket.onConnectError((data) => debugPrint('$tag connect_error $data'));
        socket.onConnectTimeout(
            (data) => debugPrint('$tag connect_timeout $data'));
        socket.onError((data) => debugPrint('$tag error $data'));

        socket.onReconnect((data) => debugPrint('$tag reconnect $data'));
        socket.onReconnectAttempt(
            (data) => debugPrint('$tag reconnect_attempt $data'));
        socket.onReconnectFailed(
            (data) => debugPrint('$tag reconnect_failed $data'));
        socket.onReconnectError(
            (data) => debugPrint('$tag reconnect_error $data'));
        socket
            .onReconnecting((data) => debugPrint('$tag reconnecting... $data'));

        socket.onPing((data) => debugPrint('$tag ping $data'));
        socket.onPong((data) => debugPrint('$tag pong $data'));

        socket.onDisconnect((data) => debugPrint('$tag disconnect data=$data'));
      },
      onPause: () {},
      onResume: () {},
      onCancel: () {
        controller = null;

        socketRef?.dispose();
        socketRef = null;

        debugPrint('$tag disposed');
      },
    );

    return controller!.stream;
  }

  @override
  Stream<BuiltList<Reservation>> getReservation({
    required int page,
    required int perPage,
  }) {
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
      () => _authClient.getJson(
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
      () => _authClient.getJson(
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
