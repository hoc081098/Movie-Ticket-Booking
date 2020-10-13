import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/manager_repository.dart';

import '../../utils/type_defs.dart';

/// BLoC that handles validating form and login
class ManagerUsersBloc extends DisposeCallbackBaseBloc {
  /// Input functions
  Fu

  /// Streams
  final Stream<List<User>> usersStream;

  ManagerUsersBloc._(Function0<void> dispose, {@required this.usersStream})
      : super(dispose);

  factory ManagerUsersBloc(final ManagerRepository managerRepository) {
    assert(managerRepository != null);
    usersStream = Rx.
  }
}
