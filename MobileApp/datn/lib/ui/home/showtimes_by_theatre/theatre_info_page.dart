import 'package:built_collection/src/list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datn/domain/model/theatre.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_loader/stream_loader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/model/movie.dart';
import '../../../../domain/model/person.dart';
import '../../../../domain/repository/favorites_repository.dart';
import '../../../../domain/repository/movie_repository.dart';
import '../../../../utils/error.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/age_type.dart';
import '../../../widgets/error_widget.dart';

class TheatreInfoPage extends StatelessWidget {
  final Theatre movie;

  const TheatreInfoPage({Key key, this.movie}) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final releaseDateFormat = DateFormat('dd/MM/yy');

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      key: scaffoldKey,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          DetailAppBar(theatre: theatre),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    movie.title,
                    style: themeData.textTheme.headline4.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff687189),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.5),
                            border: Border.all(
                              color: const Color(0xff687189),
                              width: 1,
                            )),
                      ),
                      const SizedBox(width: 8),
                      Text('${movie.duration} minutes'),
                      const SizedBox(width: 8),
                      const SizedBox(width: 8),
                      Text(releaseDateFormat.format(movie.releasedDate)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    children: [
                      for (var c in movie.categories) ...[
                        ActionChip(
                          label: Text(
                            '#${c.name}',
                            style: themeData.textTheme.subtitle1
                                .copyWith(fontSize: 12),
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 4),
                      ]
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                    height: 1,
                    color: Color(0xffD1DBE2),
                  ),
                  const SizedBox(height: 16),
                  ExpandablePanel(
                    header: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Color(0xff8690A0),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            'STORYLINE',
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
                      movie.,
                      softWrap: true,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Text(
                      movie.overview,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'CAST OVERVIEW',
                    maxLines: 1,
                    style: themeData.textTheme.headline6.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff687189),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PeopleList(people: movie.actors),
                  Text(
                    'DIRECTORS',
                    maxLines: 1,
                    style: themeData.textTheme.headline6.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff687189),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PeopleList(people: movie.directors),
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
  const DetailAppBar({Key key, @required this.theatre}) : super(key: key);

  final Theatre theatre;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: false,
      floating: false,
      stretch: true,
      backgroundColor: const Color(0xfffafafa),
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
      automaticallyImplyLeading: false,
    );
  }
}
