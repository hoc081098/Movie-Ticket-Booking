import 'package:datn/data/local/user_local.dart';
import 'package:datn/data/remote/response/user_response.dart';
import 'package:datn/domain/model/location.dart';
import 'package:datn/domain/model/user.dart';
import 'package:datn/utils/type_defs.dart';

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
