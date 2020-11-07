import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';

import '../../../domain/model/movie.dart';
import '../../../domain/repository/movie_repository.dart';
import '../../../utils/streams.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/home/search';

  final String query;

  const SearchPage({Key key, @required this.query}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final now = DateTime.now();

    Provider.of<MovieRepository>(context)
        .search(
          query: widget.query,
          showtimeStartTime: now.subtract(const Duration(days: 7)),
          showtimeEndTime: now.add(const Duration(days: 7)),
          minReleasedDate: now.subtract(const Duration(days: 30)),
          maxReleasedDate: now.add(const Duration(days: 30)),
          minDuration: 30,
          maxDuration: 500,
          ageType: AgeType.P,
        )
        .debug('SEARCH')
        .listen(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.query),
      ),
    );
  }
}
