// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a vi locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'vi';

  static String m0(msg) => "Thêm card không thành công: ${msg}";

  static String m1(message) => "Thêm nhận xét không thành công: ${message}";

  static String m2(error) => "Lỗi khi thay đổi ngôn ngữ: ${error}";

  static String m3(message) => "Thanh toán không thành công: ${message}";

  static String m4(title) => "Xóa không thành công: ${title}...";

  static String m5(title) => "Đã xóa thành công: ${title}...";

  static String m6(movies) =>
      "${Intl.plural(movies, other: '${movies} bộ phim')}";

  static String m7(minute) => "${minute} phút";

  static String m8(message) => "Xảy ra lỗi: ${message}";

  static String m9(msg) => "Lỗi khi đăng nhập Facebook: ${msg}";

  static String m10(title) => "Loại bỏ không thành công: ${title}";

  static String m11(title) => "Loại bỏ thành công: ${title}";

  static String m12(msg) => "Đăng nhập Google không thành công: ${msg}";

  static String m13(msg) => "Lỗi đăng nhập: ${msg}";

  static String m14(message) => "Đăng xuất không thành công: ${message}";

  static String m15(d) => "Đến: ${d}";

  static String m16(d) => "Từ: ${d}";

  static String m17(msg) => "Đăng ký lỗi: ${msg}";

  static String m18(last4, msg) => "Xóa \'${last4}\' không thành công: ${msg}";

  static String m19(last4) => "Xóa thành công: \'${last4}\'";

  static String m20(msg) => "Đặt lại lỗi mật khẩu: ${msg}";

  static String m21(seats) => "${Intl.plural(seats, other: 'ghế')}";

  static String m22(last4) => "Đã chọn \'••••${last4}\'. Nhấn để thay đổi";

  static String m23(message) =>
      "Thêm/xoá yêu thích không thành công: ${message}";

  static String m24(totalFavorite) =>
      "${Intl.plural(totalFavorite, other: '${totalFavorite} yêu thích')}";

  static String m25(totalRate) =>
      "${Intl.plural(totalRate, other: '${totalRate} đánh giá')}";

  static String m26(msg) => "Cập nhật không thành công: ${msg}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "ADDCARD": MessageLookupByLibrary.simpleMessage("THÊM CARD"),
        "CONTINUE": MessageLookupByLibrary.simpleMessage("TIẾP TỤC"),
        "DESCRIPTION": MessageLookupByLibrary.simpleMessage("GIỚI THIỆU"),
        "FINISH": MessageLookupByLibrary.simpleMessage("HOÀN THÀNH"),
        "LOGIN": MessageLookupByLibrary.simpleMessage("ĐĂNG NHẬP"),
        "OFF": MessageLookupByLibrary.simpleMessage("GIẢM GIÁ"),
        "REGISTER": MessageLookupByLibrary.simpleMessage("ĐĂNG KÝ"),
        "RESET_PASSWORD":
            MessageLookupByLibrary.simpleMessage("ĐẶT LẠI MẬT KHẨU"),
        "SCREEN": MessageLookupByLibrary.simpleMessage("MÀN HÌNH"),
        "UPDATE": MessageLookupByLibrary.simpleMessage("CẬP NHẬT"),
        "addCard": MessageLookupByLibrary.simpleMessage("Thêm card"),
        "addCardFailed": m0,
        "addComment": MessageLookupByLibrary.simpleMessage("Thêm bình luận"),
        "addCommentFailureMessage": m1,
        "addCommentSuccessfully":
            MessageLookupByLibrary.simpleMessage("Thêm bình luận thành công"),
        "addedCardSuccessfully":
            MessageLookupByLibrary.simpleMessage("Thêm card thành công"),
        "address": MessageLookupByLibrary.simpleMessage("Địa chỉ"),
        "ageType": MessageLookupByLibrary.simpleMessage("Loại tuổi"),
        "apply": MessageLookupByLibrary.simpleMessage("Áp dụng"),
        "areYouSureYouWantToDeleteThisNotification":
            MessageLookupByLibrary.simpleMessage(
                "Bạn có muốn xóa thông báo này?"),
        "areYouSureYouWantToLogout":
            MessageLookupByLibrary.simpleMessage("Bạn có muốn đăng xuất?"),
        "areYouSureYouWantToRemoveCard":
            MessageLookupByLibrary.simpleMessage("Bạn có muốn xóa card không?"),
        "available": MessageLookupByLibrary.simpleMessage("Còn trống"),
        "baseOn": MessageLookupByLibrary.simpleMessage("Dựa vào "),
        "birthday": MessageLookupByLibrary.simpleMessage("Ngày sinh"),
        "cancel": MessageLookupByLibrary.simpleMessage("Hủy"),
        "cannotOpenTrailerVideo": MessageLookupByLibrary.simpleMessage(
            "Không thể mở video giới thiệu"),
        "cardHolderName": MessageLookupByLibrary.simpleMessage("Tên chủ thẻ"),
        "cardNumber": MessageLookupByLibrary.simpleMessage("Số thẻ"),
        "cards": MessageLookupByLibrary.simpleMessage("Cards"),
        "castOverview": MessageLookupByLibrary.simpleMessage("DIỄN VIÊN"),
        "change_language":
            MessageLookupByLibrary.simpleMessage("Thay đổi ngôn ngữ"),
        "change_language_error": m2,
        "change_language_failure":
            MessageLookupByLibrary.simpleMessage("Lỗi khi thay đổi ngôn ngữ"),
        "change_language_success": MessageLookupByLibrary.simpleMessage(
            "Thay đổi ngôn ngữ thành công"),
        "checkYourMail":
            MessageLookupByLibrary.simpleMessage("Kiểm tra email: "),
        "checkout": MessageLookupByLibrary.simpleMessage("Thanh toán"),
        "checkoutFailedGeterrormessagemessageerror": m3,
        "checkoutSuccessfullyPleaseCheckEmailToGetTicket":
            MessageLookupByLibrary.simpleMessage(
                "Thanh toán thành công. Vui lòng kiểm tra email để nhận vé"),
        "combo": MessageLookupByLibrary.simpleMessage("Combo"),
        "coming_soon":
            MessageLookupByLibrary.simpleMessage("PHIM SẮP PHÁT HÀNH"),
        "commentFailedWhenRemovingCommentTitle": m4,
        "commentRemovedSuccessfullyTitle": m5,
        "comments": MessageLookupByLibrary.simpleMessage("Bình luận"),
        "count_movie": m6,
        "couponCode": MessageLookupByLibrary.simpleMessage("Mã giảm giá: "),
        "createYourAccount":
            MessageLookupByLibrary.simpleMessage("Tạo tài khoản"),
        "date": MessageLookupByLibrary.simpleMessage("Ngày"),
        "deleteNotification":
            MessageLookupByLibrary.simpleMessage("Xóa thông báo"),
        "deleteSuccessfully":
            MessageLookupByLibrary.simpleMessage("Xóa thành công"),
        "directors": MessageLookupByLibrary.simpleMessage("ĐẠO DIỄN"),
        "discount": MessageLookupByLibrary.simpleMessage("Giảm giá: "),
        "doYouWantToDeleteThisCommentThisActionCannot":
            MessageLookupByLibrary.simpleMessage(
                "Bạn muốn xóa bình luận này. Hành động này không thể được hoàn tác!"),
        "dontHaveAnAccountSignUp": MessageLookupByLibrary.simpleMessage(
            "Không có tài khoản? Đăng ký ngay"),
        "doubledSeat": MessageLookupByLibrary.simpleMessage("Ghế đôi"),
        "doubledTicket": MessageLookupByLibrary.simpleMessage("Vé đôi"),
        "durationMinsFrom":
            MessageLookupByLibrary.simpleMessage("Độ dài (phút) từ "),
        "duration_minutes": m7,
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailToReceiveTickets":
            MessageLookupByLibrary.simpleMessage("Email để nhận vé"),
        "emptyAddress": MessageLookupByLibrary.simpleMessage("Địa chỉ trống"),
        "emptyCard": MessageLookupByLibrary.simpleMessage("Không có card nào"),
        "emptyComment":
            MessageLookupByLibrary.simpleMessage("Không có bình luận nào"),
        "emptyCouponCode":
            MessageLookupByLibrary.simpleMessage("Không có mã giảm giá"),
        "emptyNotification":
            MessageLookupByLibrary.simpleMessage("Không có thông báo nào"),
        "emptyRelatedMovie":
            MessageLookupByLibrary.simpleMessage("Không có phim liên quan nào"),
        "emptyReservation":
            MessageLookupByLibrary.simpleMessage("Không có đặt chỗ nào"),
        "emptySearchResult":
            MessageLookupByLibrary.simpleMessage("Kết quả tìm kiếm trống"),
        "emptyShowTimes":
            MessageLookupByLibrary.simpleMessage("Không có lịch chiếu"),
        "empty_favorite_movie":
            MessageLookupByLibrary.simpleMessage("Không có phim yêu thích nào"),
        "empty_movie":
            MessageLookupByLibrary.simpleMessage("Không có bộ phim nào"),
        "empty_theatre":
            MessageLookupByLibrary.simpleMessage("Không có rạp nào"),
        "enterYourEmailToResetPassword": MessageLookupByLibrary.simpleMessage(
            "Nhập Email để đặt lại Mật khẩu"),
        "error_with_message": m8,
        "expireDateMmyy":
            MessageLookupByLibrary.simpleMessage("Ngày hết hạn (MM/yy)"),
        "facebookLoginErrorGeterrormessagedeprecatede": m9,
        "fav_removed_failed_with_title": m10,
        "fav_removed_successfully_with_title": m11,
        "favorites": MessageLookupByLibrary.simpleMessage("Yêu thích"),
        "female": MessageLookupByLibrary.simpleMessage("Nữ"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Quên mật khẩu?"),
        "fullName": MessageLookupByLibrary.simpleMessage("Tên đầy đủ"),
        "gender": MessageLookupByLibrary.simpleMessage("Giới tính"),
        "googleSignInFailedGeterrormessagedeprecatede": m12,
        "home": MessageLookupByLibrary.simpleMessage("Trang chủ"),
        "information": MessageLookupByLibrary.simpleMessage("Thông tin"),
        "invalidBirthday":
            MessageLookupByLibrary.simpleMessage("Ngày sinh không hợp lệ"),
        "invalidEmailAddress":
            MessageLookupByLibrary.simpleMessage("Email không hợp lệ"),
        "invalidFullName":
            MessageLookupByLibrary.simpleMessage("Tên không hợp lệ"),
        "invalidInformation":
            MessageLookupByLibrary.simpleMessage("Thông tin không hợp lệ"),
        "invalidPhoneNumber":
            MessageLookupByLibrary.simpleMessage("SĐT không hợp lệ"),
        "lengthOfContentMustBeInFrom10To500":
            MessageLookupByLibrary.simpleMessage("Độ dài phải từ 10 đến 500"),
        "load_image_error": MessageLookupByLibrary.simpleMessage("Lỗi tải ảnh"),
        "loadedAllComments":
            MessageLookupByLibrary.simpleMessage("Đã tải tất cả bình luận"),
        "loadedAllMovies":
            MessageLookupByLibrary.simpleMessage("Đã tải tất cả phim"),
        "loadedAllNotifications":
            MessageLookupByLibrary.simpleMessage("Đã tải tất cả thông báo"),
        "loadedAllReservations":
            MessageLookupByLibrary.simpleMessage("Đã tải tất cả đặt chỗ"),
        "loading": MessageLookupByLibrary.simpleMessage("Đang tải..."),
        "loggedOutSuccessfully":
            MessageLookupByLibrary.simpleMessage("Đăng xuất thành công"),
        "loginErrorGeterrormessagedeprecatederror": m13,
        "loginSuccessfully":
            MessageLookupByLibrary.simpleMessage("Đăng nhập thành công"),
        "loginToYourAccount": MessageLookupByLibrary.simpleMessage("Đăng nhập"),
        "logoutFailed": m14,
        "logoutOut": MessageLookupByLibrary.simpleMessage("Đăng xuất"),
        "male": MessageLookupByLibrary.simpleMessage("Nam"),
        "maximumComboCount": MessageLookupByLibrary.simpleMessage(
            "Đã đạt số lượng combo tối đa"),
        "missingRequiredFields": MessageLookupByLibrary.simpleMessage(
            "Thiếu các thông tin bắt buộc"),
        "most_favorite":
            MessageLookupByLibrary.simpleMessage("ĐƯỢC YÊU THÍCH NHẤT"),
        "most_rate": MessageLookupByLibrary.simpleMessage("ĐƯỢC ĐÁNH GIÁ CAO"),
        "movies_on_theatre":
            MessageLookupByLibrary.simpleMessage("Phim Đang Chiếu"),
        "mustBeAfterMinReleasedDate": MessageLookupByLibrary.simpleMessage(
            "Phải sau ngày phát hành tối thiểu"),
        "mustBeBeforeMaxReleasedDate": MessageLookupByLibrary.simpleMessage(
            "Phải trước ngày phát hành tối đa"),
        "mustBeGreaterThanOrEqualToMinDuration":
            MessageLookupByLibrary.simpleMessage(
                "Phải lớn hơn hoặc bằng độ dài tối thiểu"),
        "mustBeLessThanOrEqualToMaxDuration":
            MessageLookupByLibrary.simpleMessage(
                "Phải nhỏ hơn hoặc bằng độ dài tối đa"),
        "mustSelectAtLeastOneSeat": MessageLookupByLibrary.simpleMessage(
            "Phải chọn ít nhất một chỗ ngồi"),
        "myTicket": MessageLookupByLibrary.simpleMessage("Vé của tôi"),
        "myTicket_room": MessageLookupByLibrary.simpleMessage("Phòng"),
        "myTicket_theatre": MessageLookupByLibrary.simpleMessage("Rạp"),
        "nationwide": MessageLookupByLibrary.simpleMessage("Toàn quốc"),
        "nearby_theatre":
            MessageLookupByLibrary.simpleMessage("RẠP PHIM GẦN ĐÂY"),
        "networkError": MessageLookupByLibrary.simpleMessage("Lỗi mạng"),
        "noInternetConnection":
            MessageLookupByLibrary.simpleMessage("Không có kết nối Internet"),
        "normalTicket": MessageLookupByLibrary.simpleMessage("Vé thường"),
        "notLoggedIn": MessageLookupByLibrary.simpleMessage("Chưa đăng nhập"),
        "notifications": MessageLookupByLibrary.simpleMessage("Thông báo"),
        "onlyUserRoleIsAllowed":
            MessageLookupByLibrary.simpleMessage("Chỉ cho phép vai trò USER"),
        "orderId": MessageLookupByLibrary.simpleMessage("ID đặt chỗ"),
        "originalPrice": MessageLookupByLibrary.simpleMessage("Giá gốc: "),
        "password": MessageLookupByLibrary.simpleMessage("Mật khẩu"),
        "passwordMustBeAtLeast6Characters":
            MessageLookupByLibrary.simpleMessage("Mật khẩu ít nhất 6 kí tự"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("Số điện thoại"),
        "phoneNumberToReceiveTickets":
            MessageLookupByLibrary.simpleMessage("Số điện thoại nhận vé"),
        "profile": MessageLookupByLibrary.simpleMessage("Tài khoản"),
        "promotionEnd": m15,
        "promotionStart": m16,
        "recommended_for_you":
            MessageLookupByLibrary.simpleMessage("GỢI Ý CHO BẠN"),
        "registerError": m17,
        "registerSuccessfullyPleaseCheckYourEmailInboxToVerifyThis":
            MessageLookupByLibrary.simpleMessage(
                "Đăng ký thành công. Vui lòng kiểm tra hộp thư email của bạn để xác minh tài khoản này."),
        "relatedMovies": MessageLookupByLibrary.simpleMessage("PHIM LIÊN QUAN"),
        "releasedDateFrom":
            MessageLookupByLibrary.simpleMessage("Ngày phát hành từ "),
        "remove": MessageLookupByLibrary.simpleMessage("Loại bỏ"),
        "removeCard": MessageLookupByLibrary.simpleMessage("Xóa card"),
        "removeMsgcardlast4FailedGeterrormessagemsgerror": m18,
        "removeThisComment":
            MessageLookupByLibrary.simpleMessage("Xóa bình luận này"),
        "removedSuccessMsgremovedlast4": m19,
        "requiredUpdatingYourProfile":
            MessageLookupByLibrary.simpleMessage("Cần cập nhật hồ sơ của bạn"),
        "resetPasswordErrorMsg": m20,
        "resetSuccessfullyPleaseCheckYourEmailToResetPassword":
            MessageLookupByLibrary.simpleMessage(
                "Thành công. Vui lòng kiểm tra email của bạn để đặt lại mật khẩu!"),
        "retry": MessageLookupByLibrary.simpleMessage("Thử lại"),
        "reviews": MessageLookupByLibrary.simpleMessage(" đánh giá"),
        "room": MessageLookupByLibrary.simpleMessage(" Phòng: "),
        "searchFilter": MessageLookupByLibrary.simpleMessage("Bộ lọc tìm kiếm"),
        "seat_s": m21,
        "select": MessageLookupByLibrary.simpleMessage("Đã chọn"),
        "selectCouponCode":
            MessageLookupByLibrary.simpleMessage("Chọn mã giảm giá"),
        "selectDiscountCode":
            MessageLookupByLibrary.simpleMessage("Chọn mã giảm giá"),
        "selectOrAddACard":
            MessageLookupByLibrary.simpleMessage("Chọn hoặc thêm card"),
        "selectTheArea": MessageLookupByLibrary.simpleMessage("Chọn khu vực: "),
        "select_city": MessageLookupByLibrary.simpleMessage("Chọn thành phố"),
        "selected": MessageLookupByLibrary.simpleMessage("Đã chọn"),
        "selectedCardlast4TapToChange": m22,
        "showTimes": MessageLookupByLibrary.simpleMessage("Lịch chiếu"),
        "showtimeEndTimeMustBeAfterStartTime":
            MessageLookupByLibrary.simpleMessage(
                "Thời gian kết thúc suất chiếu phải sau thời gian bắt đầu"),
        "showtimeStartFrom":
            MessageLookupByLibrary.simpleMessage("Thời gian chiếu bắt đầu từ "),
        "showtimeStartTimeMustBeBeforeEndTime":
            MessageLookupByLibrary.simpleMessage(
                "Thời gian bắt đầu chiếu phải trước thời gian kết thúc"),
        "slowInternetConnection":
            MessageLookupByLibrary.simpleMessage("Kết nối internet chậm"),
        "someSeatsYouChooseHaveBeenReservedPleaseSelectOther":
            MessageLookupByLibrary.simpleMessage(
                "Một số chỗ bạn chọn đã được đặt trước. Vui lòng chọn chỗ ngồi khác."),
        "startAt": MessageLookupByLibrary.simpleMessage("Bắt đầu lúc: "),
        "storyline": MessageLookupByLibrary.simpleMessage("NỘI DUNG"),
        "taken": MessageLookupByLibrary.simpleMessage("Đã đặt"),
        "theatre": MessageLookupByLibrary.simpleMessage("Rạp: "),
        "tickets": MessageLookupByLibrary.simpleMessage("Vé"),
        "time": MessageLookupByLibrary.simpleMessage("Thời gian"),
        "timeOutToHoldTheSeatPleaseMakeYourReservation":
            MessageLookupByLibrary.simpleMessage(
                "Hết giờ giữ chỗ. Vui lòng đặt chỗ trong vòng 5 phút!"),
        "timeout": MessageLookupByLibrary.simpleMessage("Hết thời gian"),
        "title": MessageLookupByLibrary.simpleMessage("Tiêu đề phim"),
        "to": MessageLookupByLibrary.simpleMessage(" đến "),
        "today": MessageLookupByLibrary.simpleMessage("Hôm nay"),
        "toggleFailed": m23,
        "toggledSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Thêm/xoá yêu thích thành công"),
        "totalPrice": MessageLookupByLibrary.simpleMessage("Tổng tiền: "),
        "total_favorite": m24,
        "total_rate_review": m25,
        "updateProfile":
            MessageLookupByLibrary.simpleMessage("Cập nhật thông tin"),
        "updateProfileFailedMsg": m26,
        "updateProfileSuccessfully":
            MessageLookupByLibrary.simpleMessage("Cập nhật thành công"),
        "view_all": MessageLookupByLibrary.simpleMessage("Xem tất cả"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "yourAccountEmailHasNotBeenVerifyPleaseVerifyTo":
            MessageLookupByLibrary.simpleMessage(
                "Email tài khoản của bạn chưa được xác minh. Vui lòng xác minh để tiếp tục!"),
        "yourComment":
            MessageLookupByLibrary.simpleMessage("Bình luận của bạn..."),
        "yourReservations":
            MessageLookupByLibrary.simpleMessage("Đặt chỗ của bạn"),
        "yourThinkAboutThisMovie": MessageLookupByLibrary.simpleMessage(
            "Suy nghĩ của bạn về bộ phim này?")
      };
}
