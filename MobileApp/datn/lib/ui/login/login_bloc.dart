// ignore_for_file: close_sinks

import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repository/user_repository.dart';
import '../../generated/l10n.dart';
import '../../utils/utils.dart';
import 'login_state.dart';

/// BLoC that handles validating form and login
class LoginBloc extends DisposeCallbackBaseBloc {
  /// Input functions
  final Function1<String, void> emailChanged;
  final Function1<String, void> passwordChanged;
  final VoidAction submitLogin;

  /// Streams
  final Stream<String?> emailError$;
  final Stream<String?> passwordError$;
  final Stream<LoginMessage> message$;
  final Stream<bool> isLoading$;

  LoginBloc._({
    required VoidAction dispose,
    required this.emailChanged,
    required this.passwordChanged,
    required this.submitLogin,
    required this.emailError$,
    required this.passwordError$,
    required this.message$,
    required this.isLoading$,
  }) : super(dispose);

  factory LoginBloc(final UserRepository userRepository) {
    /// Controllers
    final emailController = PublishSubject<String>();
    final passwordController = PublishSubject<String>();
    final submitLoginController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);
    final controllers = [
      emailController,
      passwordController,
      submitLoginController,
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

    final submit$ = submitLoginController.stream
        .withLatestFrom(isValidSubmit$, (_, bool isValid) => isValid)
        .share();

    final message$ = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(credential$, (_, Credential c) => c)
          .exhaustMap(
            (credential) => Rx.defer(() async* {
              await userRepository.login(credential.email, credential.password);
              yield null;
            })
                .doOnListen(() => isLoadingController.add(true))
                .doOnData((_) => isLoadingController.add(false))
                .doOnError((e, s) => isLoadingController.add(false))
                .map<LoginMessage>((_) => const LoginSuccessMessage())
                .onErrorReturnWith(
                  (error, s) => LoginErrorMessage(
                    S.current.loginErrorGeterrormessagedeprecatederror(
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

    return LoginBloc._(
      dispose: DisposeBag([...controllers, ...subscriptions]).dispose,
      emailChanged: trim.pipe(emailController.add),
      passwordChanged: passwordController.add,
      submitLogin: () => submitLoginController.add(null),
      emailError$: emailError$,
      passwordError$: passwordError$,
      message$: message$,
      isLoading$: isLoadingController,
    );
  }
}
