import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rx_redux/rx_redux.dart';

import '../../../domain/repository/reservation_repository.dart';
import '../../../utils/utils.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/error_widget.dart';
import 'list_item.dart';
import 'reservations_state.dart';
import 'store.dart';

class ReservationsPage extends StatefulWidget {
  static const routeName = '/profile/reservations';

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage>
    with DisposeBagMixin {
  final dateFormat = DateFormat('hh:mm a, dd/MM/yy');

  RxReduxStore<ReservationsAction, ReservationsState> store;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    store ??= () {
      final s = createStore(
          Provider.of<ReservationRepository>(context).getReservation);
      subscribe(s);
      s.dispatch(const LoadFirstPageAction());
      return s;
    }();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  void subscribe(RxReduxStore<ReservationsAction, ReservationsState> store) {
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
        if (action.reservations.isEmpty) {
          scaffoldKey.showSnackBar('Loaded all reservations');
        }
      }
    }).disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Your reservations'),
      ),
      body: StreamBuilder<ReservationsState>(
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
                message: 'Empty reservation',
              ),
            );
          }

          final items = state.items;

          return RefreshIndicator(
            onRefresh: () {
              final completer = Completer<void>();
              store.dispatch(RefreshAction(completer));
              return completer.future;
            },
            child: ListView.builder(
              itemCount: items.length + (state.isFirstPage ? 0 : 1),
              itemBuilder: (context, index) {
                if (index < items.length) {
                  return ReservationListItem(
                    item: items[index],
                    dateFormat: dateFormat,
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
                  padding: const EdgeInsets.only(
                    bottom: 12,
                    top: 12,
                  ),
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
            ),
          );
        },
      ),
    );
  }
}
