import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:octo_image/octo_image.dart';
import 'package:tuple/tuple.dart';

import '../../../domain/model/movie.dart';
import '../../../domain/model/show_time.dart';
import '../../../domain/model/theatre.dart';
import '../../../domain/model/ticket.dart';
import '../../../generated/l10n.dart';
import '../../../utils/error.dart';
import '../../../utils/utils.dart';
import '../../app_scaffold.dart';
import '../../widgets/age_type.dart';
import '../../widgets/error_widget.dart';
import '../checkout/checkout_page.dart';
import 'combo_bloc.dart';
import 'combo_state.dart';
import 'ticket_page.dart';

class ComboPage extends StatefulWidget {
  static const routeName = 'home/detail/tickets/combo';

  final BuiltList<Ticket> tickets;
  final ShowTime showTime;
  final Theatre theatre;
  final Movie movie;

  const ComboPage({
    Key? key,
    required this.tickets,
    required this.showTime,
    required this.theatre,
    required this.movie,
  }) : super(key: key);

  @override
  _ComboPageState createState() => _ComboPageState();
}

class _ComboPageState extends State<ComboPage> with DisposeBagMixin {
  Object? token;
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');
  final startTimeFormat = DateFormat('dd/MM/yy, EEE, hh:mm a');

  late int ticketsPrice;
  late BuiltList<MapEntry<int, List<Ticket>>> ticketsByCount;

  @override
  void initState() {
    super.initState();
    ticketsPrice = widget.tickets.fold(0, (acc, e) => acc + e.price);

    ticketsByCount =
        widget.tickets.groupListsBy((t) => t.seat.count).entries.toBuiltList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token ??= BlocProvider.of<ComboBloc>(context)
        .message$
        .listen((_) => context.showSnackBar(S.of(context).maximumComboCount))
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ComboBloc>(context);
    final countDownStyle = Theme.of(context)
        .textTheme
        .subtitle2!
        .copyWith(color: Colors.white, fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).combo),
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
      body: RxStreamBuilder<ComboState>(
        stream: bloc.state$,
        builder: (context, state) {
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
                    .error_with_message(getErrorMessage(state.error!)),
                onPressed: bloc.fetch,
              ),
            );
          }

          final items = state.items;

          final textTheme = Theme.of(context).textTheme;
          final titleStyle = textTheme.subtitle2!.copyWith(fontSize: 15);
          final countStyle = titleStyle.copyWith(fontSize: 18);
          final priceStyle = textTheme.subtitle1!.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          );

          final movieTitleStyle = textTheme.headline4!.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: const Color(0xff687189),
          );
          final buttonHeight = 54.0;

          final textStyle = textTheme.subtitle1!.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: const Color(0xff98A8BA),
          );

          final textStyle2 = textTheme.subtitle1!.copyWith(
            fontSize: 16,
            color: const Color(0xff687189),
            fontWeight: FontWeight.w600,
          );

          return Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: buttonHeight + 8,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return buildTopHeader(
                        movieTitleStyle,
                        context,
                        textTheme,
                        textStyle,
                        textStyle2,
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
                        ],
                      ),
                      child: ExpansionTile(
                        title: Text(
                          product.name,
                          style: titleStyle,
                        ),
                        subtitle: Text(
                          '${currencyFormat.format(product.price)} VND',
                          style: priceStyle,
                        ),
                        leading: OctoImage(
                          image: NetworkImage(product.image),
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, event) {
                            return const Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => const SizedBox(),
                        ),
                        childrenPadding: const EdgeInsets.all(8.0),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item.count > 0)
                              InkWell(
                                onTap: () => bloc.decrement(item),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey)),
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(Icons.remove),
                                ),
                              )
                            else
                              const SizedBox(width: 30, height: 30),
                            const SizedBox(width: 4),
                            Text(
                              item.count.toString(),
                              style: countStyle,
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () => bloc.increment(item),
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey)),
                                padding: const EdgeInsets.all(6),
                                child: Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Text(
                            product.description,
                            style: textTheme.caption,
                          ),
                        ],
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
                  decoration: BoxDecoration(
                    // color: const Color(0xffCBD7E9),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: Offset(0, -4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  height: buttonHeight,
                  child: buildBottomRow(state, priceStyle, context, textTheme),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Container buildTopHeader(
    TextStyle movieTitleStyle,
    BuildContext context,
    TextTheme textTheme,
    TextStyle textStyle,
    TextStyle textStyle2,
  ) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        AgeTypeWidget(ageType: widget.movie.ageType),
                        const SizedBox(width: 8),
                        Text(S
                            .of(context)
                            .duration_minutes(widget.movie.duration)),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.error,
                            color: Theme.of(context).accentColor,
                          ),
                          SizedBox(height: 4),
                          Text(
                            context.s.load_image_error,
                            style: textTheme.subtitle2!.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text:
                TextSpan(text: context.s.startAt, style: textStyle, children: [
              TextSpan(
                text: startTimeFormat.format(widget.showTime.start_time),
                style: textStyle2,
              ),
            ]),
          ),
          const SizedBox(height: 8),
          RichText(
            text:
                TextSpan(text: context.s.theatre, style: textStyle, children: [
              TextSpan(
                text: widget.theatre.name,
                style: textStyle2,
              ),
              TextSpan(
                text: context.s.room,
                style: textStyle,
              ),
              TextSpan(
                text: widget.showTime.room,
                style: textStyle2,
              ),
            ]),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
                text: context.s.address + ': ',
                style: textStyle,
                children: [
                  TextSpan(
                    text: widget.theatre.address,
                    style: textStyle2,
                  ),
                ]),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Row buildBottomRow(
    ComboState state,
    TextStyle priceStyle,
    BuildContext context,
    TextTheme textTheme,
  ) {
    final comboItems = state.items.where((i) => i.count > 0).toBuiltList();
    final totalCount = comboItems.fold<int>(0, (acc, e) => acc + e.count) +
        widget.tickets.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: InkWell(
            onTap: () => showOrder(comboItems),
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
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              primary: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(),
            ),
            onPressed: () => tapContinue(comboItems),
            child: Text(
              context.s.CONTINUE,
              style: textTheme.headline6!
                  .copyWith(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void showOrder(BuiltList<ComboItem> comboItems) {
    final style = Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 15);
    final style2 = style.copyWith(fontSize: 17);
    final titleStyle =
        Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 13);

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
              item.product.name,
              style: titleStyle,
            ),
            subtitle: Text(
              currencyFormat.format(item.product.price) + ' VND',
              style: style,
            ),
            trailing: Text(
              'x' + item.count.toString(),
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

  void tapContinue(BuiltList<ComboItem> comboItems) {
    AppScaffold.navigatorOfCurrentIndex(context).pushNamedX(
      CheckoutPage.routeName,
      arguments: <String, dynamic>{
        'showTime': widget.showTime,
        'theatre': widget.theatre,
        'movie': widget.movie,
        'products':
            comboItems.map((i) => Tuple2(i.product, i.count)).toBuiltList(),
        'tickets': widget.tickets,
      },
    );
  }
}
