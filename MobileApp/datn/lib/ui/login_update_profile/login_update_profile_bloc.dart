import 'package:datn/domain/repository/user_repository.dart';
import 'package:datn/utils/type_defs.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class LoginUpdateProfilePageBloc extends DisposeCallbackBaseBloc {
  final Function0 submit;
  final Function1<String, void> fullNameChanged;
  final Function1<String, void> phoneNumberChanged;
  final Function1<String, void> addressChanged;

  final Stream<String> fullNameError$;
  final Stream<String> phoneNumberError$;
  final Stream<String> addressError$;

  LoginUpdateProfilePageBloc._({
    @required void Function() dispose,
    @required this.submit,
    @required this.fullNameError$,
    @required this.fullNameChanged,
    @required this.phoneNumberChanged,
    @required this.phoneNumberError$,
    @required this.addressChanged,
    @required this.addressError$,
  }) : super(dispose);

  factory LoginUpdateProfilePageBloc(UserRepository userRepository) {
    return LoginUpdateProfilePageBloc._(
      dispose: DisposeBag([]).dispose,
      submit: () {},
      fullNameError$: Rx.defer(() => Stream.value(null)),
      fullNameChanged: (v) {},
      phoneNumberChanged: (v) {},
      phoneNumberError$: Rx.defer(() => Stream.value(null)),
      addressChanged: (String) {},
      addressError$: Rx.defer(() => Stream.value(null)),
    );
  }
}
