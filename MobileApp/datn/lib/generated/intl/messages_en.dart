// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(msg) => "Add card failed: ${msg}";

  static String m1(message) => "Add comment failed: ${message}";

  static String m2(error) => "Error when change language: ${error}";

  static String m3(message) => "Checkout failed: ${message}";

  static String m4(title) => "Failed when removing comment: ${title}...";

  static String m5(title) => "Removed successfully: ${title}...";

  static String m6(movies) =>
      "${Intl.plural(movies, zero: '0 movie', one: '1 movie', other: '${movies} movies')}";

  static String m7(minute) => "${minute} minutes";

  static String m8(message) => "Error occurred: ${message}";

  static String m9(msg) => "Facebook login error: ${msg}";

  static String m10(title) => "Removed failed: ${title}";

  static String m11(title) => "Removed successfully: ${title}";

  static String m12(msg) => "Google sign in failed: ${msg}";

  static String m13(msg) => "Login error: ${msg}";

  static String m14(message) => "Logout failed: ${message}";

  static String m15(d) => "End: ${d}";

  static String m16(d) => "Start: ${d}";

  static String m17(msg) => "Register error: ${msg}";

  static String m18(last4, msg) => "Remove \'${last4}\' failed: ${msg}";

  static String m19(last4) => "Removed success: \'${last4}\'";

  static String m20(msg) => "Reset password error: ${msg}";

  static String m21(seats) =>
      "${Intl.plural(seats, zero: 'seat', one: 'seat', other: 'seats')}";

  static String m22(last4) => "Selected \'••••${last4}\'. Tap to change";

  static String m23(message) => "Toggle failed: ${message}";

  static String m24(totalFavorite) =>
      "${Intl.plural(totalFavorite, zero: '0 favorite', one: '1 favorite', other: '${totalFavorite} favorites')}";

  static String m25(totalRate) =>
      "${Intl.plural(totalRate, zero: '0 review', one: '1 review', other: '${totalRate} reviews')}";

  static String m26(msg) => "Update profile failed: ${msg}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "ADDCARD": MessageLookupByLibrary.simpleMessage("ADD CARD"),
        "CONTINUE": MessageLookupByLibrary.simpleMessage("CONTINUE"),
        "DESCRIPTION": MessageLookupByLibrary.simpleMessage("DESCRIPTION"),
        "FINISH": MessageLookupByLibrary.simpleMessage("FINISH"),
        "LOGIN": MessageLookupByLibrary.simpleMessage("LOGIN"),
        "OFF": MessageLookupByLibrary.simpleMessage("OFF"),
        "REGISTER": MessageLookupByLibrary.simpleMessage("REGISTER"),
        "RESET_PASSWORD":
            MessageLookupByLibrary.simpleMessage("RESET PASSWORD"),
        "SCREEN": MessageLookupByLibrary.simpleMessage("SCREEN"),
        "UPDATE": MessageLookupByLibrary.simpleMessage("UPDATE"),
        "addCard": MessageLookupByLibrary.simpleMessage("Add card"),
        "addCardFailed": m0,
        "addComment": MessageLookupByLibrary.simpleMessage("Add comment"),
        "addCommentFailureMessage": m1,
        "addCommentSuccessfully":
            MessageLookupByLibrary.simpleMessage("Add comment successfully"),
        "addedCardSuccessfully":
            MessageLookupByLibrary.simpleMessage("Added card successfully"),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "ageType": MessageLookupByLibrary.simpleMessage("Age type"),
        "apply": MessageLookupByLibrary.simpleMessage("Apply"),
        "areYouSureYouWantToDeleteThisNotification":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to delete this notification?"),
        "areYouSureYouWantToLogout": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to logout?"),
        "areYouSureYouWantToRemoveCard": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to remove card"),
        "available": MessageLookupByLibrary.simpleMessage("Available"),
        "baseOn": MessageLookupByLibrary.simpleMessage("Based on "),
        "birthday": MessageLookupByLibrary.simpleMessage("Birthday"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cannotOpenTrailerVideo":
            MessageLookupByLibrary.simpleMessage("Cannot open trailer video"),
        "cardHolderName":
            MessageLookupByLibrary.simpleMessage("Card holder name"),
        "cardNumber": MessageLookupByLibrary.simpleMessage("Card number"),
        "cards": MessageLookupByLibrary.simpleMessage("Cards"),
        "castOverview": MessageLookupByLibrary.simpleMessage("CAST OVERVIEW"),
        "change_language":
            MessageLookupByLibrary.simpleMessage("Change language"),
        "change_language_error": m2,
        "change_language_failure":
            MessageLookupByLibrary.simpleMessage("Error when change language"),
        "change_language_success": MessageLookupByLibrary.simpleMessage(
            "Change language successfully"),
        "checkYourMail":
            MessageLookupByLibrary.simpleMessage("Check your mail: "),
        "checkout": MessageLookupByLibrary.simpleMessage("Checkout"),
        "checkoutFailedGeterrormessagemessageerror": m3,
        "checkoutSuccessfullyPleaseCheckEmailToGetTicket":
            MessageLookupByLibrary.simpleMessage(
                "Checkout successfully. Please check email to get ticket"),
        "combo": MessageLookupByLibrary.simpleMessage("Combo"),
        "coming_soon": MessageLookupByLibrary.simpleMessage("COMING SOON"),
        "commentFailedWhenRemovingCommentTitle": m4,
        "commentRemovedSuccessfullyTitle": m5,
        "comments": MessageLookupByLibrary.simpleMessage("Comments"),
        "count_movie": m6,
        "couponCode": MessageLookupByLibrary.simpleMessage("Coupon code: "),
        "createYourAccount":
            MessageLookupByLibrary.simpleMessage("Create your Account"),
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "deleteNotification":
            MessageLookupByLibrary.simpleMessage("Delete notification"),
        "deleteSuccessfully":
            MessageLookupByLibrary.simpleMessage("Delete successfully"),
        "directors": MessageLookupByLibrary.simpleMessage("DIRECTORS"),
        "discount": MessageLookupByLibrary.simpleMessage("Discount: "),
        "doYouWantToDeleteThisCommentThisActionCannot":
            MessageLookupByLibrary.simpleMessage(
                "Do you want to delete this comment. This action cannot be undone!"),
        "dontHaveAnAccountSignUp": MessageLookupByLibrary.simpleMessage(
            "Don\'t have an account? Sign up"),
        "doubledSeat": MessageLookupByLibrary.simpleMessage("Doubled seat"),
        "doubledTicket": MessageLookupByLibrary.simpleMessage("Doubled ticket"),
        "durationMinsFrom":
            MessageLookupByLibrary.simpleMessage("Duration (mins) from "),
        "duration_minutes": m7,
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailToReceiveTickets":
            MessageLookupByLibrary.simpleMessage("Email to receive tickets"),
        "emptyAddress": MessageLookupByLibrary.simpleMessage("Empty address"),
        "emptyCard": MessageLookupByLibrary.simpleMessage("Empty card"),
        "emptyComment": MessageLookupByLibrary.simpleMessage("Empty comment"),
        "emptyCouponCode":
            MessageLookupByLibrary.simpleMessage("Empty coupon code"),
        "emptyNotification":
            MessageLookupByLibrary.simpleMessage("Empty notification"),
        "emptyRelatedMovie":
            MessageLookupByLibrary.simpleMessage("Empty related movie"),
        "emptyReservation":
            MessageLookupByLibrary.simpleMessage("Empty reservation"),
        "emptySearchResult":
            MessageLookupByLibrary.simpleMessage("Empty search result"),
        "emptyShowTimes":
            MessageLookupByLibrary.simpleMessage("Empty show times"),
        "empty_favorite_movie":
            MessageLookupByLibrary.simpleMessage("Empty favorite movie"),
        "empty_movie": MessageLookupByLibrary.simpleMessage("Empty movie"),
        "empty_theatre": MessageLookupByLibrary.simpleMessage("Empty theatre"),
        "enterYourEmailToResetPassword": MessageLookupByLibrary.simpleMessage(
            "Enter your Email to reset Password"),
        "error_with_message": m8,
        "expireDateMmyy":
            MessageLookupByLibrary.simpleMessage("Expire date (MM/yy)"),
        "facebookLoginErrorGeterrormessagedeprecatede": m9,
        "fav_removed_failed_with_title": m10,
        "fav_removed_successfully_with_title": m11,
        "favorites": MessageLookupByLibrary.simpleMessage("Favorites"),
        "female": MessageLookupByLibrary.simpleMessage("Female"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot password?"),
        "fullName": MessageLookupByLibrary.simpleMessage("Full name"),
        "gender": MessageLookupByLibrary.simpleMessage("Gender"),
        "googleSignInFailedGeterrormessagedeprecatede": m12,
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "information": MessageLookupByLibrary.simpleMessage("Information"),
        "invalidBirthday":
            MessageLookupByLibrary.simpleMessage("Invalid birthday"),
        "invalidEmailAddress":
            MessageLookupByLibrary.simpleMessage("Invalid email address"),
        "invalidFullName":
            MessageLookupByLibrary.simpleMessage("Invalid full name"),
        "invalidInformation":
            MessageLookupByLibrary.simpleMessage("Invalid information"),
        "invalidPhoneNumber":
            MessageLookupByLibrary.simpleMessage("Invalid phone number"),
        "lengthOfContentMustBeInFrom10To500":
            MessageLookupByLibrary.simpleMessage(
                "Length of content must be in from 10 to 500"),
        "load_image_error":
            MessageLookupByLibrary.simpleMessage("Load image error"),
        "loadedAllComments":
            MessageLookupByLibrary.simpleMessage("Loaded all comments"),
        "loadedAllMovies":
            MessageLookupByLibrary.simpleMessage("Loaded all movies"),
        "loadedAllNotifications":
            MessageLookupByLibrary.simpleMessage("Loaded all notifications"),
        "loadedAllReservations":
            MessageLookupByLibrary.simpleMessage("Loaded all reservations"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "loggedOutSuccessfully":
            MessageLookupByLibrary.simpleMessage("Logged out successfully"),
        "loginErrorGeterrormessagedeprecatederror": m13,
        "loginSuccessfully":
            MessageLookupByLibrary.simpleMessage("Login successfully"),
        "loginToYourAccount":
            MessageLookupByLibrary.simpleMessage("Login to your Account"),
        "logoutFailed": m14,
        "logoutOut": MessageLookupByLibrary.simpleMessage("Logout out"),
        "male": MessageLookupByLibrary.simpleMessage("Male"),
        "maximumComboCount":
            MessageLookupByLibrary.simpleMessage("Maximum combo count"),
        "missingRequiredFields":
            MessageLookupByLibrary.simpleMessage("Missing required fields"),
        "most_favorite": MessageLookupByLibrary.simpleMessage("MOST FAVORITE"),
        "most_rate": MessageLookupByLibrary.simpleMessage("MOST RATE"),
        "movies_on_theatre":
            MessageLookupByLibrary.simpleMessage("Movies on Theatre"),
        "mustBeAfterMinReleasedDate": MessageLookupByLibrary.simpleMessage(
            "Must be after min released date"),
        "mustBeBeforeMaxReleasedDate": MessageLookupByLibrary.simpleMessage(
            "Must be before max released date"),
        "mustBeGreaterThanOrEqualToMinDuration":
            MessageLookupByLibrary.simpleMessage(
                "Must be greater than or equal to min duration"),
        "mustBeLessThanOrEqualToMaxDuration":
            MessageLookupByLibrary.simpleMessage(
                "Must be less than or equal to max duration"),
        "mustSelectAtLeastOneSeat": MessageLookupByLibrary.simpleMessage(
            "Must select at least one seat"),
        "myTicket": MessageLookupByLibrary.simpleMessage("My ticket"),
        "myTicket_room": MessageLookupByLibrary.simpleMessage("Room"),
        "myTicket_theatre": MessageLookupByLibrary.simpleMessage("Theatre"),
        "nationwide": MessageLookupByLibrary.simpleMessage("Nationwide"),
        "nearby_theatre":
            MessageLookupByLibrary.simpleMessage("NEARBY THEATRES"),
        "networkError": MessageLookupByLibrary.simpleMessage("Network error"),
        "noInternetConnection":
            MessageLookupByLibrary.simpleMessage("No internet connection"),
        "normalTicket": MessageLookupByLibrary.simpleMessage("Normal ticket"),
        "notLoggedIn": MessageLookupByLibrary.simpleMessage("Not logged in"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "onlyUserRoleIsAllowed":
            MessageLookupByLibrary.simpleMessage("Only USER role is allowed"),
        "orderId": MessageLookupByLibrary.simpleMessage("Order ID"),
        "originalPrice":
            MessageLookupByLibrary.simpleMessage("Original price: "),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordMustBeAtLeast6Characters":
            MessageLookupByLibrary.simpleMessage(
                "Password must be at least 6 characters"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone number"),
        "phoneNumberToReceiveTickets": MessageLookupByLibrary.simpleMessage(
            "Phone number to receive tickets"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "promotionEnd": m15,
        "promotionStart": m16,
        "recommended_for_you":
            MessageLookupByLibrary.simpleMessage("RECOMMENDED FOR YOU"),
        "registerError": m17,
        "registerSuccessfullyPleaseCheckYourEmailInboxToVerifyThis":
            MessageLookupByLibrary.simpleMessage(
                "Register successfully. Please check your email inbox to verify this account."),
        "relatedMovies": MessageLookupByLibrary.simpleMessage("RELATED MOVIES"),
        "releasedDateFrom":
            MessageLookupByLibrary.simpleMessage("Released date from "),
        "remove": MessageLookupByLibrary.simpleMessage("Remove"),
        "removeCard": MessageLookupByLibrary.simpleMessage("Remove card"),
        "removeMsgcardlast4FailedGeterrormessagemsgerror": m18,
        "removeThisComment":
            MessageLookupByLibrary.simpleMessage("Remove this comment"),
        "removedSuccessMsgremovedlast4": m19,
        "requiredUpdatingYourProfile": MessageLookupByLibrary.simpleMessage(
            "Required updating your profile"),
        "resetPasswordErrorMsg": m20,
        "resetSuccessfullyPleaseCheckYourEmailToResetPassword":
            MessageLookupByLibrary.simpleMessage(
                "Reset successfully. Please check your email to reset password!"),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "reviews": MessageLookupByLibrary.simpleMessage(" reviews"),
        "room": MessageLookupByLibrary.simpleMessage(" Room: "),
        "searchFilter": MessageLookupByLibrary.simpleMessage("Search filter"),
        "seat_s": m21,
        "select": MessageLookupByLibrary.simpleMessage("Select"),
        "selectCouponCode":
            MessageLookupByLibrary.simpleMessage("Select coupon code"),
        "selectDiscountCode":
            MessageLookupByLibrary.simpleMessage("Select discount code"),
        "selectOrAddACard":
            MessageLookupByLibrary.simpleMessage("Select or add a card"),
        "selectTheArea":
            MessageLookupByLibrary.simpleMessage("Select the area: "),
        "select_city": MessageLookupByLibrary.simpleMessage("Select city"),
        "selected": MessageLookupByLibrary.simpleMessage("Selected"),
        "selectedCardlast4TapToChange": m22,
        "showTimes": MessageLookupByLibrary.simpleMessage("Show times"),
        "showtimeEndTimeMustBeAfterStartTime":
            MessageLookupByLibrary.simpleMessage(
                "Showtime end time must be after start time"),
        "showtimeStartFrom":
            MessageLookupByLibrary.simpleMessage("Showtime start from "),
        "showtimeStartTimeMustBeBeforeEndTime":
            MessageLookupByLibrary.simpleMessage(
                "Showtime start time must be before end time"),
        "slowInternetConnection":
            MessageLookupByLibrary.simpleMessage("Slow internet connection"),
        "someSeatsYouChooseHaveBeenReservedPleaseSelectOther":
            MessageLookupByLibrary.simpleMessage(
                "Some seats you choose have been reserved. Please select other seats."),
        "startAt": MessageLookupByLibrary.simpleMessage("Start at: "),
        "storyline": MessageLookupByLibrary.simpleMessage("STORYLINE"),
        "taken": MessageLookupByLibrary.simpleMessage("Taken"),
        "theatre": MessageLookupByLibrary.simpleMessage("Theatre: "),
        "tickets": MessageLookupByLibrary.simpleMessage("Tickets"),
        "time": MessageLookupByLibrary.simpleMessage("Time"),
        "timeOutToHoldTheSeatPleaseMakeYourReservation":
            MessageLookupByLibrary.simpleMessage(
                "Time out to hold the seat. Please make your reservation within 5 minutes!"),
        "timeout": MessageLookupByLibrary.simpleMessage("Timeout"),
        "title": MessageLookupByLibrary.simpleMessage("Title"),
        "to": MessageLookupByLibrary.simpleMessage(" to "),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "toggleFailed": m23,
        "toggledSuccessfully":
            MessageLookupByLibrary.simpleMessage("Toggled successfully"),
        "totalPrice": MessageLookupByLibrary.simpleMessage("Total price: "),
        "total_favorite": m24,
        "total_rate_review": m25,
        "updateProfile": MessageLookupByLibrary.simpleMessage("Update profile"),
        "updateProfileFailedMsg": m26,
        "updateProfileSuccessfully":
            MessageLookupByLibrary.simpleMessage("Update profile successfully"),
        "view_all": MessageLookupByLibrary.simpleMessage("VIEW ALL"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "yourAccountEmailHasNotBeenVerifyPleaseVerifyTo":
            MessageLookupByLibrary.simpleMessage(
                "Your account email has not been verify. Please verify to continue!"),
        "yourComment": MessageLookupByLibrary.simpleMessage("Your comment..."),
        "yourReservations":
            MessageLookupByLibrary.simpleMessage("Your reservations"),
        "yourThinkAboutThisMovie":
            MessageLookupByLibrary.simpleMessage("Your thoughts on this movie?")
      };
}
