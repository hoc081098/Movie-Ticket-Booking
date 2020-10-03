import 'package:flutter/material.dart';

import '../../../app_scaffold.dart';
import '../cards/cards_page.dart';

class SelectedCard extends StatelessWidget {
  const SelectedCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          onTap: () {
            AppScaffold.of(context).pushNamed(CardsPage.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ),
            child: Row(
              children: [
                Expanded(child: Text('Select or add a card')),
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
