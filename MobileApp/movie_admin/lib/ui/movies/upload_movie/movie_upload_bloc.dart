import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:movie_admin/ui/widgets/loading_button.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../../domain/model/category.dart';
import '../../../domain/model/person.dart';
import '../../../domain/repository/movie_repository.dart';
import '../../../utils/type_defs.dart';
import 'movie_upload_input.dart';

enum UrlType { URL, FILE }

class MovieUploadBloc extends DisposeCallbackBaseBloc {
  final Function1<int, void> loadCategory;
  final Function1<String, void> loadPerson;
  final Function1<MovieUploadInput, void> uploadMovie;
  final Function1<Tuple2<UrlType, String>, void> posterUrl;
  final Function1<Tuple2<UrlType, String>, void> trailerUrl;

  final Stream<List<Category>> fetchCategory$;
  final Stream<List<Person>> showSearch$;
  final Stream<ButtonState> stateStream$;
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
    @required this.stateStream$,
    @required this.trailerUrlStream$,
    @required this.posterUrlStream$,
    @required Function0<void> dispose,
  }) : super(dispose);

  factory MovieUploadBloc(MovieRepository repository) {
    final uploadMovieSubject = PublishSubject<MovieUploadInput>();
    final posterTypeUrlSubject =
        BehaviorSubject.seeded(Tuple2(UrlType.FILE, ''));
    final trailerTypeUrlSubject =
        BehaviorSubject.seeded(Tuple2(UrlType.FILE, ''));
    final loadCategorySubject = BehaviorSubject.seeded(0);
    final loadPersonSubject = PublishSubject<String>();

    final posterStream = posterTypeUrlSubject
        .exhaustMap((value) => Rx.defer(() async* {
              if (value.item1 == UrlType.FILE && value.item2.isNotEmpty) {
                final result = await repository.uploadUrl(value.item2);
                yield Tuple2(value.item1, result);
              } else {
                yield value;
              }
            }))
        .publish();

    final trailerStream = trailerTypeUrlSubject
        .exhaustMap((value) => Rx.defer(() async* {
              if (value.item1 == UrlType.FILE && value.item2.isNotEmpty) {
                final result = await repository.uploadUrl(value.item2);
                yield Tuple2(value.item1, result);
              } else {
                yield value;
              }
            }))
        .publish();

    final categoryStream = loadCategorySubject
        .flatMap((value) => Rx.defer(() async* {
              final result = await repository.getListCategory();
              yield result;
            }))
        .publish();

    final personStream = loadPersonSubject
        .where((event) => event.isNotEmpty)
        .debounceTime(Duration(milliseconds: 300))
        .exhaustMap((value) => Rx.defer(() async* {
              print('##### value:  ' + value);
              final result = await repository.getListSearchPerson(value);
              yield result;
            }))
        .publish();

    final uploadStream = uploadMovieSubject
        .where((e) => e.isHasData())
        .exhaustMap(
          (input) => Rx.defer(() async* {
            yield ButtonState.loading;
            final movie = await repository.uploadMovie(input.toMovie());
            if (movie.id != null) {
              yield ButtonState.success;
            } else {
              yield ButtonState.fail;
            }
          }),
        )
        .where((movie) => movie != null)
        .publish();

    final controllers = [
      loadPersonSubject,
      loadCategorySubject,
      uploadMovieSubject,
      posterTypeUrlSubject,
      trailerTypeUrlSubject,
    ];
    final streams = [
      uploadStream.connect(),
      personStream.connect(),
      categoryStream.connect(),
      trailerStream.connect(),
      posterStream.connect(),
    ];
    return MovieUploadBloc._(
      dispose: DisposeBag([...controllers, ...streams]).dispose,
      loadCategory: loadCategorySubject.add,
      loadPerson: loadPersonSubject.add,
      uploadMovie: uploadMovieSubject.add,
      fetchCategory$: categoryStream,
      showSearch$: personStream,
      stateStream$: uploadStream,
      trailerUrl: trailerTypeUrlSubject.add,
      posterUrl: posterTypeUrlSubject.add,
      trailerUrlStream$: trailerStream,
      posterUrlStream$: posterStream,
    );
  }
}
