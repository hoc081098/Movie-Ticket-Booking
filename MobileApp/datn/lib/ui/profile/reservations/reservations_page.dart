import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rx_redux/rx_redux.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/repository/reservation_repository.dart';
import '../../../generated/l10n.dart';
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
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');
  final dateFormat = DateFormat('hh:mm a, dd/MM/yy');

  RxReduxStore<ReservationsAction, ReservationsState>? store;
  final scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    store ??= () {
      final s = createStore(
          Provider.of<ReservationRepository>(context).getReservation);
      subscribe(s);
      s.dispatch(const LoadFirstPageAction());

      scrollController
          .nearBottomEdge$()
          .mapTo<ReservationsAction>(const LoadNextPageAction())
          .dispatchTo(s);

      return s;
    }();
  }

  @override
  void dispose() {
    super.dispose();
    store!.dispose();
    store = null;
    scrollController.dispose();
  }

  void subscribe(RxReduxStore<ReservationsAction, ReservationsState> store) {
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
        if (action.reservations.isEmpty) {
          context.showSnackBar(S.of(context).loadedAllReservations);
        }
      }
    }).disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final store = this.store!;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).yourReservations),
      ),
      body: RxStreamBuilder<ReservationsState>(
        stream: store.stateStream,
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
                errorText: S
                    .of(context)
                    .error_with_message(getErrorMessage(state.error!)),
                onPressed: () => store.dispatch(const RetryAction()),
              ),
            );
          }

          if (state.items.isEmpty) {
            return Center(
              child: EmptyWidget(
                message: S.of(context).emptyReservation,
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
              controller: scrollController,
              itemCount: items.length + (state.isFirstPage ? 0 : 1),
              itemBuilder: (context, index) {
                if (index < items.length) {
                  return ReservationListItem(
                    item: items[index],
                    dateFormat: dateFormat,
                    currencyFormat: currencyFormat,
                  );
                }

                if (state.error != null) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: MyErrorWidget(
                      errorText: S
                          .of(context)
                          .error_with_message(getErrorMessage(state.error!)),
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
}
