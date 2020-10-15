import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../../../domain/model/promotion.dart';
import '../../../../domain/repository/promotion_repository.dart';
import '../../../../utils/error.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';

class DiscountsPage extends StatelessWidget {
  static const routeName = 'home/detail/tickets/combo/checkout/discounts';
  final String showTimeId;

  DiscountsPage({Key key, @required this.showTimeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loaderFunction = () =>
        Provider.of<PromotionRepository>(context).getPromotions(showTimeId);

    return LoaderWidget<BuiltList<Promotion>>(
      blocProvider: () => LoaderBloc(
        loaderFunction: loaderFunction,
        refresherFunction: loaderFunction,
        initialContent: const <Promotion>[].build(),
        enableLogger: true,
      ),
      builder: (context, state, bloc) {
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

        if (state.error != null) {
          return Center(
            child: MyErrorWidget(
              errorText: 'Error: ${getErrorMessage(state.error)}',
              onPressed: bloc.fetch,
            ),
          );
        }

        final promotions = state.content;
        if (promotions.isEmpty) {
          return Center(
            child: EmptyWidget(
              message: 'Empty promotions',
            ),
          );
        }

        return GridView.builder(
          itemCount: promotions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            return Container(
              color: Colors.redAccent,
            );
          },
        );
      },
    );
  }
}
