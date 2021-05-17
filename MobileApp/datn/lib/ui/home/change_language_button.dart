import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';
import '../../locale_bloc.dart';
import '../../utils/utils.dart';

final supportedLocaleTitles = <Locale, String>{
  const Locale('en', ''): 'English - en',
  const Locale('vi', ''): 'Tiếng Việt - vi',
};

class ChangeLanguageButton extends StatefulWidget {
  final Color? iconColor;

  const ChangeLanguageButton({Key? key, required this.iconColor})
      : super(key: key);

  @override
  _ChangeLanguageButtonState createState() => _ChangeLanguageButtonState();
}

class _ChangeLanguageButtonState extends State<ChangeLanguageButton>
    with DisposeBagMixin {
  Object? token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    token ??= () {
      final localeBloc = BlocProvider.of<LocaleBloc>(context);

      return localeBloc.message$.listen((msg) {
        if (msg is ChangeLocaleSuccess) {
          return context.showSnackBar(
            Intl.message(
              'Change language successfully',
              name: 'change_language_success',
              desc: '',
              args: [],
              locale: msg.locale.toString(),
            ),
          );
        }
        if (msg is ChangeLocaleFailure) {
          if (msg.error == null) {
            context.showSnackBar(S.of(context).change_language_failure);
          } else {
            context
                .showSnackBar(S.of(context).change_language_error(msg.error));
          }
          return;
        }
        throw msg;
      }).disposedBy(bag);
    }();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.language,
        color: widget.iconColor,
      ),
      onPressed: press,
    );
  }

  void press() async {
    final localeBloc = BlocProvider.of<LocaleBloc>(context);
    final selectedLocale = localeBloc.locale$.value;

    final newLocale = await showDialog<Locale>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).change_language),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (final locale in S.delegate.supportedLocales)
                  ListTile(
                    title: Text(supportedLocaleTitles[locale]!),
                    onTap: () => Navigator.pop<Locale>(dialogContext, locale),
                    trailing: selectedLocale == locale
                        ? Icon(Icons.check_circle)
                        : null,
                    isThreeLine: false,
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (newLocale != null) {
      localeBloc.changeLocale(newLocale);
    }
  }
}
