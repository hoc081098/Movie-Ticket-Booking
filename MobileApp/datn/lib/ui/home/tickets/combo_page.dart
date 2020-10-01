import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datn/ui/widgets/age_type.dart';
import 'package:datn/ui/widgets/error_widget.dart';
import 'package:datn/utils/error.dart';
import 'package:datn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../domain/model/movie.dart';
import '../../../domain/model/show_time.dart';
import '../../../domain/model/theatre.dart';
import '../../../domain/model/ticket.dart';
import 'combo_bloc.dart';
import 'combo_state.dart';

class ComboPage extends StatefulWidget {
  static const routeName = 'home/detail/tickets/combo';

  final BuiltList<Ticket> tickets;
  final ShowTime showTime;
  final Theatre theatre;
  final Movie movie;

  const ComboPage({
    Key key,
    @required this.tickets,
    @required this.showTime,
    @required this.theatre,
    @required this.movie,
  }) : super(key: key);

  @override
  _ComboPageState createState() => _ComboPageState();
}

class _ComboPageState extends State<ComboPage> with DisposeBagMixin {
  dynamic token;
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');
  int ticketsPrice;

  @override
  void initState() {
    super.initState();
    ticketsPrice = widget.tickets.fold(0, (acc, e) => acc + e.price);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token ??= BlocProvider.of<ComboBloc>(context)
        .message$
        .listen((_) => context.showSnackBar('Maximum combo count'))
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ComboBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Combo'),
      ),
      body: RxStreamBuilder<ComboState>(
        stream: bloc.state$,
        builder: (context, snapshot) {
          final state = snapshot.data;

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

          final items = state.items;

          final titleStyle =
              Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 16);
          final priceStyle = Theme.of(context).textTheme.subtitle1.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              );

          final movieTitleStyle =
              Theme.of(context).textTheme.headline4.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff687189),
                  );
          final buttonHeight = 54.0;

          return Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: buttonHeight,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      const h = 128.0;
                      const w = h / 1.3;

                      return Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: Offset(4, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    widget.movie.title,
                                    style: movieTitleStyle,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      AgeTypeWidget(
                                          ageType: widget.movie.ageType),
                                      const SizedBox(width: 8),
                                      Text('${widget.movie.duration} minutes'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: w,
                                height: h,
                                child: CachedNetworkImage(
                                  imageUrl: widget.movie.posterUrl ?? '',
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (_, __, ___) => Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.error,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Load image error',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    index--;
                    final item = items[index];
                    final product = item.product;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: Offset(4, 0),
                            ),
                          ]),
                      child: ExpansionTile(
                        title: Text(
                          product.name,
                          style: titleStyle,
                        ),
                        subtitle: Text(
                          '${currencyFormat.format(product.price)} VND',
                          style: priceStyle,
                        ),
                        leading: Image.network(
                          product.image,
                          width: 64,
                          height: 64,
                        ),
                        childrenPadding: const EdgeInsets.all(8.0),
                        children: [
                          Text(
                            product.description,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item.count > 0)
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => bloc.decrement(item),
                              )
                            else
                              IconButton(
                                icon: const SizedBox(width: 24, height: 24),
                                onPressed: () {},
                              ),
                            Text(
                              item.count.toString(),
                              style: titleStyle,
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => bloc.increment(item),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: items.length + 1,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: const Color(0xffCBD7E9),
                  height: buttonHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap:() {},
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 8),
                              FaIcon(
                                FontAwesomeIcons.cartPlus,
                                color: const Color(0xff687189),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    '${currencyFormat.format(state.totalPrice + ticketsPrice)} VND',
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
                          onPressed: () {},
                          child: Text(
                            'CONTINUE',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
