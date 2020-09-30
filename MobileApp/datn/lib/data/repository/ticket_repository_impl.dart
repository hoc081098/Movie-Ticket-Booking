import 'package:built_collection/built_collection.dart';

import '../../domain/model/ticket.dart';
import '../../domain/repository/ticket_repository.dart';
import '../../utils/type_defs.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/ticket_response.dart';
import '../serializers.dart';

class TicketRepositoryImpl implements TicketRepository {
  final AuthClient _authClient;
  final Function1<TicketResponse, Ticket> _ticketResponseToTicket;

  TicketRepositoryImpl(
    this._authClient,
    this._ticketResponseToTicket,
  );

  @override
  Stream<BuiltList<Ticket>> getTicketsByShowTimeId(String id) async* {
    final json =
        await _authClient.getBody(buildUrl('/seats/tickets/show-times/$id'));

    final tickets = serializers.deserialize(
      json,
      specifiedType: builtListTicketResponse,
    ) as BuiltList<TicketResponse>;

    yield tickets.map(_ticketResponseToTicket).toBuiltList();
  }
}
