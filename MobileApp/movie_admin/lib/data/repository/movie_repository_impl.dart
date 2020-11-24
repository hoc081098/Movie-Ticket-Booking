import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:movie_admin/data/remote/request/movie_request.dart';
import 'package:movie_admin/data/remote/response/category_response.dart';
import 'package:movie_admin/data/remote/response/person_response.dart';
import 'package:movie_admin/domain/model/category.dart';
import 'package:movie_admin/domain/model/person.dart';
import 'package:movie_admin/domain/model/user.dart';

import '../../domain/model/exception.dart';
import '../../domain/model/movie.dart';
import '../../domain/repository/movie_repository.dart';
import '../mappers.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/error_response.dart';
import '../remote/response/movie_response.dart';

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
  Future<Movie> uploadMovie(Movie movie) async {
    try {
      final movieRes = await _authClient.postBody(
        buildUrl('admin_movies/'),
        body: movieDomainToRemote(movie).toJson(),
      ) as Map<String, dynamic>;
      return movieRemoteToDomain(MovieResponse.fromJson(movieRes));
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
      final res = _authClient
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
  Future<List<Category>> getListCategory(String name) async {
    try {
      final res = _authClient.getBody(buildUrl('categories/')) as List;
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
  Future<String> uploadUrl(String path) async {
    try {
      final task = FirebaseStorage.instance
          .ref()
          .child('trailer_images')
          .child(path + '_movie_admin')
          .putFile(File(path));
      await task.onComplete;
      if (task.isSuccessful) {
        return (await task.lastSnapshot.ref.getDownloadURL()).toString();
      }
      throw const NotCompletedManagerUserException();
    } on PlatformException catch (e) {
      rethrow;
    }
  }
}
