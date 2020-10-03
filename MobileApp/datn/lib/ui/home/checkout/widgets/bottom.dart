import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import '../../../../domain/model/product.dart';
import '../../../../domain/model/ticket.dart';
import '../../../../utils/iterable.dart';
import '../checkout_page.dart';

class BottomRow extends StatelessWidget {
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');

  final BuiltList<Tuple2<Product, int>> comboItems;
  final BuiltList<Ticket> tickets;

  BottomRow({
    Key key,
    @required this.comboItems,
    @required this.tickets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bloc = BlocProvider.of<CheckoutBloc>(context);

    final priceStyle = textTheme.subtitle1.copyWith(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.w500,
    );

    final totalCount =
        comboItems.fold(0, (acc, e) => acc + e.item2) + tickets.length;

    final totalPrice = tickets.fold(0, (acc, e) => acc + e.price) +
        comboItems.fold(0, (acc, e) => acc + e.item1.price * e.item2);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: InkWell(
            onTap: () => showOrder(context),
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
                              style: textTheme.headline6.copyWith(
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
          child: FlatButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              //TODO
              bloc.submit();
            },
            child: Text(
              'FINISH',
              style: textTheme.headline6
                  .copyWith(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void showOrder(BuildContext context) {
    final style = Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 15);
    final style2 = style.copyWith(fontSize: 17);
    final titleStyle =
        Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 13);

    final ticketsByCount =
        tickets.groupBy((i) => i.seat.count, (i) => i).entries;

    final children = [
      ...[
        for (var item in ticketsByCount)
          item.key == 1
              ? ListTile(
                  title: Text(
                    'Normal ticket',
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
                    'Doubled ticket',
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
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 72.0 * children.length,
          child: ListView(
            children: children,
          ),
        );
      },
    );
  }
}
