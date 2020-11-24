import 'package:meta/meta.dart';
import '../../../domain/model/age_type.dart';
import '../../../domain/model/category.dart';
import '../../../domain/model/movie.dart';
import '../../../domain/model/person.dart';

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

  factory MovieUploadInput.init() {
    return MovieUploadInput._(
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
    );
  }

  Movie toMovie() {
    return Movie(
      id: null,
      isActive: null,
      title: title,
      trailerVideoUrl: trailerVideoUrl,
      posterUrl: posterUrl,
      overview: overview,
      releasedDate: releasedDate,
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
