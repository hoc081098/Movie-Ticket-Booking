import 'package:flutter/material.dart' hide Notification, Action;
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rx_redux/rx_redux.dart';
import 'package:rxdart/rxdart.dart' hide Notification;

import '../../domain/model/notification.dart';
import '../../domain/repository/notification_repository.dart';
import '../../fcm_notification.dart';
import '../../utils/error.dart';
import '../../utils/utils.dart';
import '../app_scaffold.dart';
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

  RxReduxStore<Action, st.State> store;
  final listController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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

      AppScaffold.tapStream(context)
          .where((event) => event == 2)
          .take(1)
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
    store.dispose();
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
          'Error occurred: ${getErrorMessage(action.error)}',
        );
      }
      if (action is SuccessAction) {
        if (action.notifications.isEmpty) {
          context.showSnackBar('Loaded all notifications');
        }
      }
    }).disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<st.State>(
        stream: store.stateStream,
        initialData: store.state,
        builder: (context, snapshot) {
          final state = snapshot.data;

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
                errorText: 'Error: ${getErrorMessage(state.error)}',
                onPressed: () => store.dispatch(const RetryAction()),
              ),
            );
          }

          if (state.items.isEmpty) {
            return Center(
              child: EmptyWidget(
                message: 'Empty notification',
              ),
            );
          }

          final items = state.items;

          return RefreshIndicator(
            onRefresh: () {
              final action = RefreshAction();
              store.dispatch(action);
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
                  );
                }

                if (state.error != null) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: MyErrorWidget(
                      errorText:
                          'Load page ${state.page}, error: ${getErrorMessage(state.error)}',
                      onPressed: () => store.dispatch(const RetryAction()),
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
          title: Text('Delete notification'),
          content: Text('Are you sure you want to delete this notification?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(true),
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
      context.showSnackBar('Delete successfully');

      store?.dispatch(RemovedNotificationAction(item));
    } catch (e, s) {
      print(e);
      print(s);
      context.showSnackBar('Error: ${getErrorMessage(e)}');
    }
  }
}
