import 'dart:developer';

import 'package:flutter/widgets.dart';

import 'package:fluro/fluro.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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
    _defineRouteW(router, SplashPage.route, const SplashPage());

    // Auth
    _defineRouteW(router, LoginPage.route, const LoginPage());

    // Authenticated pages
    _defineRouteW(router, HomePage.route, const HomePage());
    _defineRouteH(router, SettingsPage.route, settingsHandler());
  }

  static void _defineRouteW(FluroRouter router, String route, Widget widget) {
    router.define(
      route,
      handler: Handler(handlerFunc: (context, parameters) => widget),
      transitionType: TransitionType.cupertino,
    );
  }

  static void _defineRouteH(FluroRouter router, String route, Handler handler) {
    router.define(
      route,
      handler: handler,
      transitionType: TransitionType.cupertino,
    );
  }

  static Handler settingsHandler() {
    return Handler(
      handlerFunc: (context, parameters) {
        final args = context?.settings?.arguments as BluetoothDevice;
        return SettingsPage(device: args);
      },
    );
  }
}
