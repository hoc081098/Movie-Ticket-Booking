import 'package:datn/domain/repository/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';

class MovieInfoPage extends StatefulWidget {
  final String movieId;

  const MovieInfoPage({Key key, this.movieId}) : super(key: key);

  @override
  _MovieInfoPageState createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<MovieRepository>(context)
        .getMovieDetail(widget.movieId)
        .listen(print);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}
