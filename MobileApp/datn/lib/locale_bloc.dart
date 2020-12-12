import 'dart:async';
import 'dart:ui';

import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

import 'generated/l10n.dart';

///
/// Change theme message
///
abstract class ChangeLocaleMessage {}

class ChangeLocaleSuccess implements ChangeLocaleMessage {
  const ChangeLocaleSuccess();
}

class ChangeLocaleFailure implements ChangeLocaleMessage {
  /// Nullable
  final error;

  const ChangeLocaleFailure([this.error]);
}

class LocaleBloc extends DisposeCallbackBaseBloc {
  static const _localeKey = 'com.hoc.datn.locale';

  /// Input
  final void Function(Locale) changeLocale;

  /// Output
  final DistinctValueStream<Locale> locale$;
  final Stream<ChangeLocaleMessage> message$;

  LocaleBloc._({
    @required this.changeLocale,
    @required this.locale$,
    @required this.message$,
    @required void Function() dispose,
  }) : super(dispose);

  factory LocaleBloc(
    RxSharedPreferences rxSharedPrefs,
  ) {
    // ignore_for_file: close_sinks
    final changeLocaleS = StreamController<Locale>(sync: true);

    final locale$ = rxSharedPrefs
        .getStringStream(_localeKey)
        .map(
          (code) => S.delegate.supportedLocales.firstWhere(
            (element) => element.languageCode == code,
            orElse: () => S.delegate.supportedLocales[0],
          ),
        )
        .publishValueDistinct(null, sync: true);

    final message$ = changeLocaleS.stream
        .distinct()
        .switchMap((l) => _changeLocale(l, rxSharedPrefs))
        .publish();

    return LocaleBloc._(
      dispose: DisposeBag([
        locale$.connect(),
        message$.connect(),
        changeLocaleS,
      ]).dispose,
      changeLocale: changeLocaleS.add,
      message$: message$,
      locale$: locale$,
    );
  }

  static Stream<ChangeLocaleMessage> _changeLocale(
    Locale locale,
    RxSharedPreferences rxSharedPrefs,
  ) {
    return Rx.fromCallable(
            () => rxSharedPrefs.setString(_localeKey, locale.languageCode))
        .map((result) =>
            result ? const ChangeLocaleSuccess() : const ChangeLocaleFailure())
        .onErrorReturnWith((e) => ChangeLocaleFailure(e));
  }
}
