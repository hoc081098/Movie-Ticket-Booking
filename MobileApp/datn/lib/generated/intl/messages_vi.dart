// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a vi locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'vi';

  static m0(error) => "Lỗi khi thay đổi ngôn ngữ: ${error}";

  static m1(minute) => "${minute} phút";

  static m2(message) => "Xảy ra lỗi: ${message}";

  static m3(title) => "Loại bỏ không thành công: ${title}";

  static m4(title) => "Loại bỏ thành công: ${title}";

  static m5(message) => "Đăng xuất không thành công: ${message}";

  static m6(totalFavorite) => "${Intl.plural(totalFavorite, other: '${totalFavorite} yêu thích')}";

  static m7(totalRate) => "${Intl.plural(totalRate, other: '${totalRate} đánh giá')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "address" : MessageLookupByLibrary.simpleMessage("Địa chỉ"),
    "areYouSureYouWantToDeleteThisNotification" : MessageLookupByLibrary.simpleMessage("Bạn có muốn xóa thông báo này?"),
    "areYouSureYouWantToLogout" : MessageLookupByLibrary.simpleMessage("Bạn có muốn đăng xuất?"),
    "birthday" : MessageLookupByLibrary.simpleMessage("Ngày sinh"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Hủy"),
    "change_language" : MessageLookupByLibrary.simpleMessage("Thay đổi ngôn ngữ"),
    "change_language_error" : m0,
    "change_language_failure" : MessageLookupByLibrary.simpleMessage("Lỗi khi thay đổi ngôn ngữ"),
    "change_language_success" : MessageLookupByLibrary.simpleMessage("Thay đổi ngôn ngữ thành công"),
    "coming_soon" : MessageLookupByLibrary.simpleMessage("PHIM SẮP PHÁT HÀNH"),
    "couponCode" : MessageLookupByLibrary.simpleMessage("Mã giảm giá: "),
    "deleteNotification" : MessageLookupByLibrary.simpleMessage("Xóa thông báo"),
    "deleteSuccessfully" : MessageLookupByLibrary.simpleMessage("Xóa thành công"),
    "discount" : MessageLookupByLibrary.simpleMessage("Giảm giá: "),
    "duration_minutes" : m1,
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "emptyNotification" : MessageLookupByLibrary.simpleMessage("Không có thông báo nào"),
    "emptyReservation" : MessageLookupByLibrary.simpleMessage("Không có đặt chỗ nào"),
    "empty_favorite_movie" : MessageLookupByLibrary.simpleMessage("Không có phim yêu thích nào"),
    "empty_movie" : MessageLookupByLibrary.simpleMessage("Không có bộ phim nào"),
    "empty_theatre" : MessageLookupByLibrary.simpleMessage("Không có rạp nào"),
    "error_with_message" : m2,
    "fav_removed_failed_with_title" : m3,
    "fav_removed_successfully_with_title" : m4,
    "favorites" : MessageLookupByLibrary.simpleMessage("Yêu thích"),
    "fullName" : MessageLookupByLibrary.simpleMessage("Tên đầy đủ"),
    "gender" : MessageLookupByLibrary.simpleMessage("Giới tính"),
    "home" : MessageLookupByLibrary.simpleMessage("Trang chủ"),
    "load_image_error" : MessageLookupByLibrary.simpleMessage("Lỗi tải ảnh"),
    "loadedAllNotifications" : MessageLookupByLibrary.simpleMessage("Đã tải tất cả thông báo"),
    "loadedAllReservations" : MessageLookupByLibrary.simpleMessage("Đã tải tất cả đặt chỗ"),
    "logoutFailed" : m5,
    "logoutOut" : MessageLookupByLibrary.simpleMessage("Đăng xuất"),
    "most_favorite" : MessageLookupByLibrary.simpleMessage("ĐƯỢC YÊU THÍCH NHẤT"),
    "most_rate" : MessageLookupByLibrary.simpleMessage("ĐƯỢC ĐÁNH GIÁ CAO"),
    "movies_on_theatre" : MessageLookupByLibrary.simpleMessage("Phim Đang Chiếu"),
    "nationwide" : MessageLookupByLibrary.simpleMessage("Toàn quốc"),
    "nearby_theatre" : MessageLookupByLibrary.simpleMessage("RẠP PHIM GẦN ĐÂY"),
    "networkError" : MessageLookupByLibrary.simpleMessage("Lỗi mạng"),
    "noInternetConnection" : MessageLookupByLibrary.simpleMessage("Không có kết nối Internet"),
    "notLoggedIn" : MessageLookupByLibrary.simpleMessage("Chưa đăng nhập"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Thông báo"),
    "onlyUserRoleIsAllowed" : MessageLookupByLibrary.simpleMessage("Chỉ cho phép vai trò USER"),
    "originalPrice" : MessageLookupByLibrary.simpleMessage("Giá gốc: "),
    "phoneNumber" : MessageLookupByLibrary.simpleMessage("Số điện thoại"),
    "profile" : MessageLookupByLibrary.simpleMessage("Tài khoản"),
    "recommended_for_you" : MessageLookupByLibrary.simpleMessage("GỢI Ý CHO BẠN"),
    "remove" : MessageLookupByLibrary.simpleMessage("Loại bỏ"),
    "requiredUpdatingYourProfile" : MessageLookupByLibrary.simpleMessage("Cần cập nhật hồ sơ của bạn"),
    "room" : MessageLookupByLibrary.simpleMessage(" Phòng: "),
    "select_city" : MessageLookupByLibrary.simpleMessage("Chọn thành phố"),
    "slowInternetConnection" : MessageLookupByLibrary.simpleMessage("Kết nối internet chậm"),
    "startAt" : MessageLookupByLibrary.simpleMessage("Bắt đầu lúc: "),
    "theatre" : MessageLookupByLibrary.simpleMessage("Rạp: "),
    "tickets" : MessageLookupByLibrary.simpleMessage("Vé của bạn"),
    "totalPrice" : MessageLookupByLibrary.simpleMessage("Tổng tiền: "),
    "total_favorite" : m6,
    "total_rate_review" : m7,
    "view_all" : MessageLookupByLibrary.simpleMessage("Xem tất cả"),
    "yourAccountEmailHasNotBeenVerifyPleaseVerifyTo" : MessageLookupByLibrary.simpleMessage("Email tài khoản của bạn chưa được xác minh. Vui lòng xác minh để tiếp tục!"),
    "yourReservations" : MessageLookupByLibrary.simpleMessage("Đặt chỗ của bạn")
  };
}
