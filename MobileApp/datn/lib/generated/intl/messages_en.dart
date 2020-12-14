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

  static m0(error) => "Error when change language: ${error}";

  static m1(minute) => "${minute} minutes";

  static m2(message) => "Error occurred: ${message}";

  static m3(title) => "Removed failed: ${title}";

  static m4(title) => "Removed successfully: ${title}";

  static m5(message) => "Logout failed: ${message}";

  static m6(totalFavorite) => "${Intl.plural(totalFavorite, zero: '0 favorite', one: '1 favorite', other: '${totalFavorite} favorites')}";

  static m7(totalRate) => "${Intl.plural(totalRate, zero: '0 review', one: '1 review', other: '${totalRate} reviews')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "address" : MessageLookupByLibrary.simpleMessage("Address"),
    "areYouSureYouWantToDeleteThisNotification" : MessageLookupByLibrary.simpleMessage("Are you sure you want to delete this notification?"),
    "areYouSureYouWantToLogout" : MessageLookupByLibrary.simpleMessage("Are you sure you want to logout?"),
    "birthday" : MessageLookupByLibrary.simpleMessage("Birthday"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "change_language" : MessageLookupByLibrary.simpleMessage("Change language"),
    "change_language_error" : m0,
    "change_language_failure" : MessageLookupByLibrary.simpleMessage("Error when change language"),
    "change_language_success" : MessageLookupByLibrary.simpleMessage("Change language successfully"),
    "checkYourMail" : MessageLookupByLibrary.simpleMessage("Check your mail: "),
    "coming_soon" : MessageLookupByLibrary.simpleMessage("COMING SOON"),
    "couponCode" : MessageLookupByLibrary.simpleMessage("Coupon code: "),
    "date" : MessageLookupByLibrary.simpleMessage("Date"),
    "deleteNotification" : MessageLookupByLibrary.simpleMessage("Delete notification"),
    "deleteSuccessfully" : MessageLookupByLibrary.simpleMessage("Delete successfully"),
    "discount" : MessageLookupByLibrary.simpleMessage("Discount: "),
    "duration_minutes" : m1,
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "emptyNotification" : MessageLookupByLibrary.simpleMessage("Empty notification"),
    "emptyReservation" : MessageLookupByLibrary.simpleMessage("Empty reservation"),
    "empty_favorite_movie" : MessageLookupByLibrary.simpleMessage("Empty favorite movie"),
    "empty_movie" : MessageLookupByLibrary.simpleMessage("Empty movie"),
    "empty_theatre" : MessageLookupByLibrary.simpleMessage("Empty theatre"),
    "error_with_message" : m2,
    "fav_removed_failed_with_title" : m3,
    "fav_removed_successfully_with_title" : m4,
    "favorites" : MessageLookupByLibrary.simpleMessage("Favorites"),
    "fullName" : MessageLookupByLibrary.simpleMessage("Full name"),
    "gender" : MessageLookupByLibrary.simpleMessage("Gender"),
    "home" : MessageLookupByLibrary.simpleMessage("Home"),
    "load_image_error" : MessageLookupByLibrary.simpleMessage("Load image error"),
    "loadedAllNotifications" : MessageLookupByLibrary.simpleMessage("Loaded all notifications"),
    "loadedAllReservations" : MessageLookupByLibrary.simpleMessage("Loaded all reservations"),
    "logoutFailed" : m5,
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
    "remove" : MessageLookupByLibrary.simpleMessage("Remove"),
    "requiredUpdatingYourProfile" : MessageLookupByLibrary.simpleMessage("Required updating your profile"),
    "room" : MessageLookupByLibrary.simpleMessage(" Room: "),
    "select_city" : MessageLookupByLibrary.simpleMessage("Select city"),
    "slowInternetConnection" : MessageLookupByLibrary.simpleMessage("Slow internet connection"),
    "startAt" : MessageLookupByLibrary.simpleMessage("Start at: "),
    "theatre" : MessageLookupByLibrary.simpleMessage("Theatre: "),
    "tickets" : MessageLookupByLibrary.simpleMessage("Tickets"),
    "time" : MessageLookupByLibrary.simpleMessage("Time"),
    "title" : MessageLookupByLibrary.simpleMessage("Title"),
    "totalPrice" : MessageLookupByLibrary.simpleMessage("Total price: "),
    "total_favorite" : m6,
    "total_rate_review" : m7,
    "view_all" : MessageLookupByLibrary.simpleMessage("VIEW ALL"),
    "yourAccountEmailHasNotBeenVerifyPleaseVerifyTo" : MessageLookupByLibrary.simpleMessage("Your account email has not been verify. Please verify to continue!"),
    "yourReservations" : MessageLookupByLibrary.simpleMessage("Your reservations")
  };
}
