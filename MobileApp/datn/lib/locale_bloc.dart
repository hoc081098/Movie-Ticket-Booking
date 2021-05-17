import 'dart:async';
import 'dart:ui';

import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'generated/l10n.dart';

///
/// Change theme message
///
abstract class ChangeLocaleMessage {}

class ChangeLocaleSuccess implements ChangeLocaleMessage {
  final Locale locale;

  const ChangeLocaleSuccess(this.locale);
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

  // final Future<void> Function(Locale) resetLocale;

  /// Output
  final DistinctValueStream<Locale?> locale$;
  final Stream<ChangeLocaleMessage> message$;

  LocaleBloc._({
    required this.changeLocale,
    // required this.resetLocale,
    required this.locale$,
    required this.message$,
    required VoidAction dispose,
  }) : super(dispose);

  factory LocaleBloc(
    RxSharedPreferences rxSharedPrefs,
  ) {
    // ignore_for_file: close_sinks
    final changeLocaleS = StreamController<Locale>(sync: true);
    // final resetS =
    //     StreamController<Tuple2<Locale, Completer<void>>>(sync: true);

    final locale$ = rxSharedPrefs
        .getStringStream(_localeKey)
        .map<Locale?>(
          (code) => S.delegate.supportedLocales.firstWhere(
            (element) => element.languageCode == code,
            orElse: () => S.delegate.supportedLocales[0],
          ),
        )
        .publishValueDistinct(null, sync: true);

    final message$ = changeLocaleS.stream
        .where((locale) {
          final current = locale$.value;
          // not loaded yet -> change
          // or difference  -> change
          return current == null || locale != current;
        })
        .switchMap((l) => _changeLocale(Tuple2(l, null), rxSharedPrefs))
        .publish();

    final bloc = LocaleBloc._(
      dispose: DisposeBag([
        // resetS.stream
        //     .exhaustMap((tuple) => _changeLocale(tuple, rxSharedPrefs))
        //     .listen(null),
        locale$.connect(),
        message$.connect(),
        changeLocaleS,
      ]).dispose,
      changeLocale: changeLocaleS.add,
      message$: message$,
      locale$: locale$,
      // resetLocale: (locale) {
      //   final completer = Completer<void>();
      //   resetS.add(Tuple2(locale, completer));
      //   return completer.future;
      // },
    );
    print('CREATE LOCALE BLOC ${identityHashCode(bloc)}');
    return bloc;
  }

  static Stream<ChangeLocaleMessage> _changeLocale(
    Tuple2<Locale, Completer<void>?> tuple,
    RxSharedPreferences rxSharedPrefs,
  ) {
    final locale = tuple.item1;
    final completer = tuple.item2;

    return Rx.fromCallable(
            () => rxSharedPrefs.setString(_localeKey, locale.languageCode))
        .mapTo<ChangeLocaleMessage>(ChangeLocaleSuccess(locale))
        .onErrorReturnWith((e, s) => ChangeLocaleFailure(e))
        .doOnCancel(() => completer?.complete());
  }
}
