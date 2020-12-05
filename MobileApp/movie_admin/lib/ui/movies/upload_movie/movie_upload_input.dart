import 'package:meta/meta.dart';
import '../../../domain/model/age_type.dart';
import '../../../domain/model/category.dart';
import '../../../domain/model/movie.dart';
import '../../../domain/model/person.dart';
import 'movie_upload_bloc.dart';

class MovieUploadInput {
  MovieUploadInput._({
    @required this.title,
    @required this.trailerVideoUrl,
    @required this.posterUrl,
    @required this.overview,
    @required this.releasedDate,
    @required this.duration,
    @required this.directors,
    @required this.actors,
    @required this.originalLanguage,
    @required this.ageType,
    @required this.categorys,
  });

  factory MovieUploadInput.init() {
    return MovieUploadInput._(
      title: null,
      trailerVideoUrl: '',
      posterUrl: '',
      overview: '',
      releasedDate: '',
      duration: 0,
      directors: [],
      actors: [],
      originalLanguage: 'en',
      ageType: AgeType.P,
      categorys: [],
    );
  }

  String title;
  String trailerVideoUrl;
  String posterUrl;
  String overview;
  String releasedDate;
  int duration;
  List<Person> directors;
  List<Person> actors;
  String originalLanguage;
  AgeType ageType;
  List<Category> categorys;

  Movie toMovie() {
    return Movie(
      id: null,
      isActive: null,
      title: title,
      trailerVideoUrl: trailerVideoUrl,
      posterUrl: posterUrl,
      overview: overview,
      releasedDate: DateTime.parse(releasedDate).toLocal(),
      duration: duration,
      originalLanguage: originalLanguage,
      createdAt: null,
      updatedAt: null,
      ageType: ageType,
      actors: actors,
      directors: directors,
      categories: categorys,
      rateStar: null,
      totalFavorite: null,
      totalRate: null,
    );
  }

  bool isHasData() =>
      title.isNotEmpty &&
      trailerVideoUrl.isNotEmpty &&
      posterUrl.isNotEmpty &&
      overview.isNotEmpty &&
      releasedDate != null &&
      duration != 0 &&
      directors.isNotEmpty &&
      ageType != null &&
      actors.isNotEmpty &&
      categorys.isNotEmpty;
}

class MovieUploadState {
  MovieUploadState._({
    @required this.title,
    @required this.trailerVideoUrl,
    @required this.posterUrl,
    @required this.overview,
    @required this.releasedDate,
    @required this.duration,
    @required this.directors,
    @required this.actors,
    @required this.originalLanguage,
    @required this.ageType,
    @required this.categorys,
    @required this.typeUrlTrailer,
    @required this.typeUrlPoster,
  });

  factory MovieUploadState.init() {
    return MovieUploadState._(
      title: '',
      trailerVideoUrl: '',
      posterUrl: '',
      overview: '',
      releasedDate: DateTime(2020),
      duration: 0,
      directors: [],
      actors: [],
      originalLanguage: '',
      ageType: AgeType.P,
      categorys: [],
      typeUrlPoster: UrlType.FILE,
      typeUrlTrailer: UrlType.FILE,
    );
  }

  String title;
  String trailerVideoUrl;
  String posterUrl;
  String overview;
  DateTime releasedDate;
  int duration;
  List<Person> directors;
  List<Person> actors;
  String originalLanguage;
  AgeType ageType;
  List<Category> categorys;
  UrlType typeUrlPoster;
  UrlType typeUrlTrailer;
}
