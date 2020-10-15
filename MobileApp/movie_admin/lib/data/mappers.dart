import '../domain/model/location.dart';
import '../domain/model/user.dart';
import 'local/user_local.dart';
import 'remote/response/user_response.dart';

UserLocal userResponseToUserLocal(UserResponse response) {
  return UserLocal(
    uid: response.uid,
    email: response.email,
    phone_number: response.phone_number,
    full_name: response.full_name,
    gender: response.gender,
    avatar: response.avatar,
    address: response.address,
    birthday: response.birthday,
    location: response.location == null
        ? null
        : LocationLocal(
            latitude: response.location.latitude,
            longitude: response.location.longitude,
          ),
    is_completed: response.is_completed,
    is_active: response.is_active ?? true,
  );
}

User userLocalToUserDomain(UserLocal local) {
  return User(
    uid: local.uid,
    email: local.email,
    phoneNumber: local.phone_number,
    fullName: local.full_name,
    gender: stringToGender(local.gender),
    avatar: local.avatar,
    address: local.address,
    birthday: local.birthday,
    location: local.location == null
        ? null
        : Location(
            latitude: local.location.latitude,
            longitude: local.location.longitude,
          ),
    isCompleted: local.is_completed,
    isActive: local.is_active ?? true,
  );
}

Gender stringToGender(String s) {
  if (s == 'MALE') {
    return Gender.MALE;
  }
  if (s == 'FEMALE') {
    return Gender.FEMALE;
  }
  throw Exception("Cannot convert string '$s' to gender");
}

User userResponseToUserDomain(UserResponse response) {
  return User(
    uid: response.uid,
    email: response.email,
    phoneNumber: response.phone_number,
    fullName: response.full_name,
    gender: stringToGender(response.gender),
    avatar: response.avatar,
    address: response.address,
    birthday: response.birthday,
    location: response.location == null
        ? null
        : Location(
            latitude: response.location.latitude,
            longitude: response.location.longitude,
          ),
    isCompleted: response.is_completed,
    isActive: response.is_active ?? true,
  );
}
