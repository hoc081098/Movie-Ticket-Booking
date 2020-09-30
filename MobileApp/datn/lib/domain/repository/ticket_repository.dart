import 'package:built_collection/built_collection.dart';

import '../model/ticket.dart';

abstract class TicketRepository {
  Stream<BuiltList<Ticket>> getTicketsByShowTimeId(String id);
}
