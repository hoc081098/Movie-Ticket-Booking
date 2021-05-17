import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import '../../../../domain/model/product.dart';
import '../../../../domain/model/promotion.dart';
import '../../../../domain/model/ticket.dart';
import '../../../../generated/l10n.dart';
import '../checkout_page.dart';

class BottomRow extends StatelessWidget {
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');

  final BuiltList<Tuple2<Product, int>> comboItems;
  final BuiltList<Ticket> tickets;
  final VoidAction onSubmit;

  final int totalCount;
  final int originalTotalPrice;

  BottomRow({
    Key? key,
    required this.comboItems,
    required this.tickets,
    required this.onSubmit,
  })   : totalCount =
            comboItems.fold<int>(0, (acc, e) => acc + e.item2) + tickets.length,
        originalTotalPrice = tickets.fold<int>(0, (acc, e) => acc + e.price) +
            comboItems.fold<int>(0, (acc, e) => acc + e.item1.price * e.item2),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bloc = BlocProvider.of<CheckoutBloc>(context);

    final priceStyle = textTheme.subtitle1!.copyWith(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.w500,
    );

    return RxStreamBuilder<Promotion?>(
      stream: bloc.selectedPromotion$,
      builder: (context, promotion) {
        final totalPrice = promotion != null
            ? (originalTotalPrice * (1 - promotion.discount)).ceil()
            : originalTotalPrice;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => showOrder(context, promotion),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 4),
                    Container(
                      height: 36,
                      width: 36,
                      child: Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: FaIcon(
                              FontAwesomeIcons.cartPlus,
                              color: const Color(0xff687189),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: const Color(0xfffe4023),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Center(
                                child: Text(
                                  totalCount.toString(),
                                  style: textTheme.headline6!.copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '${currencyFormat.format(totalPrice)} VND',
                          style: priceStyle.copyWith(fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: RxStreamBuilder<bool>(
                stream: bloc.isLoading$,
                builder: (context, data) {
                  if (data) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    );
                  }

                  return TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      primary: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(),
                    ),
                    onPressed: onSubmit,
                    child: Text(
                      S.of(context).FINISH,
                      style: textTheme.headline6!
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void showOrder(BuildContext context, Promotion? promotion) {
    final style = Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 15);
    final style2 = style.copyWith(fontSize: 17);
    final titleStyle =
        Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 13);

    final ticketsByCount = tickets.groupListsBy((i) => i.seat.count).entries;

    final children = [
      ...[
        for (var item in ticketsByCount)
          item.key == 1
              ? ListTile(
                  title: Text(
                    S.of(context).normalTicket,
                    style: titleStyle,
                  ),
                  subtitle: Text(
                    currencyFormat.format(item.value[0].price) + ' VND',
                    style: style,
                  ),
                  trailing: Text(
                    'x' + item.value.length.toString(),
                    style: style2,
                  ),
                )
              : ListTile(
                  title: Text(
                    S.of(context).doubledTicket,
                    style: titleStyle,
                  ),
                  subtitle: Text(
                    currencyFormat.format(item.value[0].price) + ' VND',
                    style: style,
                  ),
                  trailing: Text(
                    'x' + item.value.length.toString(),
                    style: style2,
                  ),
                ),
      ],
      ...[
        for (var item in comboItems)
          ListTile(
            title: Text(
              item.item1.name,
              style: titleStyle,
            ),
            subtitle: Text(
              currencyFormat.format(item.item1.price) + ' VND',
              style: style,
            ),
            trailing: Text(
              'x' + item.item2.toString(),
              style: style2,
            ),
          ),
      ],
      if (promotion != null) ...[
        const Divider(
          height: 8,
          thickness: 1,
        ),
        ListTile(
          title: Text(
            S.of(context).couponCode.replaceAll(': ', ''),
            style: titleStyle,
          ),
          subtitle: Text(
            '${(promotion.discount * 100).toInt()}% ${S.of(context).OFF}',
            style: style,
          ),
        ),
      ]
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 72.0 * children.length + (promotion == null ? 0 : -72 + 8),
          child: ListView(
            children: children,
          ),
        );
      },
    );
  }
}
