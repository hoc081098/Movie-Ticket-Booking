// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m0(msg) => "Add card failed: ${msg}";

  static m1(message) => "Add comment failed: ${message}";

  static m2(error) => "Error when change language: ${error}";

  static m3(message) => "Checkout failed: ${message}";

  static m4(title) => "Failed when removing comment: ${title}...";

  static m5(title) => "Removed successfully: ${title}...";

  static m6(movies) => "${Intl.plural(movies, zero: '0 movie', one: '1 movie', other: '${movies} movies')}";

  static m7(minute) => "${minute} minutes";

  static m8(message) => "Error occurred: ${message}";

  static m9(title) => "Removed failed: ${title}";

  static m10(title) => "Removed successfully: ${title}";

  static m11(message) => "Logout failed: ${message}";

  static m12(d) => "End: ${d}";

  static m13(d) => "Start: ${d}";

  static m14(last4, msg) => "Remove \'${last4}\' failed: ${msg}";

  static m15(last4) => "Removed success: \'${last4}\'";

  static m16(seats) => "${Intl.plural(seats, zero: 'seat', one: 'seat', other: 'seats')}";

  static m17(last4) => "Selected \'••••${last4}\'. Tap to change";

  static m18(message) => "Toggle failed: ${message}";

  static m19(totalFavorite) => "${Intl.plural(totalFavorite, zero: '0 favorite', one: '1 favorite', other: '${totalFavorite} favorites')}";

  static m20(totalRate) => "${Intl.plural(totalRate, zero: '0 review', one: '1 review', other: '${totalRate} reviews')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "ADDCARD" : MessageLookupByLibrary.simpleMessage("ADD CARD"),
    "CONTINUE" : MessageLookupByLibrary.simpleMessage("CONTINUE"),
    "FINISH" : MessageLookupByLibrary.simpleMessage("FINISH"),
    "OFF" : MessageLookupByLibrary.simpleMessage("OFF"),
    "SCREEN" : MessageLookupByLibrary.simpleMessage("SCREEN"),
    "addCard" : MessageLookupByLibrary.simpleMessage("Add card"),
    "addCardFailed" : m0,
    "addComment" : MessageLookupByLibrary.simpleMessage("Add comment"),
    "addCommentFailureMessage" : m1,
    "addCommentSuccessfully" : MessageLookupByLibrary.simpleMessage("Add comment successfully"),
    "addedCardSuccessfully" : MessageLookupByLibrary.simpleMessage("Added card successfully"),
    "address" : MessageLookupByLibrary.simpleMessage("Address"),
    "ageType" : MessageLookupByLibrary.simpleMessage("Age type"),
    "apply" : MessageLookupByLibrary.simpleMessage("Apply"),
    "areYouSureYouWantToDeleteThisNotification" : MessageLookupByLibrary.simpleMessage("Are you sure you want to delete this notification?"),
    "areYouSureYouWantToLogout" : MessageLookupByLibrary.simpleMessage("Are you sure you want to logout?"),
    "areYouSureYouWantToRemoveCard" : MessageLookupByLibrary.simpleMessage("Are you sure you want to remove card"),
    "available" : MessageLookupByLibrary.simpleMessage("Available"),
    "baseOn" : MessageLookupByLibrary.simpleMessage("Based on "),
    "birthday" : MessageLookupByLibrary.simpleMessage("Birthday"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "cannotOpenTrailerVideo" : MessageLookupByLibrary.simpleMessage("Cannot open trailer video"),
    "cardHolderName" : MessageLookupByLibrary.simpleMessage("Card holder name"),
    "cardNumber" : MessageLookupByLibrary.simpleMessage("Card number"),
    "castOverview" : MessageLookupByLibrary.simpleMessage("CAST OVERVIEW"),
    "change_language" : MessageLookupByLibrary.simpleMessage("Change language"),
    "change_language_error" : m2,
    "change_language_failure" : MessageLookupByLibrary.simpleMessage("Error when change language"),
    "change_language_success" : MessageLookupByLibrary.simpleMessage("Change language successfully"),
    "checkYourMail" : MessageLookupByLibrary.simpleMessage("Check your mail: "),
    "checkout" : MessageLookupByLibrary.simpleMessage("Checkout"),
    "checkoutFailedGeterrormessagemessageerror" : m3,
    "checkoutSuccessfullyPleaseCheckEmailToGetTicket" : MessageLookupByLibrary.simpleMessage("Checkout successfully. Please check email to get ticket"),
    "combo" : MessageLookupByLibrary.simpleMessage("Combo"),
    "coming_soon" : MessageLookupByLibrary.simpleMessage("COMING SOON"),
    "commentFailedWhenRemovingCommentTitle" : m4,
    "commentRemovedSuccessfullyTitle" : m5,
    "comments" : MessageLookupByLibrary.simpleMessage("Comments"),
    "count_movie" : m6,
    "couponCode" : MessageLookupByLibrary.simpleMessage("Coupon code: "),
    "date" : MessageLookupByLibrary.simpleMessage("Date"),
    "deleteNotification" : MessageLookupByLibrary.simpleMessage("Delete notification"),
    "deleteSuccessfully" : MessageLookupByLibrary.simpleMessage("Delete successfully"),
    "directors" : MessageLookupByLibrary.simpleMessage("DIRECTORS"),
    "discount" : MessageLookupByLibrary.simpleMessage("Discount: "),
    "doYouWantToDeleteThisCommentThisActionCannot" : MessageLookupByLibrary.simpleMessage("Do you want to delete this comment. This action cannot be undone!"),
    "doubledSeat" : MessageLookupByLibrary.simpleMessage("Doubled seat"),
    "doubledTicket" : MessageLookupByLibrary.simpleMessage("Doubled ticket"),
    "durationMinsFrom" : MessageLookupByLibrary.simpleMessage("Duration (mins) from "),
    "duration_minutes" : m7,
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "emailToReceiveTickets" : MessageLookupByLibrary.simpleMessage("Email to receive tickets"),
    "emptyCard" : MessageLookupByLibrary.simpleMessage("Empty card"),
    "emptyComment" : MessageLookupByLibrary.simpleMessage("Empty comment"),
    "emptyCouponCode" : MessageLookupByLibrary.simpleMessage("Empty coupon code"),
    "emptyNotification" : MessageLookupByLibrary.simpleMessage("Empty notification"),
    "emptyRelatedMovie" : MessageLookupByLibrary.simpleMessage("Empty related movie"),
    "emptyReservation" : MessageLookupByLibrary.simpleMessage("Empty reservation"),
    "emptySearchResult" : MessageLookupByLibrary.simpleMessage("Empty search result"),
    "emptyShowTimes" : MessageLookupByLibrary.simpleMessage("Empty show times"),
    "empty_favorite_movie" : MessageLookupByLibrary.simpleMessage("Empty favorite movie"),
    "empty_movie" : MessageLookupByLibrary.simpleMessage("Empty movie"),
    "empty_theatre" : MessageLookupByLibrary.simpleMessage("Empty theatre"),
    "error_with_message" : m8,
    "expireDateMmyy" : MessageLookupByLibrary.simpleMessage("Expire date (MM/yy)"),
    "fav_removed_failed_with_title" : m9,
    "fav_removed_successfully_with_title" : m10,
    "favorites" : MessageLookupByLibrary.simpleMessage("Favorites"),
    "fullName" : MessageLookupByLibrary.simpleMessage("Full name"),
    "gender" : MessageLookupByLibrary.simpleMessage("Gender"),
    "home" : MessageLookupByLibrary.simpleMessage("Home"),
    "information" : MessageLookupByLibrary.simpleMessage("Information"),
    "invalidEmailAddress" : MessageLookupByLibrary.simpleMessage("Invalid email address"),
    "invalidPhoneNumber" : MessageLookupByLibrary.simpleMessage("Invalid phone number"),
    "load_image_error" : MessageLookupByLibrary.simpleMessage("Load image error"),
    "loadedAllComments" : MessageLookupByLibrary.simpleMessage("Loaded all comments"),
    "loadedAllNotifications" : MessageLookupByLibrary.simpleMessage("Loaded all notifications"),
    "loadedAllReservations" : MessageLookupByLibrary.simpleMessage("Loaded all reservations"),
    "loggedOutSuccessfully" : MessageLookupByLibrary.simpleMessage("Logged out successfully"),
    "logoutFailed" : m11,
    "logoutOut" : MessageLookupByLibrary.simpleMessage("Logout out"),
    "maximumComboCount" : MessageLookupByLibrary.simpleMessage("Maximum combo count"),
    "missingRequiredFields" : MessageLookupByLibrary.simpleMessage("Missing required fields"),
    "most_favorite" : MessageLookupByLibrary.simpleMessage("MOST FAVORITE"),
    "most_rate" : MessageLookupByLibrary.simpleMessage("MOST RATE"),
    "movies_on_theatre" : MessageLookupByLibrary.simpleMessage("Movies on Theatre"),
    "mustBeAfterMinReleasedDate" : MessageLookupByLibrary.simpleMessage("Must be after min released date"),
    "mustBeBeforeMaxReleasedDate" : MessageLookupByLibrary.simpleMessage("Must be before max released date"),
    "mustBeGreaterThanOrEqualToMinDuration" : MessageLookupByLibrary.simpleMessage("Must be greater than or equal to min duration"),
    "mustBeLessThanOrEqualToMaxDuration" : MessageLookupByLibrary.simpleMessage("Must be less than or equal to max duration"),
    "mustSelectAtLeastOneSeat" : MessageLookupByLibrary.simpleMessage("Must select at least one seat"),
    "myTicket" : MessageLookupByLibrary.simpleMessage("My ticket"),
    "myTicket_room" : MessageLookupByLibrary.simpleMessage("Room"),
    "myTicket_theatre" : MessageLookupByLibrary.simpleMessage("Theatre"),
    "nationwide" : MessageLookupByLibrary.simpleMessage("Nationwide"),
    "nearby_theatre" : MessageLookupByLibrary.simpleMessage("NEARBY THEATRES"),
    "networkError" : MessageLookupByLibrary.simpleMessage("Network error"),
    "noInternetConnection" : MessageLookupByLibrary.simpleMessage("No internet connection"),
    "normalTicket" : MessageLookupByLibrary.simpleMessage("Normal ticket"),
    "notLoggedIn" : MessageLookupByLibrary.simpleMessage("Not logged in"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notifications"),
    "onlyUserRoleIsAllowed" : MessageLookupByLibrary.simpleMessage("Only USER role is allowed"),
    "orderId" : MessageLookupByLibrary.simpleMessage("Order ID"),
    "originalPrice" : MessageLookupByLibrary.simpleMessage("Original price: "),
    "phoneNumber" : MessageLookupByLibrary.simpleMessage("Phone number"),
    "phoneNumberToReceiveTickets" : MessageLookupByLibrary.simpleMessage("Phone number to receive tickets"),
    "profile" : MessageLookupByLibrary.simpleMessage("Profile"),
    "promotionEnd" : m12,
    "promotionStart" : m13,
    "recommended_for_you" : MessageLookupByLibrary.simpleMessage("RECOMMENDED FOR YOU"),
    "relatedMovies" : MessageLookupByLibrary.simpleMessage("RELATED MOVIES"),
    "releasedDateFrom" : MessageLookupByLibrary.simpleMessage("Released date from "),
    "remove" : MessageLookupByLibrary.simpleMessage("Remove"),
    "removeCard" : MessageLookupByLibrary.simpleMessage("Remove card"),
    "removeMsgcardlast4FailedGeterrormessagemsgerror" : m14,
    "removeThisComment" : MessageLookupByLibrary.simpleMessage("Remove this comment"),
    "removedSuccessMsgremovedlast4" : m15,
    "requiredUpdatingYourProfile" : MessageLookupByLibrary.simpleMessage("Required updating your profile"),
    "retry" : MessageLookupByLibrary.simpleMessage("Retry"),
    "reviews" : MessageLookupByLibrary.simpleMessage(" reviews"),
    "room" : MessageLookupByLibrary.simpleMessage(" Room: "),
    "searchFilter" : MessageLookupByLibrary.simpleMessage("Search filter"),
    "seat_s" : m16,
    "select" : MessageLookupByLibrary.simpleMessage("Select"),
    "selectCouponCode" : MessageLookupByLibrary.simpleMessage("Select coupon code"),
    "selectDiscountCode" : MessageLookupByLibrary.simpleMessage("Select discount code"),
    "selectOrAddACard" : MessageLookupByLibrary.simpleMessage("Select or add a card"),
    "selectTheArea" : MessageLookupByLibrary.simpleMessage("Select the area: "),
    "select_city" : MessageLookupByLibrary.simpleMessage("Select city"),
    "selected" : MessageLookupByLibrary.simpleMessage("Selected"),
    "selectedCardlast4TapToChange" : m17,
    "showTimes" : MessageLookupByLibrary.simpleMessage("Show times"),
    "showtimeEndTimeMustBeAfterStartTime" : MessageLookupByLibrary.simpleMessage("Showtime end time must be after start time"),
    "showtimeStartFrom" : MessageLookupByLibrary.simpleMessage("Showtime start from "),
    "showtimeStartTimeMustBeBeforeEndTime" : MessageLookupByLibrary.simpleMessage("Showtime start time must be before end time"),
    "slowInternetConnection" : MessageLookupByLibrary.simpleMessage("Slow internet connection"),
    "someSeatsYouChooseHaveBeenReservedPleaseSelectOther" : MessageLookupByLibrary.simpleMessage("Some seats you choose have been reserved. Please select other seats."),
    "startAt" : MessageLookupByLibrary.simpleMessage("Start at: "),
    "storyline" : MessageLookupByLibrary.simpleMessage("STORYLINE"),
    "taken" : MessageLookupByLibrary.simpleMessage("Taken"),
    "theatre" : MessageLookupByLibrary.simpleMessage("Theatre: "),
    "tickets" : MessageLookupByLibrary.simpleMessage("Tickets"),
    "time" : MessageLookupByLibrary.simpleMessage("Time"),
    "timeOutToHoldTheSeatPleaseMakeYourReservation" : MessageLookupByLibrary.simpleMessage("Time out to hold the seat. Please make your reservation within 5 minutes!"),
    "timeout" : MessageLookupByLibrary.simpleMessage("Timeout"),
    "title" : MessageLookupByLibrary.simpleMessage("Title"),
    "to" : MessageLookupByLibrary.simpleMessage(" to "),
    "today" : MessageLookupByLibrary.simpleMessage("Today"),
    "toggleFailed" : m18,
    "toggledSuccessfully" : MessageLookupByLibrary.simpleMessage("Toggled successfully"),
    "totalPrice" : MessageLookupByLibrary.simpleMessage("Total price: "),
    "total_favorite" : m19,
    "total_rate_review" : m20,
    "view_all" : MessageLookupByLibrary.simpleMessage("VIEW ALL"),
    "warning" : MessageLookupByLibrary.simpleMessage("Warning"),
    "yourAccountEmailHasNotBeenVerifyPleaseVerifyTo" : MessageLookupByLibrary.simpleMessage("Your account email has not been verify. Please verify to continue!"),
    "yourComment" : MessageLookupByLibrary.simpleMessage("Your comment..."),
    "yourReservations" : MessageLookupByLibrary.simpleMessage("Your reservations"),
    "yourThinkAboutThisMovie" : MessageLookupByLibrary.simpleMessage("Your thoughts on this movie?")
  };
}
