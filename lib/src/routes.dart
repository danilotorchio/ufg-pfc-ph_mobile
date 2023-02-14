import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:fluro/fluro.dart';

import 'pages/pages.dart';

class AppRoutes {
  static void configure(FluroRouter router) {
    router.notFoundHandler = Handler(
      handlerFunc: (context, parameters) {
        log('Route was not found $parameters');

        Future.delayed(
          Duration.zero,
          () => Navigator.of(context!).pushNamedAndRemoveUntil(
            HomePage.route,
            (route) => false,
          ),
        );

        return null;
      },
    );

    // Splash
    _defineRoute(router, SplashPage.route, const SplashPage());

    // Auth
    _defineRoute(router, LoginPage.route, const LoginPage());

    // Authenticated pages
    _defineRoute(router, HomePage.route, const HomePage());
  }

  static void _defineRoute(FluroRouter router, String route, Widget widget) {
    router.define(
      route,
      handler: Handler(handlerFunc: (context, parameters) => widget),
      transitionType: TransitionType.cupertino,
    );
  }
}
