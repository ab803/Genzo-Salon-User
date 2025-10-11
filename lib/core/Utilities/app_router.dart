import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Auth/signIn/signInView.dart';
import 'package:userbarber/Feature/Auth/signUp/signUpView.dart';
import 'package:userbarber/Feature/Booking/BookingHistory.dart';
import 'package:userbarber/Feature/Booking/BookingView.dart';
import 'package:userbarber/Feature/Booking/Widgets/ServiceView.dart';
import 'package:userbarber/Feature/Booking/Widgets/selectedServices.dart';
import 'package:userbarber/Feature/Cart/CartView.dart';
import 'package:userbarber/Feature/Cart/orderDetials.dart';
import 'package:userbarber/Feature/Cart/orderhistory.dart';
import 'package:userbarber/Feature/Home/HomeView.dart';
import 'package:userbarber/Feature/Search/SearchView.dart';
import 'package:userbarber/Feature/SplashView/SplashView.dart';
import 'package:userbarber/core/Models/OrderModel.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

CustomTransitionPage buildPageWithTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.1, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: animation.drive(tween),
          child: child,
        ),
      );
    },
  );
}

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => buildPageWithTransition(state, SplashView()),
    ),
    GoRoute(
      path: '/signIn',
      pageBuilder: (context, state) => buildPageWithTransition(state, SignInView()),
    ),
    GoRoute(
      path: '/signUp',
      pageBuilder: (context, state) => buildPageWithTransition(state, SignUpView()),
    ),

    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => buildPageWithTransition(state, HomeView()),
    ),

    GoRoute(
      path: '/cart',
      pageBuilder: (context, state) => buildPageWithTransition(state, CartView()),
    ),
    GoRoute(
      path: '/booking',
      pageBuilder: (context, state) => buildPageWithTransition(state, BookingView()),
    ),
    GoRoute(
      path: '/orderHistory',
      pageBuilder: (context, state) => buildPageWithTransition(state, OrderHistoryScreen()),
    ),
    GoRoute(
      path: '/orderDetails',
      pageBuilder: (context, state) =>
          buildPageWithTransition(state, OrderDetailsView(order: state.extra as OrderModel)),
    ),
    GoRoute(
      path: '/bookingHistory',
      pageBuilder: (context, state) => buildPageWithTransition(state, BookingHistoryView()),
    ),
    GoRoute(
      path: '/services',
      pageBuilder: (context, state) => buildPageWithTransition(state, const ServiceView()),
    ),
    GoRoute(
      path: '/selected',
      pageBuilder: (context, state) => buildPageWithTransition(state, const SelectedServicesList()),
    ),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) => buildPageWithTransition(state, SearchView()),
    ),
  ],
);
