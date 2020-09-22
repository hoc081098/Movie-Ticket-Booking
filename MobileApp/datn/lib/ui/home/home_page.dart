import 'package:datn/domain/repository/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<MovieRepository>(context).getNowPlayingMovies(null, 1).listen(
      (event) {
        print(event);
      },
      onError: (e, s) {
        print(e);
        print(s);
        throw e;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
    );
  }
}
