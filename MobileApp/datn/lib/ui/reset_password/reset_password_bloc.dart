// ignore_for_file: close_sinks

import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repository/user_repository.dart';
import '../../utils/error.dart';
import '../../utils/streams.dart';
import '../../utils/type_defs.dart';
import '../../utils/validators.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends DisposeCallbackBaseBloc {
  /// Input functions
  final Function1<String, void> emailChanged;
  final Function0<void> submit;

  /// Streams
  final Stream<String> emailError$;
  final Stream<Message> message$;
  final Stream<bool> isLoading$;

  ResetPasswordBloc._({
    @required Function0<void> dispose,
    @required this.emailChanged,
    @required this.submit,
    @required this.emailError$,
    @required this.message$,
    @required this.isLoading$,
  }) : super(dispose);

  factory ResetPasswordBloc(final UserRepository userRepository) {
    assert(userRepository != null);

    /// Controllers
    final emailController = PublishSubject<String>();
    final submitController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);
    final controllers = [
      emailController,
      submitController,
      isLoadingController,
    ];

    ///
    /// Streams
    ///

    final submit$ = submitController.stream
        .withLatestFrom(
          emailController.stream.map(Validator.isValidEmail).startWith(false),
          (_, bool isValid) => isValid,
        )
        .share();

    final message$ = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(emailController, (_, String email) => email)
          .exhaustMap(
            (email) => Rx.defer(() async* {
              await userRepository.resetPassword(email);
              yield email;
            })
                .doOnListen(() => isLoadingController.add(true))
                .doOnData((_) => isLoadingController.add(false))
                .doOnError((e, s) => isLoadingController.add(false))
                .map<Message>((email) => SuccessMessage(email))
                .onErrorReturnWith(
                  (error) => ErrorMessage(
                    'Reset password error: ${getErrorMessage(error)}',
                    error,
                  ),
                ),
          ),
      submit$
          .where((isValid) => !isValid)
          .map((_) => const InvalidInformationMessage())
    ]).share();

    final emailError$ = emailController.stream
        .map((email) {
          if (Validator.isValidEmail(email)) return null;
          return 'Invalid email address';
        })
        .distinct()
        .share();

    final subscriptions = <String, Stream>{
      'emailError': emailError$,
      'isValidSubmit':
          emailController.stream.map(Validator.isValidEmail).startWith(false),
      'message': message$,
      'isLoading': isLoadingController,
    }.debug();

    return ResetPasswordBloc._(
      dispose: DisposeBag([...controllers, ...subscriptions]).dispose,
      emailChanged: trim.pipe(emailController.add),
      submit: () => submitController.add(null),
      emailError$: emailError$,
      message$: message$,
      isLoading$: isLoadingController,
    );
  }
}
