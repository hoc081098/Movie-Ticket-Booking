import 'package:flutter/material.dart';

class LegendsWidget extends StatelessWidget {
  const LegendsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthPerSeat = MediaQuery.of(context).size.width / 12;
    final accentColor = Theme.of(context).accentColor;
    final textStyle = Theme.of(context).textTheme.subtitle2.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(0.5),
                  width: widthPerSeat,
                  height: widthPerSeat,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Available',
                  style: textStyle,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(0.5),
                  width: widthPerSeat,
                  height: widthPerSeat,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xffCBD7E9),
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Unavailable',
                  style: textStyle,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(0.5),
                  width: widthPerSeat * 2,
                  height: widthPerSeat,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xffCBD7E9),
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Doubled seat',
                  style: textStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
