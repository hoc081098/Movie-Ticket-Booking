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

  static m0(message) => "Add comment failed: ${message}";

  static m1(error) => "Error when change language: ${error}";

  static m2(message) => "Checkout failed: ${message}";

  static m3(title) => "Failed when removing comment: ${title}...";

  static m4(title) => "Removed successfully: ${title}...";

  static m5(minute) => "${minute} minutes";

  static m6(message) => "Error occurred: ${message}";

  static m7(title) => "Removed failed: ${title}";

  static m8(title) => "Removed successfully: ${title}";

  static m9(message) => "Logout failed: ${message}";

  static m10(last4, msg) => "Remove \'${last4}\' failed: ${msg}";

  static m11(last4) => "Removed success: \'${last4}\'";

  static m12(seats) => "${Intl.plural(seats, zero: 'seat', one: 'seat', other: 'seats')}";

  static m13(last4) => "Selected \'••••${last4}\'. Tap to change";

  static m14(message) => "Toggle failed: ${message}";

  static m15(totalFavorite) => "${Intl.plural(totalFavorite, zero: '0 favorite', one: '1 favorite', other: '${totalFavorite} favorites')}";

  static m16(totalRate) => "${Intl.plural(totalRate, zero: '0 review', one: '1 review', other: '${totalRate} reviews')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "CONTINUE" : MessageLookupByLibrary.simpleMessage("CONTINUE"),
    "FINISH" : MessageLookupByLibrary.simpleMessage("FINISH"),
    "OFF" : MessageLookupByLibrary.simpleMessage("OFF"),
    "SCREEN" : MessageLookupByLibrary.simpleMessage("SCREEN"),
    "addCard" : MessageLookupByLibrary.simpleMessage("Add card"),
    "addComment" : MessageLookupByLibrary.simpleMessage("Add comment"),
    "addCommentFailureMessage" : m0,
    "addCommentSuccessfully" : MessageLookupByLibrary.simpleMessage("Add comment successfully"),
    "address" : MessageLookupByLibrary.simpleMessage("Address"),
    "areYouSureYouWantToDeleteThisNotification" : MessageLookupByLibrary.simpleMessage("Are you sure you want to delete this notification?"),
    "areYouSureYouWantToLogout" : MessageLookupByLibrary.simpleMessage("Are you sure you want to logout?"),
    "areYouSureYouWantToRemoveCard" : MessageLookupByLibrary.simpleMessage("Are you sure you want to remove card"),
    "available" : MessageLookupByLibrary.simpleMessage("Available"),
    "baseOn" : MessageLookupByLibrary.simpleMessage("Based on "),
    "birthday" : MessageLookupByLibrary.simpleMessage("Birthday"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "cannotOpenTrailerVideo" : MessageLookupByLibrary.simpleMessage("Cannot open trailer video"),
    "castOverview" : MessageLookupByLibrary.simpleMessage("CAST OVERVIEW"),
    "change_language" : MessageLookupByLibrary.simpleMessage("Change language"),
    "change_language_error" : m1,
    "change_language_failure" : MessageLookupByLibrary.simpleMessage("Error when change language"),
    "change_language_success" : MessageLookupByLibrary.simpleMessage("Change language successfully"),
    "checkYourMail" : MessageLookupByLibrary.simpleMessage("Check your mail: "),
    "checkout" : MessageLookupByLibrary.simpleMessage("Checkout"),
    "checkoutFailedGeterrormessagemessageerror" : m2,
    "checkoutSuccessfullyPleaseCheckEmailToGetTicket" : MessageLookupByLibrary.simpleMessage("Checkout successfully. Please check email to get ticket"),
    "combo" : MessageLookupByLibrary.simpleMessage("Combo"),
    "coming_soon" : MessageLookupByLibrary.simpleMessage("COMING SOON"),
    "commentFailedWhenRemovingCommentTitle" : m3,
    "commentRemovedSuccessfullyTitle" : m4,
    "comments" : MessageLookupByLibrary.simpleMessage("Comments"),
    "couponCode" : MessageLookupByLibrary.simpleMessage("Coupon code: "),
    "date" : MessageLookupByLibrary.simpleMessage("Date"),
    "deleteNotification" : MessageLookupByLibrary.simpleMessage("Delete notification"),
    "deleteSuccessfully" : MessageLookupByLibrary.simpleMessage("Delete successfully"),
    "directors" : MessageLookupByLibrary.simpleMessage("DIRECTORS"),
    "discount" : MessageLookupByLibrary.simpleMessage("Discount: "),
    "doYouWantToDeleteThisCommentThisActionCannot" : MessageLookupByLibrary.simpleMessage("Do you want to delete this comment. This action cannot be undone!"),
    "doubledSeat" : MessageLookupByLibrary.simpleMessage("Doubled seat"),
    "doubledTicket" : MessageLookupByLibrary.simpleMessage("Doubled ticket"),
    "duration_minutes" : m5,
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "emailToReceiveTickets" : MessageLookupByLibrary.simpleMessage("Email to receive tickets"),
    "emptyCard" : MessageLookupByLibrary.simpleMessage("Empty card"),
    "emptyComment" : MessageLookupByLibrary.simpleMessage("Empty comment"),
    "emptyNotification" : MessageLookupByLibrary.simpleMessage("Empty notification"),
    "emptyRelatedMovie" : MessageLookupByLibrary.simpleMessage("Empty related movie"),
    "emptyReservation" : MessageLookupByLibrary.simpleMessage("Empty reservation"),
    "emptyShowTimes" : MessageLookupByLibrary.simpleMessage("Empty show times"),
    "empty_favorite_movie" : MessageLookupByLibrary.simpleMessage("Empty favorite movie"),
    "empty_movie" : MessageLookupByLibrary.simpleMessage("Empty movie"),
    "empty_theatre" : MessageLookupByLibrary.simpleMessage("Empty theatre"),
    "error_with_message" : m6,
    "fav_removed_failed_with_title" : m7,
    "fav_removed_successfully_with_title" : m8,
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
    "logoutFailed" : m9,
    "logoutOut" : MessageLookupByLibrary.simpleMessage("Logout out"),
    "maximumComboCount" : MessageLookupByLibrary.simpleMessage("Maximum combo count"),
    "missingRequiredFields" : MessageLookupByLibrary.simpleMessage("Missing required fields"),
    "most_favorite" : MessageLookupByLibrary.simpleMessage("MOST FAVORITE"),
    "most_rate" : MessageLookupByLibrary.simpleMessage("MOST RATE"),
    "movies_on_theatre" : MessageLookupByLibrary.simpleMessage("Movies on Theatre"),
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
    "recommended_for_you" : MessageLookupByLibrary.simpleMessage("RECOMMENDED FOR YOU"),
    "relatedMovies" : MessageLookupByLibrary.simpleMessage("RELATED MOVIES"),
    "remove" : MessageLookupByLibrary.simpleMessage("Remove"),
    "removeCard" : MessageLookupByLibrary.simpleMessage("Remove card"),
    "removeMsgcardlast4FailedGeterrormessagemsgerror" : m10,
    "removeThisComment" : MessageLookupByLibrary.simpleMessage("Remove this comment"),
    "removedSuccessMsgremovedlast4" : m11,
    "requiredUpdatingYourProfile" : MessageLookupByLibrary.simpleMessage("Required updating your profile"),
    "retry" : MessageLookupByLibrary.simpleMessage("Retry"),
    "reviews" : MessageLookupByLibrary.simpleMessage(" reviews"),
    "room" : MessageLookupByLibrary.simpleMessage(" Room: "),
    "seat_s" : m12,
    "select" : MessageLookupByLibrary.simpleMessage("Select"),
    "selectDiscountCode" : MessageLookupByLibrary.simpleMessage("Select discount code"),
    "selectOrAddACard" : MessageLookupByLibrary.simpleMessage("Select or add a card"),
    "selectTheArea" : MessageLookupByLibrary.simpleMessage("Select the area: "),
    "select_city" : MessageLookupByLibrary.simpleMessage("Select city"),
    "selected" : MessageLookupByLibrary.simpleMessage("Selected"),
    "selectedCardlast4TapToChange" : m13,
    "showTimes" : MessageLookupByLibrary.simpleMessage("Show times"),
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
    "today" : MessageLookupByLibrary.simpleMessage("Today"),
    "toggleFailed" : m14,
    "toggledSuccessfully" : MessageLookupByLibrary.simpleMessage("Toggled successfully"),
    "totalPrice" : MessageLookupByLibrary.simpleMessage("Total price: "),
    "total_favorite" : m15,
    "total_rate_review" : m16,
    "view_all" : MessageLookupByLibrary.simpleMessage("VIEW ALL"),
    "warning" : MessageLookupByLibrary.simpleMessage("Warning"),
    "yourAccountEmailHasNotBeenVerifyPleaseVerifyTo" : MessageLookupByLibrary.simpleMessage("Your account email has not been verify. Please verify to continue!"),
    "yourComment" : MessageLookupByLibrary.simpleMessage("Your comment..."),
    "yourReservations" : MessageLookupByLibrary.simpleMessage("Your reservations"),
    "yourThinkAboutThisMovie" : MessageLookupByLibrary.simpleMessage("Your thoughts on this movie?")
  };
}
