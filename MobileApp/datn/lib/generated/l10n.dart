// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Change language successfully`
  String get change_language_success {
    return Intl.message(
      'Change language successfully',
      name: 'change_language_success',
      desc: '',
      args: [],
    );
  }

  /// `Error when change language: {error}`
  String change_language_error(Object error) {
    return Intl.message(
      'Error when change language: $error',
      name: 'change_language_error',
      desc: '',
      args: [error],
    );
  }

  /// `Error when change language`
  String get change_language_failure {
    return Intl.message(
      'Error when change language',
      name: 'change_language_failure',
      desc: '',
      args: [],
    );
  }

  /// `Change language`
  String get change_language {
    return Intl.message(
      'Change language',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }

  /// `Movies on Theatre`
  String get movies_on_theatre {
    return Intl.message(
      'Movies on Theatre',
      name: 'movies_on_theatre',
      desc: '',
      args: [],
    );
  }

  /// `Select city`
  String get select_city {
    return Intl.message(
      'Select city',
      name: 'select_city',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred: {message}`
  String error_with_message(Object message) {
    return Intl.message(
      'Error occurred: $message',
      name: 'error_with_message',
      desc: '',
      args: [message],
    );
  }

  /// `Empty movie`
  String get empty_movie {
    return Intl.message(
      'Empty movie',
      name: 'empty_movie',
      desc: '',
      args: [],
    );
  }

  /// `Load image error`
  String get load_image_error {
    return Intl.message(
      'Load image error',
      name: 'load_image_error',
      desc: '',
      args: [],
    );
  }

  /// `{minute} minutes`
  String duration_minutes(Object minute) {
    return Intl.message(
      '$minute minutes',
      name: 'duration_minutes',
      desc: '',
      args: [minute],
    );
  }

  /// `{totalRate,plural, =0{0 review}=1{1 review}other{{totalRate} reviews}}`
  String total_rate_review(num totalRate) {
    return Intl.plural(
      totalRate,
      zero: '0 review',
      one: '1 review',
      other: '$totalRate reviews',
      name: 'total_rate_review',
      desc: '',
      args: [totalRate],
    );
  }

  /// `{totalFavorite,plural, =0{0 favorite}=1{1 favorite}other{{totalFavorite} favorites}}`
  String total_favorite(num totalFavorite) {
    return Intl.plural(
      totalFavorite,
      zero: '0 favorite',
      one: '1 favorite',
      other: '$totalFavorite favorites',
      name: 'total_favorite',
      desc: '',
      args: [totalFavorite],
    );
  }

  /// `COMING SOON`
  String get coming_soon {
    return Intl.message(
      'COMING SOON',
      name: 'coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `RECOMMENDED FOR YOU`
  String get recommended_for_you {
    return Intl.message(
      'RECOMMENDED FOR YOU',
      name: 'recommended_for_you',
      desc: '',
      args: [],
    );
  }

  /// `MOST FAVORITE`
  String get most_favorite {
    return Intl.message(
      'MOST FAVORITE',
      name: 'most_favorite',
      desc: '',
      args: [],
    );
  }

  /// `MOST RATE`
  String get most_rate {
    return Intl.message(
      'MOST RATE',
      name: 'most_rate',
      desc: '',
      args: [],
    );
  }

  /// `NEARBY THEATRES`
  String get nearby_theatre {
    return Intl.message(
      'NEARBY THEATRES',
      name: 'nearby_theatre',
      desc: '',
      args: [],
    );
  }

  /// `VIEW ALL`
  String get view_all {
    return Intl.message(
      'VIEW ALL',
      name: 'view_all',
      desc: '',
      args: [],
    );
  }

  /// `Empty theatre`
  String get empty_theatre {
    return Intl.message(
      'Empty theatre',
      name: 'empty_theatre',
      desc: '',
      args: [],
    );
  }

  /// `Nationwide`
  String get nationwide {
    return Intl.message(
      'Nationwide',
      name: 'nationwide',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Empty favorite movie`
  String get empty_favorite_movie {
    return Intl.message(
      'Empty favorite movie',
      name: 'empty_favorite_movie',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Removed successfully: {title}`
  String fav_removed_successfully_with_title(Object title) {
    return Intl.message(
      'Removed successfully: $title',
      name: 'fav_removed_successfully_with_title',
      desc: '',
      args: [title],
    );
  }

  /// `Removed failed: {title}`
  String fav_removed_failed_with_title(Object title) {
    return Intl.message(
      'Removed failed: $title',
      name: 'fav_removed_failed_with_title',
      desc: '',
      args: [title],
    );
  }

  /// `Loaded all notifications`
  String get loadedAllNotifications {
    return Intl.message(
      'Loaded all notifications',
      name: 'loadedAllNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Empty notification`
  String get emptyNotification {
    return Intl.message(
      'Empty notification',
      name: 'emptyNotification',
      desc: '',
      args: [],
    );
  }

  /// `Delete notification`
  String get deleteNotification {
    return Intl.message(
      'Delete notification',
      name: 'deleteNotification',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this notification?`
  String get areYouSureYouWantToDeleteThisNotification {
    return Intl.message(
      'Are you sure you want to delete this notification?',
      name: 'areYouSureYouWantToDeleteThisNotification',
      desc: '',
      args: [],
    );
  }

  /// `Delete successfully`
  String get deleteSuccessfully {
    return Intl.message(
      'Delete successfully',
      name: 'deleteSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Start at: `
  String get startAt {
    return Intl.message(
      'Start at: ',
      name: 'startAt',
      desc: '',
      args: [],
    );
  }

  /// `Theatre: `
  String get theatre {
    return Intl.message(
      'Theatre: ',
      name: 'theatre',
      desc: '',
      args: [],
    );
  }

  /// ` Room: `
  String get room {
    return Intl.message(
      ' Room: ',
      name: 'room',
      desc: '',
      args: [],
    );
  }

  /// `Tickets`
  String get tickets {
    return Intl.message(
      'Tickets',
      name: 'tickets',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get fullName {
    return Intl.message(
      'Full name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Birthday`
  String get birthday {
    return Intl.message(
      'Birthday',
      name: 'birthday',
      desc: '',
      args: [],
    );
  }

  /// `Logout out`
  String get logoutOut {
    return Intl.message(
      'Logout out',
      name: 'logoutOut',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to logout?`
  String get areYouSureYouWantToLogout {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'areYouSureYouWantToLogout',
      desc: '',
      args: [],
    );
  }

  /// `Logout failed: {message}`
  String logoutFailed(Object message) {
    return Intl.message(
      'Logout failed: $message',
      name: 'logoutFailed',
      desc: '',
      args: [message],
    );
  }

  /// `Loaded all reservations`
  String get loadedAllReservations {
    return Intl.message(
      'Loaded all reservations',
      name: 'loadedAllReservations',
      desc: '',
      args: [],
    );
  }

  /// `Your reservations`
  String get yourReservations {
    return Intl.message(
      'Your reservations',
      name: 'yourReservations',
      desc: '',
      args: [],
    );
  }

  /// `Empty reservation`
  String get emptyReservation {
    return Intl.message(
      'Empty reservation',
      name: 'emptyReservation',
      desc: '',
      args: [],
    );
  }

  /// `Coupon code: `
  String get couponCode {
    return Intl.message(
      'Coupon code: ',
      name: 'couponCode',
      desc: '',
      args: [],
    );
  }

  /// `Discount: `
  String get discount {
    return Intl.message(
      'Discount: ',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Original price: `
  String get originalPrice {
    return Intl.message(
      'Original price: ',
      name: 'originalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Total price: `
  String get totalPrice {
    return Intl.message(
      'Total price: ',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Required updating your profile`
  String get requiredUpdatingYourProfile {
    return Intl.message(
      'Required updating your profile',
      name: 'requiredUpdatingYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Not logged in`
  String get notLoggedIn {
    return Intl.message(
      'Not logged in',
      name: 'notLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Your account email has not been verify. Please verify to continue!`
  String get yourAccountEmailHasNotBeenVerifyPleaseVerifyTo {
    return Intl.message(
      'Your account email has not been verify. Please verify to continue!',
      name: 'yourAccountEmailHasNotBeenVerifyPleaseVerifyTo',
      desc: '',
      args: [],
    );
  }

  /// `Only USER role is allowed`
  String get onlyUserRoleIsAllowed {
    return Intl.message(
      'Only USER role is allowed',
      name: 'onlyUserRoleIsAllowed',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get noInternetConnection {
    return Intl.message(
      'No internet connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Slow internet connection`
  String get slowInternetConnection {
    return Intl.message(
      'Slow internet connection',
      name: 'slowInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Network error`
  String get networkError {
    return Intl.message(
      'Network error',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `My ticket`
  String get myTicket {
    return Intl.message(
      'My ticket',
      name: 'myTicket',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Order ID`
  String get orderId {
    return Intl.message(
      'Order ID',
      name: 'orderId',
      desc: '',
      args: [],
    );
  }

  /// `Check your mail: `
  String get checkYourMail {
    return Intl.message(
      'Check your mail: ',
      name: 'checkYourMail',
      desc: '',
      args: [],
    );
  }

  /// `Room`
  String get myTicket_room {
    return Intl.message(
      'Room',
      name: 'myTicket_room',
      desc: '',
      args: [],
    );
  }

  /// `Theatre`
  String get myTicket_theatre {
    return Intl.message(
      'Theatre',
      name: 'myTicket_theatre',
      desc: '',
      args: [],
    );
  }

  /// `Show times`
  String get showTimes {
    return Intl.message(
      'Show times',
      name: 'showTimes',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get information {
    return Intl.message(
      'Information',
      name: 'information',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Empty show times`
  String get emptyShowTimes {
    return Intl.message(
      'Empty show times',
      name: 'emptyShowTimes',
      desc: '',
      args: [],
    );
  }

  /// `Select the area: `
  String get selectTheArea {
    return Intl.message(
      'Select the area: ',
      name: 'selectTheArea',
      desc: '',
      args: [],
    );
  }

  /// `Loaded all comments`
  String get loadedAllComments {
    return Intl.message(
      'Loaded all comments',
      name: 'loadedAllComments',
      desc: '',
      args: [],
    );
  }

  /// `Removed successfully: {title}...`
  String commentRemovedSuccessfullyTitle(Object title) {
    return Intl.message(
      'Removed successfully: $title...',
      name: 'commentRemovedSuccessfullyTitle',
      desc: '',
      args: [title],
    );
  }

  /// `Failed when removing comment: {title}...`
  String commentFailedWhenRemovingCommentTitle(Object title) {
    return Intl.message(
      'Failed when removing comment: $title...',
      name: 'commentFailedWhenRemovingCommentTitle',
      desc: '',
      args: [title],
    );
  }

  /// `Empty comment`
  String get emptyComment {
    return Intl.message(
      'Empty comment',
      name: 'emptyComment',
      desc: '',
      args: [],
    );
  }

  /// `Remove this comment`
  String get removeThisComment {
    return Intl.message(
      'Remove this comment',
      name: 'removeThisComment',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this comment. This action cannot be undone!`
  String get doYouWantToDeleteThisCommentThisActionCannot {
    return Intl.message(
      'Do you want to delete this comment. This action cannot be undone!',
      name: 'doYouWantToDeleteThisCommentThisActionCannot',
      desc: '',
      args: [],
    );
  }

  /// `Your thoughts on this movie?`
  String get yourThinkAboutThisMovie {
    return Intl.message(
      'Your thoughts on this movie?',
      name: 'yourThinkAboutThisMovie',
      desc: '',
      args: [],
    );
  }

  /// `Based on `
  String get baseOn {
    return Intl.message(
      'Based on ',
      name: 'baseOn',
      desc: '',
      args: [],
    );
  }

  /// ` reviews`
  String get reviews {
    return Intl.message(
      ' reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `Add comment`
  String get addComment {
    return Intl.message(
      'Add comment',
      name: 'addComment',
      desc: '',
      args: [],
    );
  }

  /// `Your comment...`
  String get yourComment {
    return Intl.message(
      'Your comment...',
      name: 'yourComment',
      desc: '',
      args: [],
    );
  }

  /// `Add comment successfully`
  String get addCommentSuccessfully {
    return Intl.message(
      'Add comment successfully',
      name: 'addCommentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Add comment failed: {message}`
  String addCommentFailureMessage(Object message) {
    return Intl.message(
      'Add comment failed: $message',
      name: 'addCommentFailureMessage',
      desc: '',
      args: [message],
    );
  }

  /// `Toggled successfully`
  String get toggledSuccessfully {
    return Intl.message(
      'Toggled successfully',
      name: 'toggledSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Toggle failed: {message}`
  String toggleFailed(Object message) {
    return Intl.message(
      'Toggle failed: $message',
      name: 'toggleFailed',
      desc: '',
      args: [message],
    );
  }

  /// `STORYLINE`
  String get storyline {
    return Intl.message(
      'STORYLINE',
      name: 'storyline',
      desc: '',
      args: [],
    );
  }

  /// `CAST OVERVIEW`
  String get castOverview {
    return Intl.message(
      'CAST OVERVIEW',
      name: 'castOverview',
      desc: '',
      args: [],
    );
  }

  /// `DIRECTORS`
  String get directors {
    return Intl.message(
      'DIRECTORS',
      name: 'directors',
      desc: '',
      args: [],
    );
  }

  /// `RELATED MOVIES`
  String get relatedMovies {
    return Intl.message(
      'RELATED MOVIES',
      name: 'relatedMovies',
      desc: '',
      args: [],
    );
  }

  /// `Cannot open trailer video`
  String get cannotOpenTrailerVideo {
    return Intl.message(
      'Cannot open trailer video',
      name: 'cannotOpenTrailerVideo',
      desc: '',
      args: [],
    );
  }

  /// `Empty related movie`
  String get emptyRelatedMovie {
    return Intl.message(
      'Empty related movie',
      name: 'emptyRelatedMovie',
      desc: '',
      args: [],
    );
  }

  /// `Logged out successfully`
  String get loggedOutSuccessfully {
    return Intl.message(
      'Logged out successfully',
      name: 'loggedOutSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Timeout`
  String get timeout {
    return Intl.message(
      'Timeout',
      name: 'timeout',
      desc: '',
      args: [],
    );
  }

  /// `Time out to hold the seat. Please make your reservation within 5 minutes!`
  String get timeOutToHoldTheSeatPleaseMakeYourReservation {
    return Intl.message(
      'Time out to hold the seat. Please make your reservation within 5 minutes!',
      name: 'timeOutToHoldTheSeatPleaseMakeYourReservation',
      desc: '',
      args: [],
    );
  }

  /// `CONTINUE`
  String get CONTINUE {
    return Intl.message(
      'CONTINUE',
      name: 'CONTINUE',
      desc: '',
      args: [],
    );
  }

  /// `Must select at least one seat`
  String get mustSelectAtLeastOneSeat {
    return Intl.message(
      'Must select at least one seat',
      name: 'mustSelectAtLeastOneSeat',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Some seats you choose have been reserved. Please select other seats.`
  String get someSeatsYouChooseHaveBeenReservedPleaseSelectOther {
    return Intl.message(
      'Some seats you choose have been reserved. Please select other seats.',
      name: 'someSeatsYouChooseHaveBeenReservedPleaseSelectOther',
      desc: '',
      args: [],
    );
  }

  /// `SCREEN`
  String get SCREEN {
    return Intl.message(
      'SCREEN',
      name: 'SCREEN',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get selected {
    return Intl.message(
      'Selected',
      name: 'selected',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message(
      'Available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Taken`
  String get taken {
    return Intl.message(
      'Taken',
      name: 'taken',
      desc: '',
      args: [],
    );
  }

  /// `Doubled seat`
  String get doubledSeat {
    return Intl.message(
      'Doubled seat',
      name: 'doubledSeat',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `{seats,plural, =0{seat}=1{seat}other{seats}}`
  String seat_s(num seats) {
    return Intl.plural(
      seats,
      zero: 'seat',
      one: 'seat',
      other: 'seats',
      name: 'seat_s',
      desc: '',
      args: [seats],
    );
  }

  /// `Maximum combo count`
  String get maximumComboCount {
    return Intl.message(
      'Maximum combo count',
      name: 'maximumComboCount',
      desc: '',
      args: [],
    );
  }

  /// `Combo`
  String get combo {
    return Intl.message(
      'Combo',
      name: 'combo',
      desc: '',
      args: [],
    );
  }

  /// `Normal ticket`
  String get normalTicket {
    return Intl.message(
      'Normal ticket',
      name: 'normalTicket',
      desc: '',
      args: [],
    );
  }

  /// `Doubled ticket`
  String get doubledTicket {
    return Intl.message(
      'Doubled ticket',
      name: 'doubledTicket',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email address`
  String get invalidEmailAddress {
    return Intl.message(
      'Invalid email address',
      name: 'invalidEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get invalidPhoneNumber {
    return Intl.message(
      'Invalid phone number',
      name: 'invalidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Checkout successfully. Please check email to get ticket`
  String get checkoutSuccessfullyPleaseCheckEmailToGetTicket {
    return Intl.message(
      'Checkout successfully. Please check email to get ticket',
      name: 'checkoutSuccessfullyPleaseCheckEmailToGetTicket',
      desc: '',
      args: [],
    );
  }

  /// `Checkout failed: {message}`
  String checkoutFailedGeterrormessagemessageerror(Object message) {
    return Intl.message(
      'Checkout failed: $message',
      name: 'checkoutFailedGeterrormessagemessageerror',
      desc: '',
      args: [message],
    );
  }

  /// `Missing required fields`
  String get missingRequiredFields {
    return Intl.message(
      'Missing required fields',
      name: 'missingRequiredFields',
      desc: '',
      args: [],
    );
  }

  /// `FINISH`
  String get FINISH {
    return Intl.message(
      'FINISH',
      name: 'FINISH',
      desc: '',
      args: [],
    );
  }

  /// `OFF`
  String get OFF {
    return Intl.message(
      'OFF',
      name: 'OFF',
      desc: '',
      args: [],
    );
  }

  /// `Select or add a card`
  String get selectOrAddACard {
    return Intl.message(
      'Select or add a card',
      name: 'selectOrAddACard',
      desc: '',
      args: [],
    );
  }

  /// `Selected '••••{last4}'. Tap to change`
  String selectedCardlast4TapToChange(Object last4) {
    return Intl.message(
      'Selected \'••••$last4\'. Tap to change',
      name: 'selectedCardlast4TapToChange',
      desc: '',
      args: [last4],
    );
  }

  /// `Select discount code`
  String get selectDiscountCode {
    return Intl.message(
      'Select discount code',
      name: 'selectDiscountCode',
      desc: '',
      args: [],
    );
  }

  /// `Email to receive tickets`
  String get emailToReceiveTickets {
    return Intl.message(
      'Email to receive tickets',
      name: 'emailToReceiveTickets',
      desc: '',
      args: [],
    );
  }

  /// `Phone number to receive tickets`
  String get phoneNumberToReceiveTickets {
    return Intl.message(
      'Phone number to receive tickets',
      name: 'phoneNumberToReceiveTickets',
      desc: '',
      args: [],
    );
  }

  /// `Add card`
  String get addCard {
    return Intl.message(
      'Add card',
      name: 'addCard',
      desc: '',
      args: [],
    );
  }

  /// `Empty card`
  String get emptyCard {
    return Intl.message(
      'Empty card',
      name: 'emptyCard',
      desc: '',
      args: [],
    );
  }

  /// `Remove card`
  String get removeCard {
    return Intl.message(
      'Remove card',
      name: 'removeCard',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove card`
  String get areYouSureYouWantToRemoveCard {
    return Intl.message(
      'Are you sure you want to remove card',
      name: 'areYouSureYouWantToRemoveCard',
      desc: '',
      args: [],
    );
  }

  /// `Remove '{last4}' failed: {msg}`
  String removeMsgcardlast4FailedGeterrormessagemsgerror(
      Object last4, Object msg) {
    return Intl.message(
      'Remove \'$last4\' failed: $msg',
      name: 'removeMsgcardlast4FailedGeterrormessagemsgerror',
      desc: '',
      args: [last4, msg],
    );
  }

  /// `Removed success: '{last4}'`
  String removedSuccessMsgremovedlast4(Object last4) {
    return Intl.message(
      'Removed success: \'$last4\'',
      name: 'removedSuccessMsgremovedlast4',
      desc: '',
      args: [last4],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Card holder name`
  String get cardHolderName {
    return Intl.message(
      'Card holder name',
      name: 'cardHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Card number`
  String get cardNumber {
    return Intl.message(
      'Card number',
      name: 'cardNumber',
      desc: '',
      args: [],
    );
  }

  /// `Expire date (MM/yy)`
  String get expireDateMmyy {
    return Intl.message(
      'Expire date (MM/yy)',
      name: 'expireDateMmyy',
      desc: '',
      args: [],
    );
  }

  /// `ADD CARD`
  String get ADDCARD {
    return Intl.message(
      'ADD CARD',
      name: 'ADDCARD',
      desc: '',
      args: [],
    );
  }

  /// `Added card successfully`
  String get addedCardSuccessfully {
    return Intl.message(
      'Added card successfully',
      name: 'addedCardSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Add card failed: {msg}`
  String addCardFailed(Object msg) {
    return Intl.message(
      'Add card failed: $msg',
      name: 'addCardFailed',
      desc: '',
      args: [msg],
    );
  }

  /// `Empty coupon code`
  String get emptyCouponCode {
    return Intl.message(
      'Empty coupon code',
      name: 'emptyCouponCode',
      desc: '',
      args: [],
    );
  }

  /// `Select coupon code`
  String get selectCouponCode {
    return Intl.message(
      'Select coupon code',
      name: 'selectCouponCode',
      desc: '',
      args: [],
    );
  }

  /// `Start: {d}`
  String promotionStart(Object d) {
    return Intl.message(
      'Start: $d',
      name: 'promotionStart',
      desc: '',
      args: [d],
    );
  }

  /// `End: {d}`
  String promotionEnd(Object d) {
    return Intl.message(
      'End: $d',
      name: 'promotionEnd',
      desc: '',
      args: [d],
    );
  }

  /// `Empty search result`
  String get emptySearchResult {
    return Intl.message(
      'Empty search result',
      name: 'emptySearchResult',
      desc: '',
      args: [],
    );
  }

  /// `Search filter`
  String get searchFilter {
    return Intl.message(
      'Search filter',
      name: 'searchFilter',
      desc: '',
      args: [],
    );
  }

  /// `Age type`
  String get ageType {
    return Intl.message(
      'Age type',
      name: 'ageType',
      desc: '',
      args: [],
    );
  }

  /// `Duration (mins) from `
  String get durationMinsFrom {
    return Intl.message(
      'Duration (mins) from ',
      name: 'durationMinsFrom',
      desc: '',
      args: [],
    );
  }

  /// `Must be less than or equal to max duration`
  String get mustBeLessThanOrEqualToMaxDuration {
    return Intl.message(
      'Must be less than or equal to max duration',
      name: 'mustBeLessThanOrEqualToMaxDuration',
      desc: '',
      args: [],
    );
  }

  /// ` to `
  String get to {
    return Intl.message(
      ' to ',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Must be greater than or equal to min duration`
  String get mustBeGreaterThanOrEqualToMinDuration {
    return Intl.message(
      'Must be greater than or equal to min duration',
      name: 'mustBeGreaterThanOrEqualToMinDuration',
      desc: '',
      args: [],
    );
  }

  /// `Showtime start from `
  String get showtimeStartFrom {
    return Intl.message(
      'Showtime start from ',
      name: 'showtimeStartFrom',
      desc: '',
      args: [],
    );
  }

  /// `Showtime start time must be before end time`
  String get showtimeStartTimeMustBeBeforeEndTime {
    return Intl.message(
      'Showtime start time must be before end time',
      name: 'showtimeStartTimeMustBeBeforeEndTime',
      desc: '',
      args: [],
    );
  }

  /// `Showtime end time must be after start time`
  String get showtimeEndTimeMustBeAfterStartTime {
    return Intl.message(
      'Showtime end time must be after start time',
      name: 'showtimeEndTimeMustBeAfterStartTime',
      desc: '',
      args: [],
    );
  }

  /// `Released date from `
  String get releasedDateFrom {
    return Intl.message(
      'Released date from ',
      name: 'releasedDateFrom',
      desc: '',
      args: [],
    );
  }

  /// `Must be before max released date`
  String get mustBeBeforeMaxReleasedDate {
    return Intl.message(
      'Must be before max released date',
      name: 'mustBeBeforeMaxReleasedDate',
      desc: '',
      args: [],
    );
  }

  /// `Must be after min released date`
  String get mustBeAfterMinReleasedDate {
    return Intl.message(
      'Must be after min released date',
      name: 'mustBeAfterMinReleasedDate',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `{movies,plural, =0{0 movie}=1{1 movie}other{{movies} movies}}`
  String count_movie(num movies) {
    return Intl.plural(
      movies,
      zero: '0 movie',
      one: '1 movie',
      other: '$movies movies',
      name: 'count_movie',
      desc: '',
      args: [movies],
    );
  }

  /// `DESCRIPTION`
  String get DESCRIPTION {
    return Intl.message(
      'DESCRIPTION',
      name: 'DESCRIPTION',
      desc: '',
      args: [],
    );
  }

  /// `Loaded all movies`
  String get loadedAllMovies {
    return Intl.message(
      'Loaded all movies',
      name: 'loadedAllMovies',
      desc: '',
      args: [],
    );
  }

  /// `Login to your Account`
  String get loginToYourAccount {
    return Intl.message(
      'Login to your Account',
      name: 'loginToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login successfully`
  String get loginSuccessfully {
    return Intl.message(
      'Login successfully',
      name: 'loginSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Invalid information`
  String get invalidInformation {
    return Intl.message(
      'Invalid information',
      name: 'invalidInformation',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN`
  String get LOGIN {
    return Intl.message(
      'LOGIN',
      name: 'LOGIN',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login error: {msg}`
  String loginErrorGeterrormessagedeprecatederror(Object msg) {
    return Intl.message(
      'Login error: $msg',
      name: 'loginErrorGeterrormessagedeprecatederror',
      desc: '',
      args: [msg],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordMustBeAtLeast6Characters {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordMustBeAtLeast6Characters',
      desc: '',
      args: [],
    );
  }

  /// `Google sign in failed: {msg}`
  String googleSignInFailedGeterrormessagedeprecatede(Object msg) {
    return Intl.message(
      'Google sign in failed: $msg',
      name: 'googleSignInFailedGeterrormessagedeprecatede',
      desc: '',
      args: [msg],
    );
  }

  /// `Facebook login error: {msg}`
  String facebookLoginErrorGeterrormessagedeprecatede(Object msg) {
    return Intl.message(
      'Facebook login error: $msg',
      name: 'facebookLoginErrorGeterrormessagedeprecatede',
      desc: '',
      args: [msg],
    );
  }

  /// `Don't have an account? Sign up`
  String get dontHaveAnAccountSignUp {
    return Intl.message(
      'Don\'t have an account? Sign up',
      name: 'dontHaveAnAccountSignUp',
      desc: '',
      args: [],
    );
  }

  /// `Create your Account`
  String get createYourAccount {
    return Intl.message(
      'Create your Account',
      name: 'createYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Register successfully. Please check your email inbox to verify this account.`
  String get registerSuccessfullyPleaseCheckYourEmailInboxToVerifyThis {
    return Intl.message(
      'Register successfully. Please check your email inbox to verify this account.',
      name: 'registerSuccessfullyPleaseCheckYourEmailInboxToVerifyThis',
      desc: '',
      args: [],
    );
  }

  /// `REGISTER`
  String get REGISTER {
    return Intl.message(
      'REGISTER',
      name: 'REGISTER',
      desc: '',
      args: [],
    );
  }

  /// `Register error: {msg}`
  String registerError(Object msg) {
    return Intl.message(
      'Register error: $msg',
      name: 'registerError',
      desc: '',
      args: [msg],
    );
  }

  /// `Enter your Email to reset Password`
  String get enterYourEmailToResetPassword {
    return Intl.message(
      'Enter your Email to reset Password',
      name: 'enterYourEmailToResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reset successfully. Please check your email to reset password!`
  String get resetSuccessfullyPleaseCheckYourEmailToResetPassword {
    return Intl.message(
      'Reset successfully. Please check your email to reset password!',
      name: 'resetSuccessfullyPleaseCheckYourEmailToResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `RESET PASSWORD`
  String get RESET_PASSWORD {
    return Intl.message(
      'RESET PASSWORD',
      name: 'RESET_PASSWORD',
      desc: '',
      args: [],
    );
  }

  /// `Reset password error: {msg}`
  String resetPasswordErrorMsg(Object msg) {
    return Intl.message(
      'Reset password error: $msg',
      name: 'resetPasswordErrorMsg',
      desc: '',
      args: [msg],
    );
  }

  /// `Update profile`
  String get updateProfile {
    return Intl.message(
      'Update profile',
      name: 'updateProfile',
      desc: '',
      args: [],
    );
  }

  /// `Invalid full name`
  String get invalidFullName {
    return Intl.message(
      'Invalid full name',
      name: 'invalidFullName',
      desc: '',
      args: [],
    );
  }

  /// `Empty address`
  String get emptyAddress {
    return Intl.message(
      'Empty address',
      name: 'emptyAddress',
      desc: '',
      args: [],
    );
  }

  /// `UPDATE`
  String get UPDATE {
    return Intl.message(
      'UPDATE',
      name: 'UPDATE',
      desc: '',
      args: [],
    );
  }

  /// `Invalid birthday`
  String get invalidBirthday {
    return Intl.message(
      'Invalid birthday',
      name: 'invalidBirthday',
      desc: '',
      args: [],
    );
  }

  /// `Update profile successfully`
  String get updateProfileSuccessfully {
    return Intl.message(
      'Update profile successfully',
      name: 'updateProfileSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Update profile failed: {msg}`
  String updateProfileFailedMsg(Object msg) {
    return Intl.message(
      'Update profile failed: $msg',
      name: 'updateProfileFailedMsg',
      desc: '',
      args: [msg],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Length of content must be in from 10 to 500`
  String get lengthOfContentMustBeInFrom10To500 {
    return Intl.message(
      'Length of content must be in from 10 to 500',
      name: 'lengthOfContentMustBeInFrom10To500',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Cards`
  String get cards {
    return Intl.message(
      'Cards',
      name: 'cards',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
