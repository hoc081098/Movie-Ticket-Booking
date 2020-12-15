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

  static m0(message) => "Thêm nhận xét không thành công: ${message}";

  static m1(error) => "Lỗi khi thay đổi ngôn ngữ: ${error}";

  static m2(title) => "Xóa không thành công: ${title}...";

  static m3(title) => "Đã xóa thành công: ${title}...";

  static m4(minute) => "${minute} phút";

  static m5(message) => "Xảy ra lỗi: ${message}";

  static m6(title) => "Loại bỏ không thành công: ${title}";

  static m7(title) => "Loại bỏ thành công: ${title}";

  static m8(message) => "Đăng xuất không thành công: ${message}";

  static m9(message) => "Thêm/xoá yêu thích không thành công: ${message}";

  static m10(totalFavorite) => "${Intl.plural(totalFavorite, other: '${totalFavorite} yêu thích')}";

  static m11(totalRate) => "${Intl.plural(totalRate, other: '${totalRate} đánh giá')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "addComment" : MessageLookupByLibrary.simpleMessage("Thêm bình luận"),
    "addCommentFailureMessage" : m0,
    "addCommentSuccessfully" : MessageLookupByLibrary.simpleMessage("Thêm bình luận thành công"),
    "address" : MessageLookupByLibrary.simpleMessage("Địa chỉ"),
    "areYouSureYouWantToDeleteThisNotification" : MessageLookupByLibrary.simpleMessage("Bạn có muốn xóa thông báo này?"),
    "areYouSureYouWantToLogout" : MessageLookupByLibrary.simpleMessage("Bạn có muốn đăng xuất?"),
    "baseOn" : MessageLookupByLibrary.simpleMessage("Dựa vào "),
    "birthday" : MessageLookupByLibrary.simpleMessage("Ngày sinh"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Hủy"),
    "cannotOpenTrailerVideo" : MessageLookupByLibrary.simpleMessage("Không thể mở video giới thiệu"),
    "castOverview" : MessageLookupByLibrary.simpleMessage("DIỄN VIÊN"),
    "change_language" : MessageLookupByLibrary.simpleMessage("Thay đổi ngôn ngữ"),
    "change_language_error" : m1,
    "change_language_failure" : MessageLookupByLibrary.simpleMessage("Lỗi khi thay đổi ngôn ngữ"),
    "change_language_success" : MessageLookupByLibrary.simpleMessage("Thay đổi ngôn ngữ thành công"),
    "checkYourMail" : MessageLookupByLibrary.simpleMessage("Kiểm tra email: "),
    "coming_soon" : MessageLookupByLibrary.simpleMessage("PHIM SẮP PHÁT HÀNH"),
    "commentFailedWhenRemovingCommentTitle" : m2,
    "commentRemovedSuccessfullyTitle" : m3,
    "comments" : MessageLookupByLibrary.simpleMessage("Bình luận"),
    "couponCode" : MessageLookupByLibrary.simpleMessage("Mã giảm giá: "),
    "date" : MessageLookupByLibrary.simpleMessage("Ngày"),
    "deleteNotification" : MessageLookupByLibrary.simpleMessage("Xóa thông báo"),
    "deleteSuccessfully" : MessageLookupByLibrary.simpleMessage("Xóa thành công"),
    "directors" : MessageLookupByLibrary.simpleMessage("ĐẠO DIỄN"),
    "discount" : MessageLookupByLibrary.simpleMessage("Giảm giá: "),
    "doYouWantToDeleteThisCommentThisActionCannot" : MessageLookupByLibrary.simpleMessage("Bạn muốn xóa bình luận này. Hành động này không thể được hoàn tác!"),
    "duration_minutes" : m4,
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "emptyComment" : MessageLookupByLibrary.simpleMessage("Không có bình luận nào"),
    "emptyNotification" : MessageLookupByLibrary.simpleMessage("Không có thông báo nào"),
    "emptyRelatedMovie" : MessageLookupByLibrary.simpleMessage("Không có phim liên quan nào"),
    "emptyReservation" : MessageLookupByLibrary.simpleMessage("Không có đặt chỗ nào"),
    "emptyShowTimes" : MessageLookupByLibrary.simpleMessage("Không có lịch chiếu"),
    "empty_favorite_movie" : MessageLookupByLibrary.simpleMessage("Không có phim yêu thích nào"),
    "empty_movie" : MessageLookupByLibrary.simpleMessage("Không có bộ phim nào"),
    "empty_theatre" : MessageLookupByLibrary.simpleMessage("Không có rạp nào"),
    "error_with_message" : m5,
    "fav_removed_failed_with_title" : m6,
    "fav_removed_successfully_with_title" : m7,
    "favorites" : MessageLookupByLibrary.simpleMessage("Yêu thích"),
    "fullName" : MessageLookupByLibrary.simpleMessage("Tên đầy đủ"),
    "gender" : MessageLookupByLibrary.simpleMessage("Giới tính"),
    "home" : MessageLookupByLibrary.simpleMessage("Trang chủ"),
    "information" : MessageLookupByLibrary.simpleMessage("Thông tin"),
    "load_image_error" : MessageLookupByLibrary.simpleMessage("Lỗi tải ảnh"),
    "loadedAllComments" : MessageLookupByLibrary.simpleMessage("Đã tải tất cả bình luận"),
    "loadedAllNotifications" : MessageLookupByLibrary.simpleMessage("Đã tải tất cả thông báo"),
    "loadedAllReservations" : MessageLookupByLibrary.simpleMessage("Đã tải tất cả đặt chỗ"),
    "loggedOutSuccessfully" : MessageLookupByLibrary.simpleMessage("Đăng xuất thành công"),
    "logoutFailed" : m8,
    "logoutOut" : MessageLookupByLibrary.simpleMessage("Đăng xuất"),
    "most_favorite" : MessageLookupByLibrary.simpleMessage("ĐƯỢC YÊU THÍCH NHẤT"),
    "most_rate" : MessageLookupByLibrary.simpleMessage("ĐƯỢC ĐÁNH GIÁ CAO"),
    "movies_on_theatre" : MessageLookupByLibrary.simpleMessage("Phim Đang Chiếu"),
    "myTicket" : MessageLookupByLibrary.simpleMessage("Vé của tôi"),
    "myTicket_room" : MessageLookupByLibrary.simpleMessage("Phòng"),
    "myTicket_theatre" : MessageLookupByLibrary.simpleMessage("Rạp"),
    "nationwide" : MessageLookupByLibrary.simpleMessage("Toàn quốc"),
    "nearby_theatre" : MessageLookupByLibrary.simpleMessage("RẠP PHIM GẦN ĐÂY"),
    "networkError" : MessageLookupByLibrary.simpleMessage("Lỗi mạng"),
    "noInternetConnection" : MessageLookupByLibrary.simpleMessage("Không có kết nối Internet"),
    "notLoggedIn" : MessageLookupByLibrary.simpleMessage("Chưa đăng nhập"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Thông báo"),
    "onlyUserRoleIsAllowed" : MessageLookupByLibrary.simpleMessage("Chỉ cho phép vai trò USER"),
    "orderId" : MessageLookupByLibrary.simpleMessage("ID đặt chỗ"),
    "originalPrice" : MessageLookupByLibrary.simpleMessage("Giá gốc: "),
    "phoneNumber" : MessageLookupByLibrary.simpleMessage("Số điện thoại"),
    "profile" : MessageLookupByLibrary.simpleMessage("Tài khoản"),
    "recommended_for_you" : MessageLookupByLibrary.simpleMessage("GỢI Ý CHO BẠN"),
    "relatedMovies" : MessageLookupByLibrary.simpleMessage("PHIM LIÊN QUAN"),
    "remove" : MessageLookupByLibrary.simpleMessage("Loại bỏ"),
    "removeThisComment" : MessageLookupByLibrary.simpleMessage("Xóa bình luận này"),
    "requiredUpdatingYourProfile" : MessageLookupByLibrary.simpleMessage("Cần cập nhật hồ sơ của bạn"),
    "reviews" : MessageLookupByLibrary.simpleMessage(" đánh giá"),
    "room" : MessageLookupByLibrary.simpleMessage(" Phòng: "),
    "selectTheArea" : MessageLookupByLibrary.simpleMessage("Chọn khu vực: "),
    "select_city" : MessageLookupByLibrary.simpleMessage("Chọn thành phố"),
    "showTimes" : MessageLookupByLibrary.simpleMessage("Lịch chiếu"),
    "slowInternetConnection" : MessageLookupByLibrary.simpleMessage("Kết nối internet chậm"),
    "startAt" : MessageLookupByLibrary.simpleMessage("Bắt đầu lúc: "),
    "storyline" : MessageLookupByLibrary.simpleMessage("NỘI DUNG"),
    "theatre" : MessageLookupByLibrary.simpleMessage("Rạp: "),
    "tickets" : MessageLookupByLibrary.simpleMessage("Vé"),
    "time" : MessageLookupByLibrary.simpleMessage("Thời gian"),
    "title" : MessageLookupByLibrary.simpleMessage("Tiêu đề phim"),
    "today" : MessageLookupByLibrary.simpleMessage("Hôm nay"),
    "toggleFailed" : m9,
    "toggledSuccessfully" : MessageLookupByLibrary.simpleMessage("Thêm/xoá yêu thích thành công"),
    "totalPrice" : MessageLookupByLibrary.simpleMessage("Tổng tiền: "),
    "total_favorite" : m10,
    "total_rate_review" : m11,
    "view_all" : MessageLookupByLibrary.simpleMessage("Xem tất cả"),
    "yourAccountEmailHasNotBeenVerifyPleaseVerifyTo" : MessageLookupByLibrary.simpleMessage("Email tài khoản của bạn chưa được xác minh. Vui lòng xác minh để tiếp tục!"),
    "yourComment" : MessageLookupByLibrary.simpleMessage("Bình luận của bạn..."),
    "yourReservations" : MessageLookupByLibrary.simpleMessage("Đặt chỗ của bạn"),
    "yourThinkAboutThisMovie" : MessageLookupByLibrary.simpleMessage("Suy nghĩ của bạn về bộ phim này?")
  };
}
