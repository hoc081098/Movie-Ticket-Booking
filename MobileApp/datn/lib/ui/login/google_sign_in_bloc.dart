import 'dart:async';

import 'package:datn/domain/repository/user_repository.dart';
import 'package:datn/ui/login/login_state.dart';
import 'package:datn/utils/error.dart';
import 'package:datn/utils/type_defs.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

/// BLoC handling google sign in
class GoogleSignInBloc extends DisposeCallbackBaseBloc {
  /// Sinks
  final Function0<void> submitLogin;

  /// Streams
  final ValueStream<bool> isLoading$;
  final Stream<LoginMessage> message$;

  GoogleSignInBloc._({
    @required this.isLoading$,
    @required this.message$,
    @required this.submitLogin,
    @required void Function() dispose,
  }) : super(dispose);

  factory GoogleSignInBloc(UserRepository userRepository) {
    ///Assert
    assert(userRepository != null, 'userRepository cannot be null');

    /// Controllers
    //ignore: close_sinks
    final submitLoginController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);

    /// Streams
    final message$ = submitLoginController.stream
        .exhaustMap((_) => performLogin(userRepository, isLoadingController))
        .publish();

    return GoogleSignInBloc._(
      isLoading$: isLoadingController.stream,
      message$: message$,
      submitLogin: () => submitLoginController.add(null),
      dispose: DisposeBag([
        message$.listen(
            (value) => print('>>>>>>>>>>>>> GoogleSignInBloc $value >>')),
        message$.connect(),
        submitLoginController,
        isLoadingController,
      ]).dispose,
    );
  }

  static Stream<LoginMessage> performLogin(
    UserRepository userRepository,
    Sink<bool> isLoadingController,
  ) async* {
    isLoadingController.add(true);
    try {
      await userRepository.googleSignIn();
      yield const LoginSuccessMessage();
    } catch (e) {
      yield LoginErrorMessage(
          'Google sign in failed: ${getErrorMessage(e)}', e);
    }
    isLoadingController.add(false);
  }
}
