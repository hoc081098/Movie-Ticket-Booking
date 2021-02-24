import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:tuple/tuple.dart';

import '../../domain/model/movie.dart';
import '../../domain/repository/movie_repository.dart';
import '../../utils/utils.dart';

class MovieBloc extends DisposeCallbackBaseBloc {
  final Function0 loadMovies;
  final Function1<Movie, void> removeMovie;
  final Function1<Movie, void> addMovie;

  final Stream<Tuple2<List<Movie>, bool>> loadMovies$;
  final Stream<Movie> removeMovies$;
  final Stream<Movie> addMovies$;
  final Stream<bool> loading$;

  MovieBloc._({
    @required Function0<void> dispose,
    @required this.loadMovies,
    @required this.removeMovie,
    @required this.addMovie,
    @required this.loadMovies$,
    @required this.removeMovies$,
    @required this.addMovies$,
    @required this.loading$,
  }) : super(dispose);

  factory MovieBloc(MovieRepository repository) {
    final loadMovieSubject = BehaviorSubject<void>.seeded(0);
    final removeMovieSubject = PublishSubject<Movie>();
    final addMovieSubject = PublishSubject<Movie>();
    final loadingSubject = BehaviorSubject<bool>.seeded(true);
    var currentLengthList = 0;

    final loadMovieStream = Rx.combineLatest2(
        loadMovieSubject
            .map((_) => currentLengthList)
            .exhaustMap((numberList) => Rx.fromCallable(
                    () => repository.getListMovie(numberList ~/ 10 + 1, 10))
                .doOnListen(() => loadingSubject.add(true))
                .doOnCancel(() => loadingSubject.add(false)))
            .scan((accumulated, value, index) =>
                <Movie>[...?accumulated, ...value])
            .doOnData((list) => currentLengthList = list.length)
            .debug(identifier: '??????'),
        loadingSubject.stream,
        (List<Movie> v1, bool v2) => Tuple2(v1, v2)).share();

    final controllers = [loadMovieSubject, removeMovieSubject, addMovieSubject];
    final streams = [loadMovieStream];
    return MovieBloc._(
        dispose: DisposeBag([...controllers, ...streams]).dispose,
        loadMovies: () => loadMovieSubject.add(null),
        removeMovie: removeMovieSubject.add,
        addMovie: addMovieSubject.add,
        addMovies$: addMovieSubject.stream,
        loading$: loadingSubject.stream,
        removeMovies$: removeMovieSubject.stream,
        loadMovies$: loadMovieStream);
  }
}
