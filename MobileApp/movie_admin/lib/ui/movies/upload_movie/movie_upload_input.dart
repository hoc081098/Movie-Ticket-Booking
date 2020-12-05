import 'dart:io';

import 'package:meta/meta.dart';

import '../../../domain/model/age_type.dart';
import '../../../domain/model/category.dart';
import '../../../domain/model/person.dart';
import 'movie_upload_bloc.dart';

class MovieUploadInput {
  factory MovieUploadInput.init() {
    return MovieUploadInput._(
      title: null,
      trailerVideoUrl: '',
      posterUrl: '',
      overview: '',
      releasedDate: null,
      duration: 0,
      directors: [],
      actors: [],
      originalLanguage: 'en',
      ageType: AgeType.P,
      categorys: [],
      posterType: UrlType.FILE,
      posterFile: null,
      trailerFile: null,
      trailerType: UrlType.FILE,
    );
  }

  String title;
  String trailerVideoUrl;
  File trailerFile;
  UrlType trailerType;
  String posterUrl;
  File posterFile;
  UrlType posterType;
  String overview;
  DateTime releasedDate;
  int duration;
  List<Person> directors;
  List<Person> actors;
  String originalLanguage;
  AgeType ageType;
  List<Category> categorys;

  bool isHasData() =>
      title.isNotEmpty &&
      (trailerType == UrlType.FILE
          ? trailerFile != null
          : trailerVideoUrl.isNotEmpty) &&
      (posterType == UrlType.FILE
          ? posterFile != null
          : posterUrl.isNotEmpty) &&
      overview.isNotEmpty &&
      releasedDate != null &&
      duration != null &&
      duration > 0 &&
      directors.isNotEmpty &&
      ageType != null &&
      actors.isNotEmpty &&
      categorys.isNotEmpty;

  @override
  String toString() {
    return 'MovieUploadInput{title: $title, trailerVideoUrl: $trailerVideoUrl, trailerFile: $trailerFile, trailerType: $trailerType, posterUrl: $posterUrl, posterFile: $posterFile, posterType: $posterType, overview: $overview, releasedDate: $releasedDate, duration: $duration, directors: $directors, actors: $actors, originalLanguage: $originalLanguage, ageType: $ageType, categorys: $categorys}';
  }

  MovieUploadInput._({
    @required this.title,
    @required this.trailerVideoUrl,
    @required this.trailerFile,
    @required this.trailerType,
    @required this.posterUrl,
    @required this.posterFile,
    @required this.posterType,
    @required this.overview,
    @required this.releasedDate,
    @required this.duration,
    @required this.directors,
    @required this.actors,
    @required this.originalLanguage,
    @required this.ageType,
    @required this.categorys,
  });
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
