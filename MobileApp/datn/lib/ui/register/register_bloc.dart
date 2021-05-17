// ignore_for_file: close_sinks

import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repository/user_repository.dart';
import '../../generated/l10n.dart';
import '../../utils/error.dart';
import '../../utils/utils.dart';
import 'register_state.dart';

class RegisterBloc extends DisposeCallbackBaseBloc {
  /// Input functions
  final Function1<String, void> emailChanged;
  final Function1<String, void> passwordChanged;
  final Function0<void> submit;

  /// Streams
  final Stream<String?> emailError$;
  final Stream<String?> passwordError$;
  final Stream<RegisterMessage> message$;
  final Stream<bool> isLoading$;

  RegisterBloc._({
    required VoidAction dispose,
    required this.emailChanged,
    required this.passwordChanged,
    required this.submit,
    required this.emailError$,
    required this.passwordError$,
    required this.message$,
    required this.isLoading$,
  }) : super(dispose);

  factory RegisterBloc(final UserRepository userRepository) {
    /// Controllers
    final emailController = PublishSubject<String>();
    final passwordController = PublishSubject<String>();
    final submitController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);
    final controllers = [
      emailController,
      passwordController,
      submitController,
      isLoadingController,
    ];

    ///
    /// Streams
    ///
    final isValidSubmit$ = Rx.combineLatest3(
      emailController.stream.map(Validator.isValidEmail),
      passwordController.stream.map(Validator.isValidPassword),
      isLoadingController.stream,
      (bool isValidEmail, bool isValidPassword, bool isLoading) =>
          isValidEmail && isValidPassword && !isLoading,
    ).shareValueSeeded(false);

    final credential$ = Rx.combineLatest2(
      emailController.stream,
      passwordController.stream,
      (String email, String password) =>
          Credential(email: email, password: password),
    );

    final submit$ = submitController.stream
        .withLatestFrom(isValidSubmit$, (_, bool isValid) => isValid)
        .share();

    final message$ = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(credential$, (_, Credential c) => c)
          .exhaustMap(
            (credential) => Rx.defer(() async* {
              await userRepository.register(
                credential.email,
                credential.password,
              );
              yield credential.email;
            })
                .doOnListen(() => isLoadingController.add(true))
                .doOnData((_) => isLoadingController.add(false))
                .doOnError((e, s) => isLoadingController.add(false))
                .map<RegisterMessage>((email) => RegisterSuccessMessage(email))
                .onErrorReturnWith(
                  (error, s) => RegisterErrorMessage(
                    S.current.registerError(
                      getErrorMessageDeprecated(error),
                    ),
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
          return S.current.invalidEmailAddress;
        })
        .distinct()
        .share();

    final passwordError$ = passwordController.stream
        .map((password) {
          if (Validator.isValidPassword(password)) return null;
          return S.current.passwordMustBeAtLeast6Characters;
        })
        .distinct()
        .share();

    final subscriptions = <String, Stream>{
      'emailError': emailError$,
      'passwordError': passwordError$,
      'isValidSubmit': isValidSubmit$,
      'message': message$,
      'isLoading': isLoadingController,
    }.debug();

    return RegisterBloc._(
      dispose: DisposeBag([...controllers, ...subscriptions]).dispose,
      emailChanged: trim.pipe(emailController.add),
      passwordChanged: passwordController.add,
      submit: () => submitController.add(null),
      emailError$: emailError$,
      passwordError$: passwordError$,
      message$: message$,
      isLoading$: isLoadingController,
    );
  }
}
