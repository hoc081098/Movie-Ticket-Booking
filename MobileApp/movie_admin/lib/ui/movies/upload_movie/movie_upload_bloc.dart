import 'dart:io';

import 'package:disposebag/disposebag.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';
import 'movie_upload_input.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/repository/movie_repository.dart';

import '../../../domain/model/category.dart';
import '../../../domain/model/movie.dart';
import '../../../domain/model/person.dart';
import '../../../utils/type_defs.dart';

enum UrlType { URL, FILE }

class MovieUploadBloc extends DisposeCallbackBaseBloc {
  final Function0<List<Category>> loadCategory;
  final Function1<String, List<Person>> loadPerson;
  final Function1<MovieUploadInput, void> uploadMovie;
  final Function1<Tuple2<UrlType, String>, void> posterUrl;
  final Function1<Tuple2<UrlType, String>, void> trailerUrl;

  final Stream<List<Category>> fetchCategory$;
  final Stream<List<Person>> showSearch$;
  final Stream<bool> loading$;
  final Stream<Movie> stateStream$;
  final Stream<Tuple2<UrlType, String>> posterUrlStream$;
  final Stream<Tuple2<UrlType, String>> trailerUrlStream$;

  MovieUploadBloc._({
    @required this.posterUrl,
    @required this.trailerUrl,
    @required this.loadCategory,
    @required this.loadPerson,
    @required this.uploadMovie,
    @required this.fetchCategory$,
    @required this.showSearch$,
    @required this.loading$,
    @required this.stateStream$,
    @required this.trailerUrlStream$,
    @required this.posterUrlStream$,
    @required Function0<void> dispose,
  }) : super(dispose);

  factory MovieUploadBloc(MovieRepository repository) {
    final uploadMovieSubject = PublishSubject<MovieUploadInput>();
    final loadingSubject = BehaviorSubject.seeded(false);
    final posterTypeUrlSubject =
        BehaviorSubject.seeded(Tuple2(UrlType.FILE, ''));
    final trailerTypeUrlSubject =
        BehaviorSubject.seeded(Tuple2(UrlType.FILE, ''));

    final choiceFile = Rx.merge([
      posterTypeUrlSubject
          .where((e) => e.item1 == UrlType.FILE)
          .map((e) => e.item2)
          .where((e) => e.isNotEmpty),
      trailerTypeUrlSubject
          .where((e) => e.item1 == UrlType.FILE)
          .map((e) => e.item2)
          .where((e) => e.isNotEmpty)
    ]).exhaustMap(
      (path) => Rx.defer(() async* {
        final task = FirebaseStorage.instance
            .ref()
            .child('trailer_images')
            .child(path + '_movie_admin')
            .putFile(File(path));
        await task.onComplete;
        if (task.isSuccessful) {
          yield (await task.lastSnapshot.ref.getDownloadURL()).toString();
        }
      }),
    );

    final uploadStream = uploadMovieSubject
        .where((e) => e.isHasData())
        .exhaustMap(
          (input) => Rx.defer(() async* {
            yield await repository.uploadMovie(input.toMovie());
          }),
        )
        .where((movie) => movie != null)
        .doOnListen(() => loadingSubject.add(true))
        .doOnData((event) => loadingSubject.add(false))
        .doOnError((_, track) => loadingSubject.add(false))
        .publish();

    final controllers = [uploadMovieSubject, posterTypeUrlSubject, trailerTypeUrlSubject];
    final streams = [uploadStream, choiceFile];
    return MovieUploadBloc._(
      dispose: DisposeBag([...controllers, ...streams]).dispose,
      loadCategory: null,
      loadPerson: null,
      uploadMovie: uploadMovieSubject.add,
      fetchCategory$: null,
      showSearch$: null,
      loading$: null,
      stateStream$: uploadStream,
      trailerUrl: trailerTypeUrlSubject.add,
      posterUrl: posterTypeUrlSubject.add,
      trailerUrlStream$: trailerTypeUrlSubject.stream,
      posterUrlStream$: posterTypeUrlSubject.stream,
    );
  }
}