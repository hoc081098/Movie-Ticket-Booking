import 'dart:async';

import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repository/user_repository.dart';
import '../../generated/l10n.dart';
import '../../utils/error.dart';
import 'login_state.dart';

/// BLoC handling facebook sign in
class FacebookLoginBloc extends DisposeCallbackBaseBloc {
  /// Sinks
  final VoidAction submitLogin;

  /// Streams
  final ValueStream<bool> isLoading$;
  final Stream<LoginMessage> message$;

  FacebookLoginBloc._({
    required this.isLoading$,
    required this.message$,
    required this.submitLogin,
    required VoidAction dispose,
  }) : super(dispose);

  factory FacebookLoginBloc(UserRepository userRepository) {
    /// Controllers
    //ignore: close_sinks
    final submitLoginController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);

    /// Streams
    final message$ = submitLoginController.stream
        .exhaustMap((_) => performLogin(userRepository, isLoadingController))
        .publish();

    /// Subscriptions and controllers
    final subscriptions = <StreamSubscription>[
      message$.connect(),
    ];
    final controllers = <StreamController>[
      submitLoginController,
      isLoadingController,
    ];

    return FacebookLoginBloc._(
      isLoading$: isLoadingController.stream,
      message$: message$,
      submitLogin: () => submitLoginController.add(null),
      dispose: () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait(controllers.map((c) => c.close()));
      },
    );
  }

  static Stream<LoginMessage> performLogin(
    UserRepository userRepository,
    Sink<bool> isLoadingS,
  ) async* {
    isLoadingS.add(true);

    try {
      await userRepository.facebookSignIn();
      yield const LoginSuccessMessage();
    } catch (e) {
      yield LoginErrorMessage(
        S.current.facebookLoginErrorGeterrormessagedeprecatede(
          getErrorMessageDeprecated(e),
        ),
        e,
      );
    }

    isLoadingS.add(false);
  }
}
