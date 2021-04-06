import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../data/repository/card_repository_impl.dart';
import '../data/repository/comment_repository_impl.dart';
import '../data/repository/notification_repository_impl.dart';
import '../data/repository/product_repository_impl.dart';
import '../data/repository/promotion_repository_impl.dart';
import '../data/repository/theatre_repository_impl.dart';
import '../data/repository/ticket_repository_impl.dart';
import '../domain/model/card.dart';
import '../domain/model/movie.dart';
import '../domain/model/reservation.dart';
import '../domain/model/theatre.dart';
import '../domain/model/user.dart';
import '../domain/repository/comment_repository.dart';
import '../domain/repository/notification_repository.dart';
import '../domain/repository/promotion_repository.dart';
import '../domain/repository/reservation_repository.dart';
import '../domain/repository/theatre_repository.dart';
import '../domain/repository/ticket_repository.dart';
import '../domain/repository/user_repository.dart';
import '../fcm_notification.dart';
import '../generated/l10n.dart';
import '../utils/utils.dart';
import 'app_scaffold.dart';
import 'favorites/favorites_page.dart';
import 'home/checkout/cards/add_card/add_card_bloc.dart';
import 'home/checkout/cards/add_card/add_card_page.dart';
import 'home/checkout/cards/cards_page.dart';
import 'home/checkout/checkout_page.dart';
import 'home/checkout/discount/discounts_page.dart';
import 'home/detail/comments/add_comment/add_commen_page.dart';
import 'home/detail/comments/add_comment/add_comment_bloc.dart';
import 'home/detail/movie_detail_page.dart';
import 'home/home_page.dart';
import 'home/movie_type.dart';
import 'home/search/search_page.dart';
import 'home/showtimes_by_theatre/show_time_by_theatre_page.dart';
import 'home/tickets/combo_bloc.dart';
import 'home/tickets/combo_page.dart';
import 'home/tickets/ticket_page.dart';
import 'home/view_all/view_all_page.dart';
import 'login/login_page.dart';
import 'login_update_profile/login_update_profile_page.dart';
import 'notifications/notifications_page.dart';
import 'profile/profile_page.dart';
import 'profile/reservation_detail/reservation_detail_page.dart';
import 'profile/reservations/reservations_page.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with DisposeBagMixin {
  static final cardPages = <String, AppScaffoldWidgetBuilder>{
    CardsPage.routeName: (context, settings) {
      final args = settings.arguments as Map<String, dynamic>;

      final mode = args['mode'] as CardPageMode;
      final key = ValueKey(mode);

      final card = args['card'] as Card;

      return BlocProvider<CardsBloc>(
        key: key,
        initBloc: (context) {
          return CardsBloc(
            CardRepositoryImpl(context.get(), context.get()),
            card,
          );
        },
        child: CardsPage(
          mode: mode,
          key: key,
        ),
      );
    },
    AddCardPage.routeName: (context, settings) {
      final mode = settings.arguments as CardPageMode;
      final key = ValueKey(mode);

      return BlocProvider<AddCardBloc>(
        key: key,
        initBloc: (context) => AddCardBloc(
          CardRepositoryImpl(context.get(), context.get()),
        ),
        child: AddCardPage(
          key: key,
          mode: mode,
        ),
      );
    },
  };

  static final homeRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) {
      return Provider<TheatreRepository>.factory(
        (context) => TheatreRepositoryImpl(context.get(), context.get()),
        child: HomePage(),
      );
    },
    MovieDetailPage.routeName: (context, settings) {
      final movie = settings.arguments as Movie;

      return Provider<CommentRepository>.factory(
        (context) => CommentRepositoryImpl(
          context.get(),
          context.get(),
          context.get(),
        ),
        child: MovieDetailPage(movie: movie),
      );
    },
    AddCommentPage.routeName: (context, settings) {
      final movieId = settings.arguments as String;

      return BlocProvider<AddCommentBloc>(
        initBloc: (context) => AddCommentBloc(
          CommentRepositoryImpl(
            context.get(),
            context.get(),
            context.get(),
          ),
          movieId,
        ),
        child: AddCommentPage(),
      );
    },
    TicketsPage.routeName: (context, settings) {
      final arguments = settings.arguments as Map<String, dynamic>;

      return Provider<TicketRepository>.factory(
        (context) => TicketRepositoryImpl(context.get(), context.get()),
        child: TicketsPage(
          theatre: arguments['theatre'],
          showTime: arguments['showTime'],
          movie: arguments['movie'],
          fromMovieDetail: arguments['fromMovieDetail'] ?? true,
        ),
      );
    },
    ComboPage.routeName: (context, settings) {
      final arguments = settings.arguments as Map<String, dynamic>;

      return BlocProvider<ComboBloc>(
        initBloc: (context) => ComboBloc(
          ProductRepositoryImpl(
            context.get(),
            context.get(),
          ),
        )..fetch(),
        child: ComboPage(
          movie: arguments['movie'],
          tickets: arguments['tickets'],
          theatre: arguments['theatre'],
          showTime: arguments['showTime'],
        ),
      );
    },
    CheckoutPage.routeName: (context, settings) {
      final arguments = settings.arguments as Map<String, dynamic>;

      return BlocProvider<CheckoutBloc>(
        initBloc: (context) => CheckoutBloc(
          reservationRepository: context.get(),
          tickets: arguments['tickets'],
          showTime: arguments['showTime'],
          products: arguments['products'],
        ),
        child: CheckoutPage(
          tickets: arguments['tickets'],
          showTime: arguments['showTime'],
          theatre: arguments['theatre'],
          movie: arguments['movie'],
          products: arguments['products'],
        ),
      );
    },
    ...cardPages,
    DiscountsPage.routeName: (context, settings) {
      return Provider<PromotionRepository>.factory(
        (context) => PromotionRepositoryImpl(
          context.get(),
          context.get(),
        ),
        child: DiscountsPage(showTimeId: settings.arguments as String),
      );
    },
    ViewAllPage.routeName: (context, settings) {
      return ViewAllPage(movieType: settings.arguments as MovieType);
    },
    ShowTimesByTheatrePage.routeName: (context, settings) {
      return ShowTimesByTheatrePage(theatre: settings.arguments as Theatre);
    },
    SearchPage.routeName: (context, settings) =>
        SearchPage(query: settings.arguments as String),
  };

  static final profileRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) => ProfilePage(),
    UpdateProfilePage.routeName: (context, settings) =>
        UpdateProfilePage(user: settings.arguments as User),
    ReservationsPage.routeName: (context, settings) => ReservationsPage(),
    ReservationDetailPage.routeName: (context, settings) =>
        ReservationDetailPage(reservation: settings.arguments as Reservation),
    ...cardPages,
  };

  static final favoritesRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) => FavoritesPage(),
  };

  static final notificationsRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) {
      return Provider<NotificationRepository>.factory(
        (context) => NotificationRepositoryImpl(context.get(), context.get()),
        child: NotificationsPage(),
      );
    },
  };

  final appScaffoldKey = GlobalKey();
  Object? listenToken;
  Object? setupLocalNotification;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    listenToken ??= Provider.of<UserRepository>(context)
        .user$
        .where((optional) => optional is None)
        .take(1)
        .listen(onLoggedOut)
        .disposedBy(bag);

    setupLocalNotification ??= context
        .get<FcmNotificationManager>()
        .reservationId$
        .exhaustMap(
          (id) => context
              .get<ReservationRepository>()
              .getReservationById(id)
              .doOnListen(() => context.showLoading(s.loading))
              .doOnCancel(
                  () => Navigator.of(context, rootNavigator: true).pop())
              .doOnError((e, s) => context.showSnackBar(
                  S.of(context).error_with_message(getErrorMessage(e)))),
        )
        .doOnData((r) => AppScaffold.navigatorOfCurrentIndex(
                appScaffoldKey.currentContext!,
                switchToNewIndex: AppScaffoldIndex.profile)
            .pushNamedX(ReservationDetailPage.routeName, arguments: r))
        .collect()
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      key: appScaffoldKey,
      builders: [
        (context, settings) => homeRoutes[settings.name]!(context, settings),
        (context, settings) =>
            favoritesRoutes[settings.name]!(context, settings),
        (context, settings) =>
            notificationsRoutes[settings.name]!(context, settings),
        (context, settings) => profileRoutes[settings.name]!(context, settings),
      ],
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_rounded),
          label: S.of(context).home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_rounded),
          label: S.of(context).favorites,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.notifications),
          label: S.of(context).notifications,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_rounded),
          label: S.of(context).profile,
        ),
      ],
    );
  }

  void onLoggedOut(Optional<User>? _) async {
    context.showSnackBar(S.of(context).loggedOutSuccessfully);
    final navigatorState = Navigator.of(context);
    await delay(500);

    unawaited(
      navigatorState.pushNamedAndRemoveUntilX(
        LoginPage.routeName,
        (route) => false,
      ),
    );
  }
}
