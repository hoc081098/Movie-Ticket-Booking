import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/model/theatre.dart';

class TheatreInfoPage extends StatelessWidget {
  static const routeName = '/home/theatres/info';

  final Theatre theatre;
  final bool automaticallyImplyLeading;
  final Widget child;

  TheatreInfoPage(
      {Key key,
      @required this.theatre,
      this.automaticallyImplyLeading,
      this.child})
      : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final releaseDateFormat = DateFormat('dd/MM/yy');

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final textStyle = themeData.textTheme.subtitle1.copyWith(
      fontSize: 14,
      color: const Color(0xff687189),
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      key: scaffoldKey,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          DetailAppBar(
            theatre: theatre,
            automaticallyImplyLeading: automaticallyImplyLeading,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    theatre.name,
                    style: themeData.textTheme.headline4.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff687189),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    height: 1,
                    color: Color(0xffD1DBE2),
                  ),
                  const SizedBox(height: 8),
                  ExpandablePanel(
                    header: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff8690A0),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          margin: const EdgeInsets.only(top: 7),
                          child: Text(
                            'DESCRIPTION',
                            maxLines: 1,
                            style: themeData.textTheme.headline6.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    collapsed: Text(
                      theatre.description,
                      softWrap: true,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Text(
                      theatre.description,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.label,
                        color: const Color(0xff8690A0),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          theatre.address,
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: const Color(0xff8690A0),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          theatre.phoneNumber ?? 'N/A',
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (theatre.email != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: const Color(0xff8690A0),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            theatre.email,
                            style: textStyle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Icon(
                        Icons.category,
                        color: const Color(0xff8690A0),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          theatre.roomSummary,
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.timelapse_outlined,
                        color: const Color(0xff8690A0),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          theatre.openingHours,
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
                  if (child != null) ...[
                    child,
                    const SizedBox(height: 32),
                  ] else
                    const SizedBox(height: 200)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DetailAppBar extends StatelessWidget {
  final bool automaticallyImplyLeading;

  const DetailAppBar(
      {Key key, @required this.theatre, this.automaticallyImplyLeading})
      : super(key: key);

  final Theatre theatre;

  @override
  Widget build(BuildContext context) {
    final b = identical(automaticallyImplyLeading, true);

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      floating: true,
      stretch: true,
      leading: b ? null : BackButton(),
      automaticallyImplyLeading: false,
      title: Text(theatre.name),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
        background: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: theatre.cover ?? '',
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
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    // backgroundBlendMode: BlendMode.screen,
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                        // const Color(0xff545AE9).withOpacity(0.6),
                        // const Color(0xffB881F9),
                      ],
                      // stops: [0, 0.5, 1],
                      begin: AlignmentDirectional.topEnd,
                      end: AlignmentDirectional.bottomStart,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
