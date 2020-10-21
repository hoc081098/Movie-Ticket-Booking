import 'package:flutter/material.dart' hide Notification, Action;
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rx_redux/rx_redux.dart';

import '../../domain/repository/notification_repository.dart';
import '../../utils/error.dart';
import '../../utils/utils.dart';
import '../app_scaffold.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import 'action.dart';
import 'state.dart' as st;
import 'store.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with DisposeBagMixin {
  RxReduxStore<Action, st.State> store;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    store ??= () {
      final s = createStore(
          Provider.of<NotificationRepository>(context).getNotification);

      subscribe(s);

      AppScaffold.tapStream(context)
          .where((event) => event == 2)
          .take(1)
          .listen((_) => s.dispatch(const LoadFirstPageAction()));

      return s;
    }();
  }

  void subscribe(RxReduxStore<Action, st.State> store) {
    store.stateStream
        .listen((state) => print('Page: ${state.page}'))
        .disposedBy(bag);

    store.actionStream.listen((action) {
      if (action is FailureAction) {
        scaffoldKey.showSnackBar(
          'Error occurred: ${getErrorMessage(action.error)}',
        );
      }
      if (action is SuccessAction) {
        if (action.notifications.isEmpty) {
          scaffoldKey.showSnackBar('Loaded all notifications');
        }
      }
    }).disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                message: 'Empty comments',
              ),
            );
          }

          final items = state.items;

          return ListView.separated(
            itemCount: items.length + (state.isFirstPage ? 0 : 1),
            itemBuilder: (context, index) {
              if (index < items.length) {
                final item = items[index];

                return ListTile(
                  title: Text(item.reservation.showTime.movie.title),
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

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Center(
                  child: SizedBox(
                    width: 128,
                    height: 48,
                    child: RaisedButton(
                      onPressed: () =>
                          store.dispatch(const LoadNextPageAction()),
                      child: Text('Next page'),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        },
      ),
    );
  }
}
