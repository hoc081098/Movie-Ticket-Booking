import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../domain/model/promotion.dart';
import '../../../../domain/model/show_time.dart';
import '../../../../generated/l10n.dart';
import '../../../app_scaffold.dart';
import '../checkout_page.dart';
import '../discount/discounts_page.dart';

class SelectDiscount extends StatelessWidget {
  final ShowTime showTime;

  const SelectDiscount({Key? key, required this.showTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CheckoutBloc>(context);

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(8, 0),
          ),
        ],
      ),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () async {
            final promotion =
                (await AppScaffold.navigatorOfCurrentIndex(context).pushNamedX(
              DiscountsPage.routeName,
              arguments: showTime.id,
            )) as Promotion?;

            print('[DEBUG] receiver ${promotion?.id}');
            if (promotion != null) {
              bloc.selectPromotion(promotion);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ),
            child: Row(
              children: [
                RxStreamBuilder<Promotion?>(
                  stream: bloc.selectedPromotion$,
                  builder: (context, pro) {
                    return Expanded(
                      child: Text(
                        pro == null
                            ? S.of(context).selectDiscountCode
                            : pro.code,
                        maxLines: 1,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                FaIcon(
                  FontAwesomeIcons.tags,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
