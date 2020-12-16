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

  static m2(message) => "Thanh toán không thành công: ${message}";

  static m3(title) => "Xóa không thành công: ${title}...";

  static m4(title) => "Đã xóa thành công: ${title}...";

  static m5(minute) => "${minute} phút";

  static m6(message) => "Xảy ra lỗi: ${message}";

  static m7(title) => "Loại bỏ không thành công: ${title}";

  static m8(title) => "Loại bỏ thành công: ${title}";

  static m9(message) => "Đăng xuất không thành công: ${message}";

  static m10(seats) => "${Intl.plural(seats, other: 'ghế')}";

  static m11(last4) => "Đã chọn \'••••${last4}\'. Nhấn để thay đổi";

  static m12(message) => "Thêm/xoá yêu thích không thành công: ${message}";

  static m13(totalFavorite) => "${Intl.plural(totalFavorite, other: '${totalFavorite} yêu thích')}";

  static m14(totalRate) => "${Intl.plural(totalRate, other: '${totalRate} đánh giá')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "CONTINUE" : MessageLookupByLibrary.simpleMessage("TIẾP TỤC"),
    "FINISH" : MessageLookupByLibrary.simpleMessage("HOÀN THÀNH"),
    "OFF" : MessageLookupByLibrary.simpleMessage("GIẢM GIÁ"),
    "SCREEN" : MessageLookupByLibrary.simpleMessage("MÀN HÌNH"),
    "addComment" : MessageLookupByLibrary.simpleMessage("Thêm bình luận"),
    "addCommentFailureMessage" : m0,
    "addCommentSuccessfully" : MessageLookupByLibrary.simpleMessage("Thêm bình luận thành công"),
    "address" : MessageLookupByLibrary.simpleMessage("Địa chỉ"),
    "areYouSureYouWantToDeleteThisNotification" : MessageLookupByLibrary.simpleMessage("Bạn có muốn xóa thông báo này?"),
    "areYouSureYouWantToLogout" : MessageLookupByLibrary.simpleMessage("Bạn có muốn đăng xuất?"),
    "available" : MessageLookupByLibrary.simpleMessage("Còn trống"),
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
    "checkout" : MessageLookupByLibrary.simpleMessage("Thanh toán"),
    "checkoutFailedGeterrormessagemessageerror" : m2,
    "checkoutSuccessfullyPleaseCheckEmailToGetTicket" : MessageLookupByLibrary.simpleMessage("Thanh toán thành công. Vui lòng kiểm tra email để nhận vé"),
    "combo" : MessageLookupByLibrary.simpleMessage("Combo"),
    "coming_soon" : MessageLookupByLibrary.simpleMessage("PHIM SẮP PHÁT HÀNH"),
    "commentFailedWhenRemovingCommentTitle" : m3,
    "commentRemovedSuccessfullyTitle" : m4,
    "comments" : MessageLookupByLibrary.simpleMessage("Bình luận"),
    "couponCode" : MessageLookupByLibrary.simpleMessage("Mã giảm giá: "),
    "date" : MessageLookupByLibrary.simpleMessage("Ngày"),
    "deleteNotification" : MessageLookupByLibrary.simpleMessage("Xóa thông báo"),
    "deleteSuccessfully" : MessageLookupByLibrary.simpleMessage("Xóa thành công"),
    "directors" : MessageLookupByLibrary.simpleMessage("ĐẠO DIỄN"),
    "discount" : MessageLookupByLibrary.simpleMessage("Giảm giá: "),
    "doYouWantToDeleteThisCommentThisActionCannot" : MessageLookupByLibrary.simpleMessage("Bạn muốn xóa bình luận này. Hành động này không thể được hoàn tác!"),
    "doubledSeat" : MessageLookupByLibrary.simpleMessage("Ghế đôi"),
    "doubledTicket" : MessageLookupByLibrary.simpleMessage("Vé đôi"),
    "duration_minutes" : m5,
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "emailToReceiveTickets" : MessageLookupByLibrary.simpleMessage("Email để nhận vé"),
    "emptyComment" : MessageLookupByLibrary.simpleMessage("Không có bình luận nào"),
    "emptyNotification" : MessageLookupByLibrary.simpleMessage("Không có thông báo nào"),
    "emptyRelatedMovie" : MessageLookupByLibrary.simpleMessage("Không có phim liên quan nào"),
    "emptyReservation" : MessageLookupByLibrary.simpleMessage("Không có đặt chỗ nào"),
    "emptyShowTimes" : MessageLookupByLibrary.simpleMessage("Không có lịch chiếu"),
    "empty_favorite_movie" : MessageLookupByLibrary.simpleMessage("Không có phim yêu thích nào"),
    "empty_movie" : MessageLookupByLibrary.simpleMessage("Không có bộ phim nào"),
    "empty_theatre" : MessageLookupByLibrary.simpleMessage("Không có rạp nào"),
    "error_with_message" : m6,
    "fav_removed_failed_with_title" : m7,
    "fav_removed_successfully_with_title" : m8,
    "favorites" : MessageLookupByLibrary.simpleMessage("Yêu thích"),
    "fullName" : MessageLookupByLibrary.simpleMessage("Tên đầy đủ"),
    "gender" : MessageLookupByLibrary.simpleMessage("Giới tính"),
    "home" : MessageLookupByLibrary.simpleMessage("Trang chủ"),
    "information" : MessageLookupByLibrary.simpleMessage("Thông tin"),
    "invalidEmailAddress" : MessageLookupByLibrary.simpleMessage("Email không hợp lệ"),
    "invalidPhoneNumber" : MessageLookupByLibrary.simpleMessage("SĐT không hợp lệ"),
    "load_image_error" : MessageLookupByLibrary.simpleMessage("Lỗi tải ảnh"),
    "loadedAllComments" : MessageLookupByLibrary.simpleMessage("Đã tải tất cả bình luận"),
    "loadedAllNotifications" : MessageLookupByLibrary.simpleMessage("Đã tải tất cả thông báo"),
    "loadedAllReservations" : MessageLookupByLibrary.simpleMessage("Đã tải tất cả đặt chỗ"),
    "loggedOutSuccessfully" : MessageLookupByLibrary.simpleMessage("Đăng xuất thành công"),
    "logoutFailed" : m9,
    "logoutOut" : MessageLookupByLibrary.simpleMessage("Đăng xuất"),
    "maximumComboCount" : MessageLookupByLibrary.simpleMessage("Đã đạt số lượng combo tối đa"),
    "missingRequiredFields" : MessageLookupByLibrary.simpleMessage("Thiếu các thông tin bắt buộc"),
    "most_favorite" : MessageLookupByLibrary.simpleMessage("ĐƯỢC YÊU THÍCH NHẤT"),
    "most_rate" : MessageLookupByLibrary.simpleMessage("ĐƯỢC ĐÁNH GIÁ CAO"),
    "movies_on_theatre" : MessageLookupByLibrary.simpleMessage("Phim Đang Chiếu"),
    "mustSelectAtLeastOneSeat" : MessageLookupByLibrary.simpleMessage("Phải chọn ít nhất một chỗ ngồi"),
    "myTicket" : MessageLookupByLibrary.simpleMessage("Vé của tôi"),
    "myTicket_room" : MessageLookupByLibrary.simpleMessage("Phòng"),
    "myTicket_theatre" : MessageLookupByLibrary.simpleMessage("Rạp"),
    "nationwide" : MessageLookupByLibrary.simpleMessage("Toàn quốc"),
    "nearby_theatre" : MessageLookupByLibrary.simpleMessage("RẠP PHIM GẦN ĐÂY"),
    "networkError" : MessageLookupByLibrary.simpleMessage("Lỗi mạng"),
    "noInternetConnection" : MessageLookupByLibrary.simpleMessage("Không có kết nối Internet"),
    "normalTicket" : MessageLookupByLibrary.simpleMessage("Vé thường"),
    "notLoggedIn" : MessageLookupByLibrary.simpleMessage("Chưa đăng nhập"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Thông báo"),
    "onlyUserRoleIsAllowed" : MessageLookupByLibrary.simpleMessage("Chỉ cho phép vai trò USER"),
    "orderId" : MessageLookupByLibrary.simpleMessage("ID đặt chỗ"),
    "originalPrice" : MessageLookupByLibrary.simpleMessage("Giá gốc: "),
    "phoneNumber" : MessageLookupByLibrary.simpleMessage("Số điện thoại"),
    "phoneNumberToReceiveTickets" : MessageLookupByLibrary.simpleMessage("Số điện thoại nhận vé"),
    "profile" : MessageLookupByLibrary.simpleMessage("Tài khoản"),
    "recommended_for_you" : MessageLookupByLibrary.simpleMessage("GỢI Ý CHO BẠN"),
    "relatedMovies" : MessageLookupByLibrary.simpleMessage("PHIM LIÊN QUAN"),
    "remove" : MessageLookupByLibrary.simpleMessage("Loại bỏ"),
    "removeThisComment" : MessageLookupByLibrary.simpleMessage("Xóa bình luận này"),
    "requiredUpdatingYourProfile" : MessageLookupByLibrary.simpleMessage("Cần cập nhật hồ sơ của bạn"),
    "reviews" : MessageLookupByLibrary.simpleMessage(" đánh giá"),
    "room" : MessageLookupByLibrary.simpleMessage(" Phòng: "),
    "seat_s" : m10,
    "select" : MessageLookupByLibrary.simpleMessage("Đã chọn"),
    "selectDiscountCode" : MessageLookupByLibrary.simpleMessage("Chọn mã giảm giá"),
    "selectOrAddACard" : MessageLookupByLibrary.simpleMessage("Chọn hoặc thêm card"),
    "selectTheArea" : MessageLookupByLibrary.simpleMessage("Chọn khu vực: "),
    "select_city" : MessageLookupByLibrary.simpleMessage("Chọn thành phố"),
    "selected" : MessageLookupByLibrary.simpleMessage("Đã chọn"),
    "selectedCardlast4TapToChange" : m11,
    "showTimes" : MessageLookupByLibrary.simpleMessage("Lịch chiếu"),
    "slowInternetConnection" : MessageLookupByLibrary.simpleMessage("Kết nối internet chậm"),
    "someSeatsYouChooseHaveBeenReservedPleaseSelectOther" : MessageLookupByLibrary.simpleMessage("Một số chỗ bạn chọn đã được đặt trước. Vui lòng chọn chỗ ngồi khác."),
    "startAt" : MessageLookupByLibrary.simpleMessage("Bắt đầu lúc: "),
    "storyline" : MessageLookupByLibrary.simpleMessage("NỘI DUNG"),
    "taken" : MessageLookupByLibrary.simpleMessage("Đã đặt"),
    "theatre" : MessageLookupByLibrary.simpleMessage("Rạp: "),
    "tickets" : MessageLookupByLibrary.simpleMessage("Vé"),
    "time" : MessageLookupByLibrary.simpleMessage("Thời gian"),
    "timeOutToHoldTheSeatPleaseMakeYourReservation" : MessageLookupByLibrary.simpleMessage("Hết giờ giữ chỗ. Vui lòng đặt chỗ trong vòng 5 phút!"),
    "timeout" : MessageLookupByLibrary.simpleMessage("Hết thời gian"),
    "title" : MessageLookupByLibrary.simpleMessage("Tiêu đề phim"),
    "today" : MessageLookupByLibrary.simpleMessage("Hôm nay"),
    "toggleFailed" : m12,
    "toggledSuccessfully" : MessageLookupByLibrary.simpleMessage("Thêm/xoá yêu thích thành công"),
    "totalPrice" : MessageLookupByLibrary.simpleMessage("Tổng tiền: "),
    "total_favorite" : m13,
    "total_rate_review" : m14,
    "view_all" : MessageLookupByLibrary.simpleMessage("Xem tất cả"),
    "warning" : MessageLookupByLibrary.simpleMessage("Warning"),
    "yourAccountEmailHasNotBeenVerifyPleaseVerifyTo" : MessageLookupByLibrary.simpleMessage("Email tài khoản của bạn chưa được xác minh. Vui lòng xác minh để tiếp tục!"),
    "yourComment" : MessageLookupByLibrary.simpleMessage("Bình luận của bạn..."),
    "yourReservations" : MessageLookupByLibrary.simpleMessage("Đặt chỗ của bạn"),
    "yourThinkAboutThisMovie" : MessageLookupByLibrary.simpleMessage("Suy nghĩ của bạn về bộ phim này?")
  };
}
