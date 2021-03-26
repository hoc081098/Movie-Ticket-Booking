import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/model/movie.dart';

final _cached = <AgeType, String>{};

class AgeTypeWidget extends StatelessWidget {
  final AgeType ageType;

  const AgeTypeWidget({Key? key, required this.ageType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: ageType == AgeType.P ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            offset: Offset(3, 3),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Text(
        _cached.putIfAbsent(
          ageType,
          () => describeEnum(ageType),
        ),
        style: Theme.of(context).textTheme.button!.copyWith(
              color: Colors.white,
              fontSize: 14,
            ),
      ),
    );
  }
}
