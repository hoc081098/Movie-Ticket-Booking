import 'dart:async';

import 'package:flutter/material.dart' hide Notification, Action;
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rx_redux/rx_redux.dart';
import 'package:rxdart/rxdart.dart' hide Notification;
import 'package:rxdart_ext/rxdart_ext.dart' hide Notification;

import '../../domain/model/notification.dart';
import '../../domain/model/reservation.dart';
import '../../domain/repository/notification_repository.dart';
import '../../domain/repository/reservation_repository.dart';
import '../../fcm_notification.dart';
import '../../generated/l10n.dart';
import '../../utils/error.dart';
import '../../utils/utils.dart';
import '../app_scaffold.dart';
import '../profile/reservation_detail/reservation_detail_page.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import 'action.dart';
import 'state.dart' as st;
import 'store.dart';
import 'widgets.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with DisposeBagMixin {
  final dateFormat = DateFormat('hh:mm a, dd/MM/yy');

  RxReduxStore<Action, st.State>? store;
  final listController = ScrollController();

  final onTapItemS = StreamController<Reservation>(sync: true);
  Object? setupOnTapItem;

  @override
  void initState() {
    super.initState();
    onTapItemS.disposedBy(bag);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setupOnTapItem ??= onTapItemS.stream
        .exhaustMap(
          (r) => context
              .get<ReservationRepository>()
              .getReservationById(r.id)
              .doOnListen(() => context.showLoading(s.loading))
              .doOnCancel(
                  () => Navigator.of(context, rootNavigator: true).pop())
              .doOnError((e, s) => context.showSnackBar(
                  S.of(context).error_with_message(getErrorMessage(e)))),
        )
        .doOnData(
          (r) => AppScaffold.navigatorOfCurrentIndex(context,
                  switchToNewIndex: AppScaffoldIndex.profile)
              .pushNamedX(
            ReservationDetailPage.routeName,
            arguments: r,
          ),
        )
        .collect()
        .disposedBy(bag);

    store ??= () {
      final s = createStore(
          Provider.of<NotificationRepository>(context).getNotification);
      final notificationManager = Provider.of<FcmNotificationManager>(context);

      subscribe(s);

      void onNewNotification(AddedNotificationAction action) {
        s.dispatch(action);

        if (listController.hasClients) {
          listController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        }
      }

      AppScaffold.currentIndexStream(context)
          .where((event) => event == AppScaffoldIndex.notifications)
          .take(1)
          .debug(identifier: '>>> NOTIFICATIONS', log: streamDebugPrint)
          .doOnData((event) => s.dispatch(const LoadFirstPageAction()))
          .exhaustMap((_) => notificationManager.notification$)
          .map((event) => AddedNotificationAction(event))
          .listen(onNewNotification)
          .disposedBy(bag);

      listController
          .nearBottomEdge$()
          .mapTo<Action>(const LoadNextPageAction())
          .dispatchTo(s);

      return s;
    }();
  }

  @override
  void dispose() {
    super.dispose();
    store!.dispose();
    store = null;
    listController.dispose();
  }

  void subscribe(RxReduxStore<Action, st.State> store) {
    store.stateStream
        .listen((state) => print('Page: ${state.page}'))
        .disposedBy(bag);

    store.actionStream.listen((action) {
      if (action is FailureAction) {
        context.showSnackBar(
          S.of(context).error_with_message(getErrorMessage(action.error)),
        );
      }
      if (action is SuccessAction) {
        if (action.notifications.isEmpty) {
          context.showSnackBar(S.of(context).loadedAllNotifications);
        }
      }
    }).disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).notifications),
      ),
      body: RxStreamBuilder<st.State>(
        stream: store!.stateStream,
        builder: (context, state) {
          if (state.isLoading && state.isFirstPage) {
            return Center(
              child: SizedBox(
                width: 56,
                height: 56,
                child: LoadingIndicator(
                  color: Theme.of(context).accentColor,
                  indicatorType: Indicator.ballScaleMultiple,
                ),
              ),
            );
          }

          if (state.error != null && state.isFirstPage) {
            return Center(
              child: MyErrorWidget(
                errorText:
                    context.s.error_with_message(getErrorMessage(state.error!)),
                onPressed: () => store!.dispatch(const RetryAction()),
              ),
            );
          }

          if (state.items.isEmpty) {
            return Center(
              child: EmptyWidget(
                message: S.of(context).emptyNotification,
              ),
            );
          }

          final items = state.items;

          return RefreshIndicator(
            onRefresh: () {
              final action = RefreshAction();
              store!.dispatch(action);
              return action.onDone;
            },
            child: ListView.builder(
              controller: listController,
              itemCount: items.length + (state.isFirstPage ? 0 : 1),
              itemBuilder: (context, index) {
                if (index < items.length) {
                  return NotificationItemWidget(
                    items[index],
                    dateFormat,
                    onDelete,
                    onTapItemS.add,
                  );
                }

                if (state.error != null) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: MyErrorWidget(
                      errorText: context.s
                          .error_with_message(getErrorMessage(state.error!)),
                      onPressed: () => store!.dispatch(const RetryAction()),
                    ),
                  );
                }

                if (state.isLoading) {
                  return Center(
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: LoadingIndicator(
                        color: Theme.of(context).accentColor,
                        indicatorType: Indicator.ballScaleMultiple,
                      ),
                    ),
                  );
                }

                if (state.loadedAll) {
                  return const SizedBox(width: 0, height: 0);
                }
                return const SizedBox(width: 0, height: 56);
              },
            ),
          );
        },
      ),
    );
  }

  void onDelete(Notification item) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).deleteNotification),
          content:
              Text(S.of(context).areYouSureYouWantToDeleteThisNotification),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (!identical(ok, true)) {
      return;
    }

    try {
      await Provider.of<NotificationRepository>(context)
          .deleteNotificationById(item.id);
      context.showSnackBar(S.of(context).deleteSuccessfully);

      store?.dispatch(RemovedNotificationAction(item));
    } catch (e, s) {
      print(e);
      print(s);
      context
          .showSnackBar(S.of(context).error_with_message(getErrorMessage(e)));
    }
  }
}
