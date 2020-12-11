import 'dart:io';

import 'package:built_collection/src/list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart' as uuid;

import '../../domain/model/category.dart';
import '../../domain/model/exception.dart';
import '../../domain/model/movie.dart';
import '../../domain/model/person.dart';
import '../../domain/repository/movie_repository.dart';
import '../mappers.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/category_response.dart';
import '../remote/response/error_response.dart';
import '../remote/response/movie_response.dart';
import '../remote/response/person_response.dart';

class MovieRepositoryImpl implements MovieRepository {
  final AuthClient _authClient;

  MovieRepositoryImpl(this._authClient);

  @override
  Future<List<Movie>> getListMovie(int page, int perPage) async {
    try {
      final usersRes = await _authClient.getBody(buildUrl(
          'admin_movies/', {'page': '$page', 'per_page': '$perPage'})) as List;
      return usersRes
          .map((json) => movieRemoteToDomain(MovieResponse.fromJson(json)))
          .toList();
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedManagerUserException();
      }
      rethrow;
    }
  }

  @override
  Future<void> uploadMovie(Movie movie) async {
    try {
      final movieRes = await _authClient.postBody(
        buildUrl('admin_movies/'),
        body: movieDomainToRemote(movie).toJson(),
      );
      print(movieRes);
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedManagerUserException();
      }
      rethrow;
    }
  }

  @override
  Future<List<Person>> getListSearchPerson(String name) async {
    try {
      final res = await _authClient
          .getBody(buildUrl('people/search/', {'name': name})) as List;
      return res
          .map((e) => PersonResponse.fromJson(e))
          .map((e) => personResponseToPerson(e))
          .toList();
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedManagerUserException();
      }
      rethrow;
    }
  }

  @override
  Future<List<Category>> getListCategory() async {
    try {
      final res = await _authClient.getBody(buildUrl('categories/')) as List;
      return res
          .map((e) => CategoryResponse.fromJson(e))
          .map((e) => categoryResponseToCategory(e))
          .toList();
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedManagerUserException();
      }
      rethrow;
    }
  }

  @override
  Future<String> uploadUrl(String path, [bool isVideo]) async {
    try {
      final task = FirebaseStorage.instance
          .ref()
          .child('movies')
          .child(uuid.Uuid().v4())
          .putFile(
            File(path),
            identical(isVideo, true)
                ? SettableMetadata(
                    contentType: 'video/mp4',
                  )
                : null,
          );
      await task;
      return await task.snapshot.ref.getDownloadURL();
    } on PlatformException catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<BuiltList<Movie>> search(String title) async {
    final usersRes = await _authClient.getBody(
      buildUrl(
        '/admin_movies/search',
        {'title': title},
      ),
    ) as List;
    return usersRes
        .map((json) => SearchMovieRes.fromJson(json))
        .map(searchMovieResToDomain)
        .toBuiltList();
  }
}

Movie searchMovieResToDomain(SearchMovieRes r) {
  return Movie(
    id: r.id,
    isActive: r.isActive ?? true,
    title: r.title,
    trailerVideoUrl: r.trailerVideoUrl,
    posterUrl: r.posterUrl,
    overview: r.overview,
    releasedDate: DateTime.parse(r.releasedDate).toLocal(),
    duration: r.duration,
    originalLanguage: r.originalLanguage,
    createdAt: DateTime.parse(r.createdAt).toLocal(),
    updatedAt: DateTime.parse(r.updatedAt).toLocal(),
    ageType: r.ageType.ageType(),
    actors: null,
    directors: null,
    categories: null,
    rateStar: r.rateStar,
    totalFavorite: r.totalFavorite,
    totalRate: r.totalRate,
  );
}

class SearchMovieRes {
  bool isActive;
  String ageType;
  List<String> actors;
  List<String> directors;
  String title;
  String trailerVideoUrl;
  String posterUrl;
  String overview;
  String releasedDate;
  int duration;
  String originalLanguage;
  String createdAt;
  String updatedAt;
  double rateStar;
  int totalFavorite;
  int totalRate;
  String id;

  SearchMovieRes(
      {this.isActive,
      this.ageType,
      this.actors,
      this.directors,
      this.title,
      this.trailerVideoUrl,
      this.posterUrl,
      this.overview,
      this.releasedDate,
      this.duration,
      this.originalLanguage,
      this.createdAt,
      this.updatedAt,
      this.rateStar,
      this.totalFavorite,
      this.totalRate,
      this.id});

  SearchMovieRes.fromJson(Map<String, dynamic> json) {
    isActive = json['is_active'];
    ageType = json['age_type'];
    actors = json['actors'].cast<String>();
    directors = json['directors'].cast<String>();
    id = json['_id'];
    title = json['title'];
    trailerVideoUrl = json['trailer_video_url'];
    posterUrl = json['poster_url'];
    overview = json['overview'];
    releasedDate = json['released_date'];
    duration = json['duration'];
    originalLanguage = json['original_language'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    rateStar = (json['rate_star'] as num).toDouble();
    totalFavorite = json['total_favorite'];
    totalRate = json['total_rate'];
  }
}
