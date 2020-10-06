import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';

import '../../../../domain/model/card.dart' as domain;
import '../../../app_scaffold.dart';
import '../cards/cards_page.dart';
import '../checkout_page.dart';

class SelectedCard extends StatelessWidget {
  const SelectedCard({Key key}) : super(key: key);

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
            final card = await AppScaffold.of(context).pushNamed(
              CardsPage.routeName,
              arguments: bloc.selectedCard$.value,
            );
            bloc.selectedCard(card as domain.Card);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ),
            child: Row(
              children: [
                RxStreamBuilder<domain.Card>(
                    stream: bloc.selectedCard$,
                    builder: (context, snapshot) {
                      final card = snapshot.data;
                      return Expanded(
                        child: Text(card == null
                            ? 'Select or add a card'
                            : "Selected '${card.last4}'. Tap to change"),
                      );
                    }),
                Icon(
                  Icons.credit_card_rounded,
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
