import 'package:flutter/material.dart';
import '../../domain/model/age_type.dart';

import '../../domain/model/movie.dart';
import 'movie_info.dart';

class MoviePage extends StatefulWidget {
  static const routeName = '/movie_page_route';

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final List<Movie> movies = List.generate(
      10,
      (index) => Movie(
            id: 'id' + index.toString(),
            isActive: false,
            actorIds: List.empty(),
            directorIds: List.empty(),
            title: 'asdadasdffsaf',
            trailerVideoUrl: '',
            posterUrl: '',
            overview: '',
            releasedDate: DateTime(1000),
            duration: 10,
            originalLanguage: '',
            createdAt: DateTime(1000),
            updatedAt: DateTime(100),
            ageType: AgeType.C13,
            actors: List.empty(),
            directors: List.empty(),
            categories: List.empty(),
            rateStar: 4.5,
            totalFavorite: 10,
            totalRate: 10,
          ));
  Color mainColor = const Color(0xff3C3261);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Movies',
          style: TextStyle(
              color: mainColor,
              fontFamily: 'Arvo',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: movies == null ? 0 : movies.length,
                  itemBuilder: (context, i) {
                    return FlatButton(
                      child: MovieCell(movies, i),
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MovieInfoPage(movie: movies[i]);
                        }));
                      },
                      color: Colors.white,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class MovieCell extends StatelessWidget {
  final List<Movie> movies;
  final i;
  final Color mainColor = const Color(0xff3C3261);
  final image_url = 'https://image.tmdb.org/t/p/w500/';

  MovieCell(this.movies, this.i);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                margin: const EdgeInsets.all(16.0),
                child: Container(
                  width: 70.0,
                  height: 70.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                  image: DecorationImage(
                      image: NetworkImage(image_url),
                      fit: BoxFit.cover),
                  boxShadow: [
                    BoxShadow(
                        color: mainColor,
                        blurRadius: 5.0,
                        offset: Offset(2.0, 5.0))
                  ],
                ),
              ),
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: Column(
                children: [
                  Text(
                    movies[i].title,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Arvo',
                        fontWeight: FontWeight.bold,
                        color: mainColor),
                  ),
                  Padding(padding: const EdgeInsets.all(2.0)),
                  Text(
                    movies[i].overview,
                    maxLines: 3,
                    style: TextStyle(
                        color: const Color(0xff8785A4), fontFamily: 'Arvo'),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            )),
          ],
        ),
        Container(
          width: 300.0,
          height: 0.5,
          color: const Color(0xD2D2E1ff),
          margin: const EdgeInsets.all(16.0),
        )
      ],
    );
  }
}
