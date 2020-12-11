import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tuple/tuple.dart';

import '../../domain/model/movie.dart';
import '../../utils/utils.dart';
import '../app_scaffold.dart';
import '../widgets/age_type.dart';
import 'movie_bloc.dart';
import 'movie_info.dart';

class MoviePage extends StatefulWidget {
  static const routeName = '/movie_page_route';

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  MovieBloc _bloc;
  ScrollController _scrollController;

  @override
  void didChangeDependencies() {
    _bloc ??= BlocProvider.of<MovieBloc>(context)..loadMovies();
    _scrollController ??= ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels + 100 >=
            _scrollController.position.maxScrollExtent) {
          _bloc.loadMovies();
        }
      });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<Tuple2<List<Movie>, bool>>(
              stream: _bloc.loadMovies$,
              builder: (context, snapshot) {
                final data = snapshot.data;

                final movies = data?.item1;
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: data == null
                      ? 1
                      : data.item2
                          ? movies.length + 1
                          : movies.length,
                  itemBuilder: (context, i) {
                    return i < (movies?.length ?? 0)
                        ? MovieCell(movies[i], (_) {})
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class MovieCell extends StatelessWidget {
  final Movie item;
  final Function1<Movie, void> onToggle;
  final Function1<Movie, void> onTap;

  MovieCell(this.item, this.onToggle, [this.onTap]);

  @override
  Widget build(BuildContext context) {
    const imageHeight = 154.0;
    const imageWidth = imageHeight * 0.7;

    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          fontSize: 17,
          color: const Color(0xff687189),
        );
    final durationStyle =
        Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14);

    final rateStyle = titleStyle.copyWith(fontSize: 20);

    return InkWell(
      onTap: onTap != null
          ? () => onTap(item)
          : () {
              AppScaffold.of(context)
                  .pushNamed(MovieInfoPage.routeName, arguments: item);
            },
      child: Container(
        margin: const EdgeInsets.only(
          left: 6,
          right: 8,
          top: 8,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: Offset(2, 4),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: [
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => onToggle(item),
            ),
          ],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: imageWidth,
                  height: imageHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: item.posterUrl ?? '',
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
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: AgeTypeWidget(
                          ageType: item.ageType,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: titleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.duration} minutes',
                      style: durationStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_rounded,
                          size: 32,
                          color: Color(0xff8690A0),
                        ),
                        const SizedBox(width: 4),
                        RichText(
                          text: TextSpan(
                            text: item.rateStar.toStringAsFixed(2),
                            style: rateStyle,
                            children: [
                              TextSpan(
                                text: ' / 5',
                                style: durationStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.totalRate} reviews',
                      style: durationStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
