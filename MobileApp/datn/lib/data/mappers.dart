import 'package:datn/domain/model/movie.dart';

import '../domain/model/location.dart';
import '../domain/model/user.dart';
import '../utils/type_defs.dart';
import 'local/user_local.dart';
import 'remote/response/movie_response.dart';
import 'remote/response/user_response.dart';

Function1<UserResponse, UserLocal> userResponseToUserLocal = (response) {
  return UserLocal((b) {
    final locationLocalBuilder = response.location?.latitude != null &&
            response.location?.longitude != null
        ? (LocationLocalBuilder()
          ..latitude = response.location.latitude
          ..longitude = response.location.longitude)
        : null;

    return b
      ..uid = response.uid
      ..email = response.email
      ..phoneNumber = response.phoneNumber
      ..fullName = response.fullName
      ..gender = response.gender
      ..avatar = response.avatar
      ..address = response.address
      ..birthday = response.birthday
      ..location = locationLocalBuilder
      ..isCompleted = response.isCompleted
      ..isActive = response.isActive;
  });
};

Function1<String, Gender> stringToGender = (s) {
  if (s == 'MALE') {
    return Gender.MALE;
  }
  if (s == 'FEMALE') {
    return Gender.FEMALE;
  }
  throw Exception("Cannot convert string '$s' to gender");
};

Function1<UserLocal, User> userLocalToUserDomain = (local) {
  return User((b) => b
    ..uid = local.uid
    ..email = local.email
    ..phoneNumber = local.phoneNumber
    ..fullName = local.fullName
    ..gender = stringToGender(local.gender)
    ..avatar = local.avatar
    ..address = local.address
    ..birthday = local.birthday
    ..location = local.location != null
        ? (LocationBuilder()
          ..latitude = local.location.latitude
          ..longitude = local.location.longitude)
        : null
    ..isCompleted = local.isCompleted
    ..isActive = local.isActive);
};

Function1<MovieResponse, Movie> movieResponseToMovie = (res) {
  return Movie(
    (b) => b
      ..id = res.id
      ..isActive = res.is_active
      ..actors = (b.actors..replace(res.actors))
      ..directors = (b.directors..replace(res.directors))
      ..title = res.title
      ..trailerVideoUrl = res.trailer_video_url
      ..posterUrl = res.poster_url
      ..overview = res.overview
      ..releasedDate = res.released_date
      ..duration = res.duration
      ..originalLanguage = res.original_language
      ..createdAt = res.createdAt
      ..updatedAt = res.updatedAt
      ..ageType = stringToAgeType(res.age_type),
  );
};

Function1<String, AgeType> stringToAgeType = (s) {
  return AgeType.values.firstWhere(
    (v) => v.toString().split('.')[1] == s,
    orElse: () => throw Exception("Cannot convert string '$s' to AgeType"),
  );
};
