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

  static m2(title) => "Failed when removing comment: ${title}...";

  static m3(title) => "Removed successfully: ${title}...";

  static m4(minute) => "${minute} minutes";

  static m5(message) => "Error occurred: ${message}";

  static m6(title) => "Removed failed: ${title}";

  static m7(title) => "Removed successfully: ${title}";

  static m8(message) => "Logout failed: ${message}";

  static m9(message) => "Toggle failed: ${message}";

  static m10(totalFavorite) => "${Intl.plural(totalFavorite, zero: '0 favorite', one: '1 favorite', other: '${totalFavorite} favorites')}";

  static m11(totalRate) => "${Intl.plural(totalRate, zero: '0 review', one: '1 review', other: '${totalRate} reviews')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "addComment" : MessageLookupByLibrary.simpleMessage("Add comment"),
    "addCommentFailureMessage" : m0,
    "addCommentSuccessfully" : MessageLookupByLibrary.simpleMessage("Add comment successfully"),
    "address" : MessageLookupByLibrary.simpleMessage("Address"),
    "areYouSureYouWantToDeleteThisNotification" : MessageLookupByLibrary.simpleMessage("Are you sure you want to delete this notification?"),
    "areYouSureYouWantToLogout" : MessageLookupByLibrary.simpleMessage("Are you sure you want to logout?"),
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
    "coming_soon" : MessageLookupByLibrary.simpleMessage("COMING SOON"),
    "commentFailedWhenRemovingCommentTitle" : m2,
    "commentRemovedSuccessfullyTitle" : m3,
    "comments" : MessageLookupByLibrary.simpleMessage("Comments"),
    "couponCode" : MessageLookupByLibrary.simpleMessage("Coupon code: "),
    "date" : MessageLookupByLibrary.simpleMessage("Date"),
    "deleteNotification" : MessageLookupByLibrary.simpleMessage("Delete notification"),
    "deleteSuccessfully" : MessageLookupByLibrary.simpleMessage("Delete successfully"),
    "directors" : MessageLookupByLibrary.simpleMessage("DIRECTORS"),
    "discount" : MessageLookupByLibrary.simpleMessage("Discount: "),
    "doYouWantToDeleteThisCommentThisActionCannot" : MessageLookupByLibrary.simpleMessage("Do you want to delete this comment. This action cannot be undone!"),
    "duration_minutes" : m4,
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "emptyComment" : MessageLookupByLibrary.simpleMessage("Empty comment"),
    "emptyNotification" : MessageLookupByLibrary.simpleMessage("Empty notification"),
    "emptyRelatedMovie" : MessageLookupByLibrary.simpleMessage("Empty related movie"),
    "emptyReservation" : MessageLookupByLibrary.simpleMessage("Empty reservation"),
    "emptyShowTimes" : MessageLookupByLibrary.simpleMessage("Empty show times"),
    "empty_favorite_movie" : MessageLookupByLibrary.simpleMessage("Empty favorite movie"),
    "empty_movie" : MessageLookupByLibrary.simpleMessage("Empty movie"),
    "empty_theatre" : MessageLookupByLibrary.simpleMessage("Empty theatre"),
    "error_with_message" : m5,
    "fav_removed_failed_with_title" : m6,
    "fav_removed_successfully_with_title" : m7,
    "favorites" : MessageLookupByLibrary.simpleMessage("Favorites"),
    "fullName" : MessageLookupByLibrary.simpleMessage("Full name"),
    "gender" : MessageLookupByLibrary.simpleMessage("Gender"),
    "home" : MessageLookupByLibrary.simpleMessage("Home"),
    "information" : MessageLookupByLibrary.simpleMessage("Information"),
    "load_image_error" : MessageLookupByLibrary.simpleMessage("Load image error"),
    "loadedAllComments" : MessageLookupByLibrary.simpleMessage("Loaded all comments"),
    "loadedAllNotifications" : MessageLookupByLibrary.simpleMessage("Loaded all notifications"),
    "loadedAllReservations" : MessageLookupByLibrary.simpleMessage("Loaded all reservations"),
    "loggedOutSuccessfully" : MessageLookupByLibrary.simpleMessage("Logged out successfully"),
    "logoutFailed" : m8,
    "logoutOut" : MessageLookupByLibrary.simpleMessage("Logout out"),
    "most_favorite" : MessageLookupByLibrary.simpleMessage("MOST FAVORITE"),
    "most_rate" : MessageLookupByLibrary.simpleMessage("MOST RATE"),
    "movies_on_theatre" : MessageLookupByLibrary.simpleMessage("Movies on Theatre"),
    "myTicket" : MessageLookupByLibrary.simpleMessage("My ticket"),
    "myTicket_room" : MessageLookupByLibrary.simpleMessage("Room"),
    "myTicket_theatre" : MessageLookupByLibrary.simpleMessage("Theatre"),
    "nationwide" : MessageLookupByLibrary.simpleMessage("Nationwide"),
    "nearby_theatre" : MessageLookupByLibrary.simpleMessage("NEARBY THEATRES"),
    "networkError" : MessageLookupByLibrary.simpleMessage("Network error"),
    "noInternetConnection" : MessageLookupByLibrary.simpleMessage("No internet connection"),
    "notLoggedIn" : MessageLookupByLibrary.simpleMessage("Not logged in"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notifications"),
    "onlyUserRoleIsAllowed" : MessageLookupByLibrary.simpleMessage("Only USER role is allowed"),
    "orderId" : MessageLookupByLibrary.simpleMessage("Order ID"),
    "originalPrice" : MessageLookupByLibrary.simpleMessage("Original price: "),
    "phoneNumber" : MessageLookupByLibrary.simpleMessage("Phone number"),
    "profile" : MessageLookupByLibrary.simpleMessage("Profile"),
    "recommended_for_you" : MessageLookupByLibrary.simpleMessage("RECOMMENDED FOR YOU"),
    "relatedMovies" : MessageLookupByLibrary.simpleMessage("RELATED MOVIES"),
    "remove" : MessageLookupByLibrary.simpleMessage("Remove"),
    "removeThisComment" : MessageLookupByLibrary.simpleMessage("Remove this comment"),
    "requiredUpdatingYourProfile" : MessageLookupByLibrary.simpleMessage("Required updating your profile"),
    "reviews" : MessageLookupByLibrary.simpleMessage(" reviews"),
    "room" : MessageLookupByLibrary.simpleMessage(" Room: "),
    "selectTheArea" : MessageLookupByLibrary.simpleMessage("Select the area: "),
    "select_city" : MessageLookupByLibrary.simpleMessage("Select city"),
    "showTimes" : MessageLookupByLibrary.simpleMessage("Show times"),
    "slowInternetConnection" : MessageLookupByLibrary.simpleMessage("Slow internet connection"),
    "startAt" : MessageLookupByLibrary.simpleMessage("Start at: "),
    "storyline" : MessageLookupByLibrary.simpleMessage("STORYLINE"),
    "theatre" : MessageLookupByLibrary.simpleMessage("Theatre: "),
    "tickets" : MessageLookupByLibrary.simpleMessage("Tickets"),
    "time" : MessageLookupByLibrary.simpleMessage("Time"),
    "title" : MessageLookupByLibrary.simpleMessage("Title"),
    "today" : MessageLookupByLibrary.simpleMessage("Today"),
    "toggleFailed" : m9,
    "toggledSuccessfully" : MessageLookupByLibrary.simpleMessage("Toggled successfully"),
    "totalPrice" : MessageLookupByLibrary.simpleMessage("Total price: "),
    "total_favorite" : m10,
    "total_rate_review" : m11,
    "view_all" : MessageLookupByLibrary.simpleMessage("VIEW ALL"),
    "yourAccountEmailHasNotBeenVerifyPleaseVerifyTo" : MessageLookupByLibrary.simpleMessage("Your account email has not been verify. Please verify to continue!"),
    "yourComment" : MessageLookupByLibrary.simpleMessage("Your comment..."),
    "yourReservations" : MessageLookupByLibrary.simpleMessage("Your reservations"),
    "yourThinkAboutThisMovie" : MessageLookupByLibrary.simpleMessage("Your thoughts on this movie?")
  };
}
