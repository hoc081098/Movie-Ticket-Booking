import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../../../domain/model/category.dart';
import '../../../domain/model/movie.dart';
import '../../../domain/model/person.dart';
import '../../../domain/repository/movie_repository.dart';
import '../../../utils/utils.dart';
import '../../widgets/loading_button.dart';
import 'movie_upload_input.dart';

enum UrlType { URL, FILE }

class MovieUploadBloc extends DisposeCallbackBaseBloc {
  final Function1<String, void> loadPerson;
  final Function1<MovieUploadInput, void> uploadMovie;

  final Stream<List<Category>> fetchCategory$;
  final Stream<List<Person>> showSearch$;
  final Stream<ButtonState> stateStream$;
  final Stream<Object> error$;

  MovieUploadBloc._({
    @required this.loadPerson,
    @required this.uploadMovie,
    @required this.fetchCategory$,
    @required this.showSearch$,
    @required this.stateStream$,
    @required this.error$,
    @required Function0<void> dispose,
  }) : super(dispose);

  factory MovieUploadBloc(MovieRepository repository) {
    final uploadMovieSubject = PublishSubject<MovieUploadInput>();
    final loadCategorySubject = BehaviorSubject.seeded('');
    final loadPersonSubject = BehaviorSubject.seeded('');
    final errorS = PublishSubject<String>(sync: true);

    final categoryStream = loadCategorySubject
        .flatMap((value) => Rx.defer(() async* {
              final result = await repository.getListCategory();
              yield result;
            }))
        .publishValue();

    final personStream = loadPersonSubject
        .debounceTime(Duration(milliseconds: 300))
        .distinct((p, e) => p == e)
        .exhaustMap((value) => Rx.defer(() async* {
              if (value.isEmpty) {
                yield <Person>[];
              } else {
                yield null;
                final result = await repository.getListSearchPerson(value);
                yield result;
              }
            }))
        .publish();

    final uploadStream = uploadMovieSubject
        .debug(identifier: '11111111111111111')
        .where((e) => e.isHasData())
        .debug(identifier: '22222222222222')
        .exhaustMap((input) async* {
          yield ButtonState.loading;

          try {
            String poster;
            if (input.posterType == UrlType.FILE) {
              print('Start upload poster: ${input.posterFile}');
              poster = await repository.uploadUrl(input.posterFile.path);
            } else {
              poster = input.posterUrl;
            }

            String trailer;
            if (input.trailerType == UrlType.FILE) {
              print('Start upload trailer: ${input.trailerFile}');
              trailer =
                  await repository.uploadUrl(input.trailerFile.path, true);
            } else {
              trailer = input.trailerVideoUrl;
            }
            await repository.uploadMovie(
              Movie(
                posterUrl: poster,
                trailerVideoUrl: trailer,
                id: null,
                isActive: null,
                title: input.title,
                overview: input.overview,
                releasedDate: input.releasedDate.toUtc(),
                duration: input.duration,
                originalLanguage: input.originalLanguage,
                createdAt: null,
                updatedAt: null,
                ageType: input.ageType,
                actors: input.actors,
                directors: input.directors,
                categories: input.categorys,
                rateStar: null,
                totalFavorite: null,
                totalRate: null,
              ),
            );
            print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>RES');
            yield ButtonState.success;
          } catch (e, s) {
            print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ERROR');
            errorS.add(e);
            print(e);
            print(s);
            yield ButtonState.fail;
          }
        })
        .debug(identifier: '33333333333333333333333')
        .publish();

    final controllers = [
      loadPersonSubject,
      loadCategorySubject,
      uploadMovieSubject,
      errorS,
    ];
    final streams = [
      uploadStream.connect(),
      personStream.connect(),
      categoryStream.connect(),
    ];
    return MovieUploadBloc._(
      dispose: DisposeBag([...controllers, ...streams]).dispose,
      loadPerson: loadPersonSubject.add,
      uploadMovie: uploadMovieSubject.add,
      fetchCategory$: categoryStream,
      showSearch$: personStream,
      stateStream$: uploadStream,
      error$: errorS,
    );
  }
}
