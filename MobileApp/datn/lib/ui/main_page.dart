import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:pedantic/pedantic.dart';

import '../data/mappers.dart'
    show
        productResponseToProduct,
        cardResponseToCard,
        promotionResponseToPromotion;
import '../data/remote/auth_client.dart';
import '../data/repository/card_repository_impl.dart';
import '../data/repository/product_repository_impl.dart';
import '../data/repository/promotion_repository_impl.dart';
import '../domain/model/movie.dart';
import '../domain/model/user.dart';
import '../domain/repository/comment_repository.dart';
import '../domain/repository/promotion_repository.dart';
import '../domain/repository/reservation_repository.dart';
import '../domain/repository/user_repository.dart';
import '../generated/l10n.dart';
import '../utils/optional.dart';
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
  static final homeRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) => HomePage(),
    MovieDetailPage.routeName: (context, settings) {
      final movie = settings.arguments as Movie;
      return MovieDetailPage(movie: movie);
    },
    AddCommentPage.routeName: (context, settings) {
      final repo = Provider.of<CommentRepository>(context);
      final movieId = settings.arguments as String;

      return BlocProvider<AddCommentBloc>(
        child: AddCommentPage(),
        initBloc: () => AddCommentBloc(repo, movieId),
      );
    },
    TicketsPage.routeName: (context, settings) {
      final arguments = settings.arguments as Map<String, dynamic>;

      return TicketsPage(
        theatre: arguments['theatre'],
        showTime: arguments['showTime'],
        movie: arguments['movie'],
        fromMovieDetail: arguments['fromMovieDetail'] ?? true,
      );
    },
    ComboPage.routeName: (context, settings) {
      final authClient = Provider.of<AuthClient>(context);
      final arguments = settings.arguments as Map<String, dynamic>;

      return BlocProvider<ComboBloc>(
        initBloc: () => ComboBloc(
          ProductRepositoryImpl(
            authClient,
            productResponseToProduct,
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
      final reservationRepository = Provider.of<ReservationRepository>(context);

      return BlocProvider<CheckoutBloc>(
        child: CheckoutPage(
          tickets: arguments['tickets'],
          showTime: arguments['showTime'],
          theatre: arguments['theatre'],
          movie: arguments['movie'],
          products: arguments['products'],
        ),
        initBloc: () => CheckoutBloc(
          reservationRepository: reservationRepository,
          tickets: arguments['tickets'],
          showTime: arguments['showTime'],
          products: arguments['products'],
        ),
      );
    },
    CardsPage.routeName: (context, settings) {
      final authClient = Provider.of<AuthClient>(context);

      return BlocProvider<CardsBloc>(
        child: CardsPage(),
        initBloc: () => CardsBloc(
          CardRepositoryImpl(
            authClient,
            cardResponseToCard,
          ),
          settings.arguments,
        ),
      );
    },
    AddCardPage.routeName: (context, settings) {
      final authClient = Provider.of<AuthClient>(context);

      return BlocProvider<AddCardBloc>(
        child: AddCardPage(),
        initBloc: () => AddCardBloc(
          CardRepositoryImpl(
            authClient,
            cardResponseToCard,
          ),
        ),
      );
    },
    DiscountsPage.routeName: (context, settings) {
      final authClient = Provider.of<AuthClient>(context);

      return Provider<PromotionRepository>(
        value: PromotionRepositoryImpl(
          authClient,
          promotionResponseToPromotion,
        ),
        child: DiscountsPage(showTimeId: settings.arguments as String),
      );
    },
    ViewAllPage.routeName: (context, settings) {
      return ViewAllPage(movieType: settings.arguments);
    },
    ShowTimesByTheatrePage.routeName: (context, settings) {
      return ShowTimesByTheatrePage(theatre: settings.arguments);
    },
    SearchPage.routeName: (context, settings) =>
        SearchPage(query: settings.arguments),
  };

  static final profileRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) => ProfilePage(),
    UpdateProfilePage.routeName: (context, settings) {
      final args = settings.arguments;
      assert(args != null && args is User);
      return UpdateProfilePage(user: args);
    },
    ReservationsPage.routeName: (context, settings) => ReservationsPage(),
    ReservationDetailPage.routeName: (context, settings) {
      return ReservationDetailPage(
        reservation: settings.arguments,
      );
    },
  };

  static final favoritesRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) => FavoritesPage(),
  };

  static final notificationsRoutes = <String, AppScaffoldWidgetBuilder>{
    Navigator.defaultRouteName: (context, settings) => NotificationsPage(),
  };

  dynamic listenToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listenToken ??= Provider.of<UserRepository>(context)
        .user$
        .where((userOptional) => userOptional != null && userOptional is None)
        .take(1)
        .listen(onLoggedOut)
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      builders: [
        (context, settings) => homeRoutes[settings.name](context, settings),
        (context, settings) =>
            favoritesRoutes[settings.name](context, settings),
        (context, settings) =>
            notificationsRoutes[settings.name](context, settings),
        (context, settings) => profileRoutes[settings.name](context, settings),
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

  void onLoggedOut(Optional<User> _) async {
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
