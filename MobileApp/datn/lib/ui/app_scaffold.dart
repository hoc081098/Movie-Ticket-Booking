import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

typedef AppScaffoldWidgetBuilder = Widget Function(BuildContext, RouteSettings);

enum AppScaffoldIndex {
  home,
  favorites,
  notifications,
  profile,
}

@pragma('vm:prefer-inline')
@pragma('dart2js:tryInline')
AppScaffoldIndex _fromRawValue(int rawValue) {
  switch (rawValue) {
    case 0:
      return AppScaffoldIndex.home;
    case 1:
      return AppScaffoldIndex.favorites;
    case 2:
      return AppScaffoldIndex.notifications;
    case 3:
      return AppScaffoldIndex.profile;
  }
  throw StateError('Missing case $rawValue');
}

extension on AppScaffoldIndex {
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int get rawValue {
    switch (this) {
      case AppScaffoldIndex.home:
        return 0;
      case AppScaffoldIndex.favorites:
        return 1;
      case AppScaffoldIndex.notifications:
        return 2;
      case AppScaffoldIndex.profile:
        return 3;
    }
  }
}

class AppScaffold extends StatefulWidget {
  final List<BottomNavigationBarItem> items;
  final List<AppScaffoldWidgetBuilder> builders;

  const AppScaffold({
    Key? key,
    required this.items,
    required this.builders,
  }) : super(key: key);

  @override
  _AppScaffoldState createState() => _AppScaffoldState();

  static NavigatorState navigatorOfCurrentIndex(
    BuildContext context, {
    AppScaffoldIndex? switchToNewIndex,
  }) {
    final appScaffoldState =
        context is StatefulElement && context.state is _AppScaffoldState
            ? context.state as _AppScaffoldState
            : context.findAncestorStateOfType<_AppScaffoldState>()!;

    final currentIndex = appScaffoldState.currentIndex;
    final navigatorKeys = appScaffoldState.navigatorKeys;
    final newIndex = switchToNewIndex?.rawValue;

    if (newIndex != null &&
        newIndex != currentIndex &&
        appScaffoldState.mounted) {
      appScaffoldState.onTap(newIndex);
      return navigatorKeys[newIndex].currentState!;
    }

    return navigatorKeys[currentIndex].currentState!;
  }

  static NotReplayValueStream<AppScaffoldIndex> currentIndexStream(
          BuildContext context) =>
      context.findAncestorStateOfType<_AppScaffoldState>()!.indexS;

  static NavigatorState navigatorByIndex(
    BuildContext context,
    AppScaffoldIndex index,
  ) {
    final appScaffoldState =
        context.findAncestorStateOfType<_AppScaffoldState>()!;
    return appScaffoldState.navigatorKeys[index.rawValue].currentState!;
  }
}

class _AppScaffoldState extends State<AppScaffold> with DisposeBagMixin {
  var navigatorKeys = <GlobalKey<NavigatorState>>[];
  final indexS = ValueSubject(AppScaffoldIndex.home, sync: true);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  int get currentIndex => indexS.value.rawValue;

  @override
  void initState() {
    super.initState();

    navigatorKeys = List.generate(
      widget.builders.length,
      (_) => GlobalKey<NavigatorState>(),
    );
    indexS.disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        final navigatorState = navigatorKeys[currentIndex].currentState!;
        final canPop = navigatorState.canPop();

        if (canPop) {
          navigatorState.maybePop();
        }

        if (!canPop && currentIndex > 0) {
          onTap(0);
          return Future.value(false);
        }

        return Future.value(!canPop);
      },
      child: RxStreamBuilder<AppScaffoldIndex>(
        stream: indexS,
        builder: (context, snapshot) {
          final index = snapshot.rawValue;

          return Scaffold(
            body: buildBody(index),
            bottomNavigationBar: BottomNavigationBar(
              items: widget.items,
              type: BottomNavigationBarType.fixed,
              currentIndex: index,
              onTap: onTap,
            ),
          );
        },
      ),
    );
  }

  void onTap(final int newIndex) {
    if (currentIndex == newIndex) {
      navigatorKeys[currentIndex]
          .currentState
          ?.popUntil((route) => route.isFirst);
    } else {
      indexS.add(_fromRawValue(newIndex));
    }
  }

  Widget buildBody(int index) {
    return IndexedStack(
      index: index,
      children: [
        for (int i = 0; i < widget.builders.length; i++)
          Navigator(
            key: navigatorKeys[i],
            onGenerateRoute: (settings) => MaterialPageRoute(
              settings: settings,
              builder: (context) => widget.builders[i](context, settings),
            ),
            observers: [
              HeroController(),
            ],
          )
      ],
    );
  }
}

extension NavigatorStateX on NavigatorState {
  @optionalTypeArgs
  Future<T?> pushNamedX<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    _removeCurrentSnackBar();
    return pushNamed(routeName, arguments: arguments);
  }

  @optionalTypeArgs
  Future<T?> pushNamedAndRemoveUntilX<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    _removeCurrentSnackBar();
    return pushNamedAndRemoveUntil(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  void popUntilX(RoutePredicate predicate) {
    _removeCurrentSnackBar();
    popUntil(predicate);
  }

  void _removeCurrentSnackBar() {
    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    } catch (_) {}
  }
}
