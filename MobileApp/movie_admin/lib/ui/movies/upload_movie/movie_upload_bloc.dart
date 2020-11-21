import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:movie_admin/domain/repository/movie_repository.dart';
import 'package:tuple/tuple.dart';

import '../../../domain/model/category.dart';
import '../../../domain/model/movie.dart';
import '../../../domain/model/person.dart';
import '../../../utils/type_defs.dart';

class MovieBloc extends DisposeCallbackBaseBloc {
  final Function0<List<Category>> loadCategory;
  final Function1<String, List<Person>> loadPerson;
  final Function1<Movie, void> uploadMovie;

  final Stream<List<Category>> fetchCategory$;
  final Stream<Movie> removeMovies$;
  final Stream<List<Person>> showSearch$;
  final Stream<bool> loading$;

  MovieBloc._({
    @required this.loadCategory,
    @required this.loadPerson,
    @required this.uploadMovie,
    @required this.fetchCategory$,
    @required this.removeMovies$,
    @required this.showSearch$,
    @required this.loading$,
    @required Function0<void> dispose,
  }) : super(dispose);

  factory MovieBloc(MovieRepository repository) {
    final controllers = [];
    final streams = [];
    return MovieBloc._(
        dispose: DisposeBag([...controllers, ...streams]).dispose);
  }
}
