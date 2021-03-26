import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stream_loader/stream_loader.dart';

import '../../../../domain/model/promotion.dart';
import '../../../../domain/repository/promotion_repository.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/error.dart';
import '../../../app_scaffold.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../tickets/ticket_page.dart';

class DiscountsPage extends StatelessWidget {
  static const routeName = 'home/detail/tickets/combo/checkout/discounts';
  final String showTimeId;

  DiscountsPage({Key? key, required this.showTimeId}) : super(key: key);

  final gradients = <LinearGradient>[
    const LinearGradient(
      colors: [
        Color(0xffDA63C8),
        Color(0xff4537D5),
      ],
      begin: AlignmentDirectional.topEnd,
      end: AlignmentDirectional.bottomStart,
    ),
    const LinearGradient(
      colors: [
        Color(0xff55DFDD),
        Color(0xff03C6B6),
      ],
      begin: AlignmentDirectional.topEnd,
      end: AlignmentDirectional.bottomStart,
    ),
    const LinearGradient(
      colors: [
        Color(0xffFFA76A),
        Color(0xffFF599F),
      ],
      begin: AlignmentDirectional.topEnd,
      end: AlignmentDirectional.bottomStart,
    ),
    const LinearGradient(
      colors: [
        Color(0xff5ED2FD),
        Color(0xff079CD2),
      ],
      begin: AlignmentDirectional.topEnd,
      end: AlignmentDirectional.bottomStart,
    ),
    const LinearGradient(
      colors: [
        Color(0xffFED66F),
        Color(0xffFE8805),
      ],
      begin: AlignmentDirectional.topEnd,
      end: AlignmentDirectional.bottomStart,
    ),
    const LinearGradient(
      colors: [
        Color(0xffC89DC5),
        Color(0xff4B68AE),
      ],
      begin: AlignmentDirectional.topEnd,
      end: AlignmentDirectional.bottomStart,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final loaderFunction = () =>
        Provider.of<PromotionRepository>(context).getPromotions(showTimeId);
    final countDownStyle = Theme.of(context)
        .textTheme
        .subtitle2!
        .copyWith(color: Colors.white, fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).couponCode.replaceAll(': ', '')),
        actions: [
          Center(
            child: RxStreamBuilder<String?>(
              stream:
                  TicketsCountDownTimerBlocProvider.shared().bloc.countDown$,
              builder: (context, data) {
                return data != null
                    ? Text(data, style: countDownStyle)
                    : const SizedBox();
              },
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: LoaderWidget<BuiltList<Promotion>>(
        blocProvider: () => LoaderBloc(
          loaderFunction: loaderFunction,
          refresherFunction: loaderFunction,
          initialContent: const <Promotion>[].build(),
          logger: print,
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
                errorText: S
                    .of(context)
                    .error_with_message(context.getErrorMessage(state.error!)),
                onPressed: bloc.fetch,
              ),
            );
          }

          final promotions = state.content!;
          if (promotions.isEmpty) {
            return Center(
              child: EmptyWidget(
                message: S.of(context).emptyCouponCode,
              ),
            );
          }

          const aspectRatio = 1.0;
          final dateFormat = DateFormat('hh:mm a, dd/MM/yy');
          final nameStyle = Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Colors.white, fontSize: 13);
          final timeStyle = nameStyle.copyWith(
            fontSize: 11,
            fontStyle: FontStyle.italic,
          );

          return GridView.builder(
            itemCount: promotions.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: aspectRatio,
            ),
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final promotion = promotions[index];

              return InkWell(
                onTap: () => tap(promotion, context),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: gradients[index % gradients.length],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(2, 4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Text(
                            promotion.name,
                            maxLines: 3,
                            style: nameStyle,
                          ),
                        ),
                        Center(
                          child: Text(
                            '${(promotion.discount * 100).toInt()}% ${S.of(context).OFF}',
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: Colors.white,
                                      fontSize: 28,
                                    ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                S.of(context).promotionStart(
                                    dateFormat.format(promotion.startTime)),
                                style: timeStyle,
                              ),
                              Text(
                                S.of(context).promotionEnd(
                                    dateFormat.format(promotion.endTime)),
                                style: timeStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void tap(Promotion promotion, BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).selectCouponCode),
          content: Text(promotion.code),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (identical(ok, true)) {
      AppScaffold.navigatorOfCurrentIndex(context).pop(promotion);
    }
  }
}
