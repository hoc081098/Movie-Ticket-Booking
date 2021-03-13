import 'dart:async';

import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repository/user_repository.dart';
import '../../generated/l10n.dart';
import '../../utils/error.dart';
import 'login_state.dart';

/// BLoC handling google sign in
class GoogleSignInBloc extends DisposeCallbackBaseBloc {
  /// Sinks
  final VoidAction submitLogin;

  /// Streams
  final ValueStream<bool> isLoading$;
  final Stream<LoginMessage> message$;

  GoogleSignInBloc._({
    required this.isLoading$,
    required this.message$,
    required this.submitLogin,
    required VoidAction dispose,
  }) : super(dispose);

  factory GoogleSignInBloc(UserRepository userRepository) {
    /// Controllers
    //ignore: close_sinks
    final submitLoginController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);

    /// Streams
    final message$ = submitLoginController.stream
        .exhaustMap((_) => performLogin(userRepository, isLoadingController))
        .publish();

    final disposeBag = DisposeBag([
      message$
          .listen((value) => print('>>>>>>>>>>>>> GoogleSignInBloc $value >>')),
      message$.connect(),
      submitLoginController,
      isLoadingController,
    ]);

    return GoogleSignInBloc._(
      isLoading$: isLoadingController.stream,
      message$: message$,
      submitLogin: () => submitLoginController.add(null),
      dispose: () async {
        await disposeBag.dispose();
        print('$GoogleSignInBloc disposed');
      },
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
        S.current.googleSignInFailedGeterrormessagedeprecatede(
          getErrorMessageDeprecated(e),
        ),
        e,
      );
    }
    isLoadingController.add(false);
  }
}
