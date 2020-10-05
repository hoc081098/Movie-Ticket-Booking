import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';

import '../../../../domain/repository/card_repository.dart';

class CardsBloc extends DisposeCallbackBaseBloc {
  CardsBloc._(void Function() dispose) : super(dispose);

  factory CardsBloc(CardRepository cardRepository) {}
}

class CardsPage extends StatefulWidget {
  static const routeName = 'home/detail/tickets/combo/checkout/cards';

  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
