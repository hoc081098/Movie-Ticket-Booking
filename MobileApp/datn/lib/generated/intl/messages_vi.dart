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

  static m0(msg) => "Thêm card không thành công: ${msg}";

  static m1(message) => "Thêm nhận xét không thành công: ${message}";

  static m2(error) => "Lỗi khi thay đổi ngôn ngữ: ${error}";

  static m3(message) => "Thanh toán không thành công: ${message}";

  static m4(title) => "Xóa không thành công: ${title}...";

  static m5(title) => "Đã xóa thành công: ${title}...";

  static m6(minute) => "${minute} phút";

  static m7(message) => "Xảy ra lỗi: ${message}";

  static m8(title) => "Loại bỏ không thành công: ${title}";

  static m9(title) => "Loại bỏ thành công: ${title}";

  static m10(message) => "Đăng xuất không thành công: ${message}";

  static m11(last4, msg) => "Xóa \'${last4}\' không thành công: ${msg}";

  static m12(last4) => "Xóa thành công: \'${last4}\'";

  static m13(seats) => "${Intl.plural(seats, other: 'ghế')}";

  static m14(last4) => "Đã chọn \'••••${last4}\'. Nhấn để thay đổi";

  static m15(message) => "Thêm/xoá yêu thích không thành công: ${message}";

  static m16(totalFavorite) => "${Intl.plural(totalFavorite, other: '${totalFavorite} yêu thích')}";

  static m17(totalRate) => "${Intl.plural(totalRate, other: '${totalRate} đánh giá')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "ADDCARD" : MessageLookupByLibrary.simpleMessage("THÊM CARD"),
    "CONTINUE" : MessageLookupByLibrary.simpleMessage("TIẾP TỤC"),
    "FINISH" : MessageLookupByLibrary.simpleMessage("HOÀN THÀNH"),
    "OFF" : MessageLookupByLibrary.simpleMessage("GIẢM GIÁ"),
    "SCREEN" : MessageLookupByLibrary.simpleMessage("MÀN HÌNH"),
    "addCard" : MessageLookupByLibrary.simpleMessage("Thêm card"),
    "addCardFailed" : m0,
    "addComment" : MessageLookupByLibrary.simpleMessage("Thêm bình luận"),
    "addCommentFailureMessage" : m1,
    "addCommentSuccessfully" : MessageLookupByLibrary.simpleMessage("Thêm bình luận thành công"),
    "addedCardSuccessfully" : MessageLookupByLibrary.simpleMessage("Thêm card thành công"),
    "address" : MessageLookupByLibrary.simpleMessage("Địa chỉ"),
    "areYouSureYouWantToDeleteThisNotification" : MessageLookupByLibrary.simpleMessage("Bạn có muốn xóa thông báo này?"),
    "areYouSureYouWantToLogout" : MessageLookupByLibrary.simpleMessage("Bạn có muốn đăng xuất?"),
    "areYouSureYouWantToRemoveCard" : MessageLookupByLibrary.simpleMessage("Bạn có muốn xóa card không?"),
    "available" : MessageLookupByLibrary.simpleMessage("Còn trống"),
    "baseOn" : MessageLookupByLibrary.simpleMessage("Dựa vào "),
    "birthday" : MessageLookupByLibrary.simpleMessage("Ngày sinh"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Hủy"),
    "cannotOpenTrailerVideo" : MessageLookupByLibrary.simpleMessage("Không thể mở video giới thiệu"),
    "cardHolderName" : MessageLookupByLibrary.simpleMessage("Tên chủ thẻ"),
    "cardNumber" : MessageLookupByLibrary.simpleMessage("Số thẻ"),
    "castOverview" : MessageLookupByLibrary.simpleMessage("DIỄN VIÊN"),
    "change_language" : MessageLookupByLibrary.simpleMessage("Thay đổi ngôn ngữ"),
    "change_language_error" : m2,
    "change_language_failure" : MessageLookupByLibrary.simpleMessage("Lỗi khi thay đổi ngôn ngữ"),
    "change_language_success" : MessageLookupByLibrary.simpleMessage("Thay đổi ngôn ngữ thành công"),
    "checkYourMail" : MessageLookupByLibrary.simpleMessage("Kiểm tra email: "),
    "checkout" : MessageLookupByLibrary.simpleMessage("Thanh toán"),
    "checkoutFailedGeterrormessagemessageerror" : m3,
    "checkoutSuccessfullyPleaseCheckEmailToGetTicket" : MessageLookupByLibrary.simpleMessage("Thanh toán thành công. Vui lòng kiểm tra email để nhận vé"),
    "combo" : MessageLookupByLibrary.simpleMessage("Combo"),
    "coming_soon" : MessageLookupByLibrary.simpleMessage("PHIM SẮP PHÁT HÀNH"),
    "commentFailedWhenRemovingCommentTitle" : m4,
    "commentRemovedSuccessfullyTitle" : m5,
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
    "duration_minutes" : m6,
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "emailToReceiveTickets" : MessageLookupByLibrary.simpleMessage("Email để nhận vé"),
    "emptyCard" : MessageLookupByLibrary.simpleMessage("Không có card nào"),
    "emptyComment" : MessageLookupByLibrary.simpleMessage("Không có bình luận nào"),
    "emptyNotification" : MessageLookupByLibrary.simpleMessage("Không có thông báo nào"),
    "emptyRelatedMovie" : MessageLookupByLibrary.simpleMessage("Không có phim liên quan nào"),
    "emptyReservation" : MessageLookupByLibrary.simpleMessage("Không có đặt chỗ nào"),
    "emptyShowTimes" : MessageLookupByLibrary.simpleMessage("Không có lịch chiếu"),
    "empty_favorite_movie" : MessageLookupByLibrary.simpleMessage("Không có phim yêu thích nào"),
    "empty_movie" : MessageLookupByLibrary.simpleMessage("Không có bộ phim nào"),
    "empty_theatre" : MessageLookupByLibrary.simpleMessage("Không có rạp nào"),
    "error_with_message" : m7,
    "expireDateMmyy" : MessageLookupByLibrary.simpleMessage("Ngày hết hạn (MM/yy)"),
    "fav_removed_failed_with_title" : m8,
    "fav_removed_successfully_with_title" : m9,
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
    "logoutFailed" : m10,
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
    "removeCard" : MessageLookupByLibrary.simpleMessage("Xóa card"),
    "removeMsgcardlast4FailedGeterrormessagemsgerror" : m11,
    "removeThisComment" : MessageLookupByLibrary.simpleMessage("Xóa bình luận này"),
    "removedSuccessMsgremovedlast4" : m12,
    "requiredUpdatingYourProfile" : MessageLookupByLibrary.simpleMessage("Cần cập nhật hồ sơ của bạn"),
    "retry" : MessageLookupByLibrary.simpleMessage("Thử lại"),
    "reviews" : MessageLookupByLibrary.simpleMessage(" đánh giá"),
    "room" : MessageLookupByLibrary.simpleMessage(" Phòng: "),
    "seat_s" : m13,
    "select" : MessageLookupByLibrary.simpleMessage("Đã chọn"),
    "selectDiscountCode" : MessageLookupByLibrary.simpleMessage("Chọn mã giảm giá"),
    "selectOrAddACard" : MessageLookupByLibrary.simpleMessage("Chọn hoặc thêm card"),
    "selectTheArea" : MessageLookupByLibrary.simpleMessage("Chọn khu vực: "),
    "select_city" : MessageLookupByLibrary.simpleMessage("Chọn thành phố"),
    "selected" : MessageLookupByLibrary.simpleMessage("Đã chọn"),
    "selectedCardlast4TapToChange" : m14,
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
    "toggleFailed" : m15,
    "toggledSuccessfully" : MessageLookupByLibrary.simpleMessage("Thêm/xoá yêu thích thành công"),
    "totalPrice" : MessageLookupByLibrary.simpleMessage("Tổng tiền: "),
    "total_favorite" : m16,
    "total_rate_review" : m17,
    "view_all" : MessageLookupByLibrary.simpleMessage("Xem tất cả"),
    "warning" : MessageLookupByLibrary.simpleMessage("Warning"),
    "yourAccountEmailHasNotBeenVerifyPleaseVerifyTo" : MessageLookupByLibrary.simpleMessage("Email tài khoản của bạn chưa được xác minh. Vui lòng xác minh để tiếp tục!"),
    "yourComment" : MessageLookupByLibrary.simpleMessage("Bình luận của bạn..."),
    "yourReservations" : MessageLookupByLibrary.simpleMessage("Đặt chỗ của bạn"),
    "yourThinkAboutThisMovie" : MessageLookupByLibrary.simpleMessage("Suy nghĩ của bạn về bộ phim này?")
  };
}
